#!/usr/bin/env python3
"""Enforce the public, append-only HighDimProb Judge ledger."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path, PurePosixPath


ROOT = Path(__file__).resolve().parents[1]
MANIFEST_REL = ".github/judge-lock.json"
JUDGE_ROOT_REL = "HighDimProbJudge.lean"
JUDGE_DIR_REL = "HighDimProbJudge"
HASH_RE = re.compile(r"[0-9a-f]{64}")
IMPORT_RE = re.compile(r"import (HighDimProbJudge(?:\.[A-Za-z0-9_']+)+)")
MODULE_PART_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_']*")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def validate_judge_path(value: object) -> str | None:
    if not isinstance(value, str) or not value:
        return "manifest paths must be nonempty strings"
    if "\\" in value:
        return f"manifest path must use POSIX separators: {value!r}"
    path = PurePosixPath(value)
    if path.is_absolute() or any(part in {"", ".", ".."} for part in path.parts):
        return f"manifest path is not normalized: {value!r}"
    if len(path.parts) < 2 or path.parts[0] != JUDGE_DIR_REL:
        return f"manifest path is outside {JUDGE_DIR_REL}/: {value!r}"
    if path.suffix != ".lean":
        return f"manifest path is not a Lean file: {value!r}"
    module_parts = list(path.parts[1:-1]) + [path.stem]
    if any(MODULE_PART_RE.fullmatch(part) is None for part in module_parts):
        return f"manifest path does not form a Lean module name: {value!r}"
    return None


def parse_manifest_text(text: str, source: str) -> tuple[dict[str, str] | None, list[str]]:
    def reject_duplicate_keys(pairs: list[tuple[str, object]]) -> dict[str, object]:
        result: dict[str, object] = {}
        for key, value in pairs:
            if key in result:
                raise ValueError(f"duplicate JSON key {key!r}")
            result[key] = value
        return result

    try:
        payload = json.loads(text, object_pairs_hook=reject_duplicate_keys)
    except (json.JSONDecodeError, ValueError) as error:
        return None, [f"{source}: invalid JSON: {error}"]

    errors: list[str] = []
    if not isinstance(payload, dict):
        return None, [f"{source}: top-level value must be an object"]
    if set(payload) != {"schema_version", "files"}:
        errors.append(f"{source}: expected exactly schema_version and files keys")
    if payload.get("schema_version") != 1:
        errors.append(f"{source}: schema_version must be 1")
    files = payload.get("files")
    if not isinstance(files, dict):
        errors.append(f"{source}: files must be an object")
        return None, errors

    parsed: dict[str, str] = {}
    for path, digest in files.items():
        path_error = validate_judge_path(path)
        if path_error:
            errors.append(f"{source}: {path_error}")
            continue
        if not isinstance(digest, str) or HASH_RE.fullmatch(digest) is None:
            errors.append(f"{source}: invalid SHA-256 for {path!r}")
            continue
        parsed[path] = digest
    return (None if errors else parsed), errors


def read_manifest(root: Path) -> tuple[dict[str, str] | None, list[str]]:
    path = root / MANIFEST_REL
    if not path.is_file():
        return None, [f"{MANIFEST_REL} is missing; run --bootstrap once"]
    return parse_manifest_text(path.read_text(encoding="utf-8"), MANIFEST_REL)


def write_text_atomic(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    mode = path.stat().st_mode & 0o777 if path.exists() else 0o644
    descriptor, temporary_name = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    temporary = Path(temporary_name)
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8") as handle:
            handle.write(text)
        temporary.chmod(mode)
        os.replace(temporary, path)
    finally:
        if temporary.exists():
            temporary.unlink()


def manifest_text(files: dict[str, str]) -> str:
    payload = {"schema_version": 1, "files": dict(sorted(files.items()))}
    return json.dumps(payload, indent=2) + "\n"


def write_manifest(root: Path, files: dict[str, str]) -> None:
    path = root / MANIFEST_REL
    write_text_atomic(path, manifest_text(files))


def discover_judge_files(root: Path) -> tuple[set[str], list[str]]:
    judge_dir = root / JUDGE_DIR_REL
    errors: list[str] = []
    files: set[str] = set()
    if not judge_dir.is_dir():
        return files, [f"{JUDGE_DIR_REL}/ is missing"]
    for path in judge_dir.rglob("*"):
        if path.is_symlink():
            errors.append(f"Judge paths must not be symlinks: {path.relative_to(root).as_posix()}")
        elif path.is_file() and path.suffix == ".lean":
            files.add(path.relative_to(root).as_posix())
    return files, errors


def module_name(path: str) -> str:
    return path.removesuffix(".lean").replace("/", ".")


def parse_root_imports(root: Path) -> tuple[list[str] | None, list[str]]:
    path = root / JUDGE_ROOT_REL
    if not path.is_file():
        return None, [f"{JUDGE_ROOT_REL} is missing"]
    imports: list[str] = []
    errors: list[str] = []
    for line_no, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        match = IMPORT_RE.fullmatch(line)
        if match is None:
            errors.append(
                f"{JUDGE_ROOT_REL}:{line_no}: expected one exact HighDimProbJudge import"
            )
        else:
            imports.append(match.group(1))
    if len(imports) != len(set(imports)):
        errors.append(f"{JUDGE_ROOT_REL}: duplicate imports are forbidden")
    return (None if errors else imports), errors


def validate_tree(root: Path, manifest: dict[str, str]) -> list[str]:
    files, errors = discover_judge_files(root)
    locked = set(manifest)
    for path in sorted(locked - files):
        errors.append(f"locked Judge file is missing: {path}")
    for path in sorted(files - locked):
        errors.append(f"unregistered Judge file: {path}; use --add {path}")
    for path in sorted(files & locked):
        actual = sha256_file(root / path)
        if actual != manifest[path]:
            errors.append(f"locked Judge file was modified: {path}")

    imports, import_errors = parse_root_imports(root)
    errors.extend(import_errors)
    if imports is not None:
        actual_modules = set(imports)
        expected_modules = {module_name(path) for path in manifest}
        for name in sorted(expected_modules - actual_modules):
            errors.append(f"{JUDGE_ROOT_REL} missing import {name}")
        for name in sorted(actual_modules - expected_modules):
            errors.append(f"{JUDGE_ROOT_REL} has unregistered import {name}")
    return errors


def compare_locked_entries(base: dict[str, str], candidate: dict[str, str]) -> list[str]:
    errors: list[str] = []
    for path, digest in sorted(base.items()):
        if path not in candidate:
            errors.append(f"locked manifest entry was deleted or renamed: {path}")
        elif candidate[path] != digest:
            errors.append(f"locked manifest hash was changed: {path}")
    return errors


def git_manifest(root: Path, revision: str) -> tuple[dict[str, str] | None, list[str]]:
    commit = subprocess.run(
        ["git", "cat-file", "-e", f"{revision}^{{commit}}"],
        cwd=root,
        capture_output=True,
        text=True,
    )
    if commit.returncode != 0:
        return None, [f"Git revision is unavailable: {revision}"]
    shown = subprocess.run(
        ["git", "show", f"{revision}:{MANIFEST_REL}"],
        cwd=root,
        capture_output=True,
        text=True,
    )
    if shown.returncode != 0:
        exists = subprocess.run(
            ["git", "cat-file", "-e", f"{revision}:{MANIFEST_REL}"],
            cwd=root,
            capture_output=True,
            text=True,
        )
        if exists.returncode != 0:
            return None, []
        return None, [f"could not read {revision}:{MANIFEST_REL}"]
    return parse_manifest_text(shown.stdout, f"{revision}:{MANIFEST_REL}")


def bootstrap(root: Path) -> list[str]:
    if (root / MANIFEST_REL).exists():
        return [f"{MANIFEST_REL} already exists; bootstrap cannot refresh locked hashes"]
    files, errors = discover_judge_files(root)
    imports, import_errors = parse_root_imports(root)
    errors.extend(import_errors)
    expected_modules = {module_name(path) for path in files}
    if imports is not None and set(imports) != expected_modules:
        errors.append(f"{JUDGE_ROOT_REL} must import every current Judge file before bootstrap")
    if errors:
        return errors
    write_manifest(root, {path: sha256_file(root / path) for path in files})
    return []


def add_files(root: Path, requested: list[str]) -> list[str]:
    manifest, errors = read_manifest(root)
    if manifest is None:
        return errors

    base, base_errors = git_manifest(root, "HEAD")
    errors.extend(base_errors)
    if base is not None:
        errors.extend(compare_locked_entries(base, manifest))

    normalized: list[str] = []
    for value in requested:
        path_error = validate_judge_path(value)
        if path_error:
            errors.append(path_error)
        elif value in normalized:
            errors.append(f"Judge path was requested twice: {value}")
        else:
            normalized.append(value)
    requested_set = set(normalized)
    for path in sorted(requested_set & set(manifest)):
        errors.append(f"Judge file is already locked and cannot be re-added: {path}")

    files, discovery_errors = discover_judge_files(root)
    errors.extend(discovery_errors)
    for path in sorted(set(manifest) - files):
        errors.append(f"locked Judge file is missing: {path}")
    for path in sorted(files - set(manifest) - requested_set):
        errors.append(f"unregistered Judge file was not passed to --add: {path}")
    for path in sorted(requested_set - files):
        errors.append(f"requested Judge file does not exist: {path}")
    for path, digest in sorted(manifest.items()):
        if path in files and sha256_file(root / path) != digest:
            errors.append(f"locked Judge file was modified: {path}")

    imports, import_errors = parse_root_imports(root)
    errors.extend(import_errors)
    if imports is not None:
        expected_old = {module_name(path) for path in manifest}
        if set(imports) != expected_old:
            errors.append(f"{JUDGE_ROOT_REL} must match the locked manifest before --add")
    if errors:
        return errors

    updated = dict(manifest)
    for path in sorted(requested_set):
        updated[path] = sha256_file(root / path)
    manifest_path = root / MANIFEST_REL
    root_path = root / JUDGE_ROOT_REL
    new_imports = [f"import {module_name(path)}" for path in sorted(requested_set)]
    old_manifest_text = manifest_path.read_text(encoding="utf-8")
    old_root_text = root_path.read_text(encoding="utf-8")
    new_root_text = old_root_text.rstrip("\n") + "\n" + "\n".join(new_imports) + "\n"
    try:
        write_manifest(root, updated)
        write_text_atomic(root_path, new_root_text)
    except OSError as error:
        write_text_atomic(manifest_path, old_manifest_text)
        write_text_atomic(root_path, old_root_text)
        return [f"could not update Judge ledger: {error}"]

    post_errors = validate_tree(root, updated)
    if post_errors:
        write_text_atomic(manifest_path, old_manifest_text)
        write_text_atomic(root_path, old_root_text)
    return post_errors


def verify(root: Path, base_revision: str | None) -> list[str]:
    manifest, errors = read_manifest(root)
    if manifest is None:
        return errors
    errors.extend(validate_tree(root, manifest))
    revision = base_revision or "HEAD"
    base, base_errors = git_manifest(root, revision)
    errors.extend(base_errors)
    if base is not None:
        errors.extend(compare_locked_entries(base, manifest))
    return errors


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    actions = parser.add_mutually_exclusive_group()
    actions.add_argument("--bootstrap", action="store_true", help="create the initial lock once")
    actions.add_argument("--add", nargs="+", metavar="PATH", help="lock new Judge files")
    parser.add_argument("--base", metavar="REV", help="compare locked entries with a Git base")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if args.bootstrap and args.base:
        print("judge append-only check failed\n- --bootstrap cannot be combined with --base")
        return 1
    if args.add is not None and args.base:
        print("judge append-only check failed\n- --add cannot be combined with --base")
        return 1

    if args.bootstrap:
        errors = bootstrap(ROOT)
    elif args.add is not None:
        errors = add_files(ROOT, args.add)
    else:
        errors = verify(ROOT, args.base)

    if errors:
        print("judge append-only check failed")
        for error in errors:
            print(f"- {error}")
        return 1
    print("judge append-only check passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
