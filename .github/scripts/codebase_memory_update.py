#!/usr/bin/env python3
"""Refresh the checked-in codebase-memory graph artifacts."""

from __future__ import annotations

import argparse
import json
import os
import shutil
import sqlite3
import subprocess
import sys
from pathlib import Path


DEFAULT_DB_OUT = Path("external/codebase-memory/HighDimProb.db")
DEFAULT_ARTIFACT = Path(".codebase-memory/graph.db.zst")
DEFAULT_ARTIFACT_JSON = Path(".codebase-memory/artifact.json")


def run(cmd: list[str], *, env: dict[str, str] | None = None, cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
    proc = subprocess.run(cmd, cwd=cwd, env=env, text=True, capture_output=True)
    if proc.stdout:
        print(proc.stdout, end="")
    if proc.stderr:
        print(proc.stderr, end="", file=sys.stderr)
    if proc.returncode != 0:
        raise SystemExit(proc.returncode)
    return proc


def find_cbm_binary(explicit: str | None) -> str:
    candidates: list[str] = []
    if explicit:
        candidates.append(explicit)
    env_bin = os.getenv("CODEBASE_MEMORY_MCP_BIN")
    if env_bin:
        candidates.append(env_bin)
    path_bin = shutil.which("codebase-memory-mcp")
    if path_bin:
        candidates.append(path_bin)
    candidates.extend(
        [
            str(Path.home() / ".local" / "bin" / "codebase-memory-mcp.exe"),
            str(Path.home() / ".local" / "bin" / "codebase-memory-mcp"),
            str(
                Path.home()
                / "AppData"
                / "Local"
                / "Programs"
                / "codebase-memory-mcp"
                / "codebase-memory-mcp.exe"
            ),
        ]
    )
    for candidate in candidates:
        if candidate and Path(candidate).exists():
            return candidate
    raise SystemExit("codebase-memory-mcp binary not found. Install DeusData/codebase-memory-mcp first.")


def parse_tool_json(stdout: str) -> dict[str, object]:
    for line in stdout.splitlines():
        line = line.strip()
        if not line.startswith("{"):
            continue
        try:
            data = json.loads(line)
        except json.JSONDecodeError:
            continue
        if "project" in data:
            return data
    raise SystemExit("Could not parse codebase-memory-mcp JSON output.")


def parse_first_json(stdout: str) -> dict[str, object]:
    for line in stdout.splitlines():
        line = line.strip()
        if not line.startswith("{"):
            continue
        try:
            return json.loads(line)
        except json.JSONDecodeError:
            continue
    return {}


def default_cache_dir() -> Path:
    env_cache = os.getenv("CBM_CACHE_DIR")
    if env_cache:
        return Path(env_cache)
    return Path.home() / ".cache" / "codebase-memory-mcp"


def find_generated_db(cache_dir: Path, project: str | None) -> Path:
    if project:
        direct = cache_dir / f"{project}.db"
        if direct.exists():
            return direct
    candidates = [p for p in cache_dir.glob("*.db") if p.name != "_config.db"]
    if not candidates:
        raise SystemExit(f"No generated codebase-memory database found in {cache_dir}")
    return max(candidates, key=lambda p: p.stat().st_size)


def git_head(repo: Path) -> str:
    proc = subprocess.run(["git", "rev-parse", "HEAD"], cwd=repo, text=True, capture_output=True)
    return proc.stdout.strip() if proc.returncode == 0 else ""


def same_path(left: str, right: Path) -> bool:
    if not left:
        return False
    try:
        return Path(left).resolve() == right.resolve()
    except OSError:
        return left.replace("\\", "/").rstrip("/") == str(right).replace("\\", "/").rstrip("/")


def delete_existing_project(cbm: str, env: dict[str, str], repo: Path) -> None:
    proc = subprocess.run([cbm, "cli", "list_projects"], cwd=repo, env=env, text=True, capture_output=True)
    if proc.returncode != 0:
        return
    data = parse_first_json(proc.stdout)
    projects = data.get("projects", [])
    if not isinstance(projects, list):
        return
    for project in projects:
        if not isinstance(project, dict):
            continue
        name = str(project.get("name") or "")
        root_path = str(project.get("root_path") or "")
        if not name or not same_path(root_path, repo):
            continue
        payload = json.dumps({"project": name})
        run([cbm, "cli", "delete_project", payload], env=env, cwd=repo)


def db_summary(db_path: Path) -> dict[str, object]:
    with sqlite3.connect(db_path) as con:
        cur = con.cursor()
        project_row = cur.execute(
            "select name, indexed_at, root_path from projects order by indexed_at desc limit 1"
        ).fetchone()
        return {
            "project": project_row[0] if project_row else "",
            "indexed_at": project_row[1] if project_row else "",
            "nodes": cur.execute("select count(*) from nodes").fetchone()[0],
            "edges": cur.execute("select count(*) from edges").fetchone()[0],
        }


def write_artifact_json(repo: Path, db_path: Path, artifact: Path, out_path: Path) -> None:
    summary = db_summary(db_path)
    data = {
        "schema_version": 1,
        "commit": git_head(repo),
        "indexed_at": summary["indexed_at"],
        "project": summary["project"],
        "nodes": summary["nodes"],
        "edges": summary["edges"],
        "original_size": db_path.stat().st_size,
        "compressed_size": artifact.stat().st_size if artifact.exists() else 0,
        "compression_level": 9,
    }
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(data, indent=4) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", default=".", help="Repository path to index.")
    parser.add_argument("--mode", default="full", choices=["full", "moderate", "fast"])
    parser.add_argument("--cache-dir", default=None, help="codebase-memory cache directory.")
    parser.add_argument("--cbm-bin", default=None, help="Path to codebase-memory-mcp binary.")
    parser.add_argument("--db-out", default=str(DEFAULT_DB_OUT))
    parser.add_argument("--artifact", default=str(DEFAULT_ARTIFACT))
    parser.add_argument("--artifact-json", default=str(DEFAULT_ARTIFACT_JSON))
    parser.add_argument("--metadata-script", default=".github/scripts/codebase_memory_metadata.py")
    parser.add_argument("--incremental", action="store_true", help="Do not delete the existing project before indexing.")
    args = parser.parse_args()

    repo = Path(args.repo).resolve()
    cache_dir = Path(args.cache_dir).resolve() if args.cache_dir else default_cache_dir().resolve()
    db_out = Path(args.db_out)
    artifact = Path(args.artifact)
    artifact_json = Path(args.artifact_json)
    metadata_script = Path(args.metadata_script)

    cache_dir.mkdir(parents=True, exist_ok=True)
    db_out.parent.mkdir(parents=True, exist_ok=True)
    artifact.parent.mkdir(parents=True, exist_ok=True)

    backup = artifact.with_suffix(artifact.suffix + ".bak")
    if artifact.exists():
        if backup.exists():
            backup.unlink()
        artifact.replace(backup)

    env = os.environ.copy()
    env["CBM_CACHE_DIR"] = str(cache_dir)
    cbm = find_cbm_binary(args.cbm_bin)
    payload = json.dumps({"repo_path": str(repo), "mode": args.mode, "persistence": True})

    if not args.incremental:
        delete_existing_project(cbm, env, repo)

    try:
        proc = run([cbm, "cli", "index_repository", payload], env=env, cwd=repo)
    except BaseException:
        if backup.exists() and not artifact.exists():
            backup.replace(artifact)
        raise

    if not artifact.exists():
        if backup.exists():
            backup.replace(artifact)
        raise SystemExit(f"{artifact} was not written by codebase-memory-mcp.")

    if backup.exists():
        backup.unlink()

    result = parse_tool_json(proc.stdout)
    generated_db = find_generated_db(cache_dir, str(result.get("project") or ""))
    shutil.copy2(generated_db, db_out)

    run([sys.executable, str(metadata_script), "--db", str(db_out)], cwd=repo)
    write_artifact_json(repo, db_out, artifact, artifact_json)

    summary = db_summary(db_out)
    print(
        f"Refreshed {db_out}: project={summary['project']} "
        f"nodes={summary['nodes']} edges={summary['edges']}"
    )


if __name__ == "__main__":
    main()
