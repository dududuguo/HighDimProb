#!/usr/bin/env python3
"""Policy checks for the HighDimProb judge suite."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEAN_ROOTS = [
    ROOT / "HighDimProb",
    ROOT / "HighDimProbTest",
    ROOT / "HighDimProbJudge",
]
LEAN_ROOT_FILES = [
    ROOT / "HighDimProb.lean",
    ROOT / "HighDimProbTest.lean",
    ROOT / "HighDimProbJudge.lean",
]
FORBIDDEN_RE = re.compile(r"\b(sorry|admit|axiom|unsafe)\b")
DECL_START_RE = re.compile(r"^\s*(theorem|lemma|def|abbrev|axiom)\b")
PUBLIC_SIGNATURE_DECL_RE = re.compile(
    r"^\s*(theorem|lemma|def|abbrev|structure|class|instance)\b"
)
TRUE_BODY_RE = re.compile(r":=\s*True\b")
EXPERIMENTAL_IMPORT_RE = re.compile(r"^\s*import\s+HighDimProb\.Experimental\b")
EXPERIMENTAL_JUDGE_PREFIXES = [
    "HighDimProbJudge/Experimental/",
]
PUBLIC_SIGNATURE_LAMBDA_CHECK_PREFIXES = [
    "HighDimProb/Examples/",
]
PUBLIC_SIGNATURE_LAMBDA_RE = re.compile(r"(^|\s|=)\(?\s*fun\b.*=>")


def lean_files() -> list[Path]:
    files: list[Path] = []
    for root in LEAN_ROOTS:
        if root.exists():
            files.extend(sorted(root.rglob("*.lean")))
    files.extend(path for path in LEAN_ROOT_FILES if path.exists())
    return sorted(set(files))


def rel(path: Path) -> str:
    return path.relative_to(ROOT).as_posix()


def non_comment_lines(path: Path) -> list[tuple[int, str]]:
    lines: list[tuple[int, str]] = []
    for idx, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        stripped = line.strip()
        if stripped.startswith("--") or stripped.startswith("/-") or stripped.startswith("*"):
            continue
        lines.append((idx, line))
    return lines


def check_forbidden_tokens(files: list[Path]) -> list[str]:
    errors: list[str] = []
    for path in files:
        for line_no, line in non_comment_lines(path):
            match = FORBIDDEN_RE.search(line)
            if match:
                errors.append(f"{rel(path)}:{line_no}: forbidden token {match.group(1)!r}")
    return errors


def check_true_declarations(files: list[Path]) -> list[str]:
    errors: list[str] = []
    for path in files:
        current_start: int | None = None
        current_lines: list[str] = []

        def flush() -> None:
            nonlocal current_start, current_lines
            if current_start is not None:
                body = " ".join(line.strip() for line in current_lines)
                if TRUE_BODY_RE.search(body):
                    errors.append(
                        f"{rel(path)}:{current_start}: declaration has body True"
                    )
            current_start = None
            current_lines = []

        for line_no, line in non_comment_lines(path):
            if DECL_START_RE.match(line):
                flush()
                current_start = line_no
                current_lines = [line]
            elif current_start is not None:
                if not line.strip():
                    flush()
                else:
                    current_lines.append(line)
        flush()
    return errors


def check_public_signature_lambdas(files: list[Path]) -> list[str]:
    errors: list[str] = []

    def should_check(path: Path) -> bool:
        path_rel = rel(path)
        return any(
            path_rel.startswith(prefix)
            for prefix in PUBLIC_SIGNATURE_LAMBDA_CHECK_PREFIXES
        )

    def is_finite_sum_line(line: str) -> bool:
        return "Finset." in line and "fun" in line

    for path in files:
        if not should_check(path):
            continue

        current_start: int | None = None
        current_kind: str | None = None
        current_lines: list[tuple[int, str]] = []

        def split_signature_line(kind: str | None, line: str) -> tuple[str, bool]:
            if kind in {"theorem", "lemma"}:
                before_body, sep, _after_body = line.partition(":= by")
                return before_body, bool(sep)
            before_body, sep, _after_body = line.partition(":=")
            return before_body, bool(sep)

        def flush() -> None:
            nonlocal current_start, current_kind, current_lines
            if current_start is not None:
                for line_no, line in current_lines:
                    if is_finite_sum_line(line):
                        continue
                    if PUBLIC_SIGNATURE_LAMBDA_RE.search(line):
                        errors.append(
                            f"{rel(path)}:{line_no}: anonymous function in public "
                            "declaration signature; introduce a named def/abbrev"
                        )
            current_start = None
            current_kind = None
            current_lines = []

        for line_no, line in non_comment_lines(path):
            match = PUBLIC_SIGNATURE_DECL_RE.match(line)
            if match:
                flush()
                current_start = line_no
                current_kind = match.group(1)
                before_body, has_body = split_signature_line(current_kind, line)
                current_lines = [(line_no, before_body)]
                if has_body and current_kind != "structure":
                    flush()
            elif current_start is not None:
                before_body, has_body = split_signature_line(current_kind, line)
                current_lines.append((line_no, before_body))
                if has_body and current_kind != "structure":
                    flush()
        flush()

    return errors


def check_stable_root_import() -> list[str]:
    root_file = ROOT / "HighDimProb.lean"
    if not root_file.exists():
        return ["HighDimProb.lean is missing"]
    for line_no, line in non_comment_lines(root_file):
        if line.strip() == "import HighDimProb.Experimental":
            return [f"HighDimProb.lean:{line_no}: stable root imports experimental aggregate"]
    return []


def is_experimental_judge_path(path: Path) -> bool:
    path_rel = rel(path)
    return any(path_rel.startswith(prefix) for prefix in EXPERIMENTAL_JUDGE_PREFIXES)


def check_judge_import_policy(files: list[Path]) -> list[str]:
    errors: list[str] = []
    judge_paths = {
        path
        for path in files
        if rel(path) == "HighDimProbJudge.lean"
        or rel(path).startswith("HighDimProbJudge/")
    }
    for path in sorted(judge_paths):
        if is_experimental_judge_path(path):
            continue
        for line_no, line in non_comment_lines(path):
            if EXPERIMENTAL_IMPORT_RE.match(line):
                errors.append(
                    f"{rel(path)}:{line_no}: judge file imports HighDimProb.Experimental"
                )
    return errors


def judge_module_name(path: Path) -> str:
    rel_path = path.relative_to(ROOT).with_suffix("")
    return ".".join(rel_path.parts)


def check_judge_root_imports() -> list[str]:
    root_file = ROOT / "HighDimProbJudge.lean"
    judge_dir = ROOT / "HighDimProbJudge"
    if not root_file.exists():
        return ["HighDimProbJudge.lean is missing"]
    root_imports = {
        line.strip().split(maxsplit=1)[1]
        for _line_no, line in non_comment_lines(root_file)
        if line.strip().startswith("import ")
    }
    expected = {
        judge_module_name(path)
        for path in sorted(judge_dir.rglob("*.lean"))
    }
    missing = sorted(expected - root_imports)
    return [f"HighDimProbJudge.lean missing import {module}" for module in missing]


def main() -> int:
    files = lean_files()
    errors: list[str] = []
    errors.extend(check_forbidden_tokens(files))
    errors.extend(check_true_declarations(files))
    errors.extend(check_public_signature_lambdas(files))
    errors.extend(check_stable_root_import())
    errors.extend(check_judge_import_policy(files))
    errors.extend(check_judge_root_imports())

    if errors:
        print("judge policy check failed")
        for error in errors:
            print(f"- {error}")
        return 1

    print("judge policy check passed")
    print(f"checked Lean files: {len(files)}")
    print("stable root import boundary: ok")
    print("judge experimental import boundary: ok")
    print("judge root imports: ok")
    print("public signature lambda policy: ok")
    return 0


if __name__ == "__main__":
    sys.exit(main())
