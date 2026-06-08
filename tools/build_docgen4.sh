#!/usr/bin/env bash
set -euo pipefail

source_mode="github"
disable_equations=0

usage() {
  cat <<'USAGE'
Usage: ./tools/build_docgen4.sh [--source github|file|vscode] [--disable-equations]

Build HighDimProb documentation through doc-gen4.

By default, source links point to GitHub and the generated index/navbar are
postprocessed to put HighDimProb first. Use --source file or --source vscode for
local-only source links.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source)
      if [[ $# -lt 2 ]]; then
        echo "error: --source requires github, file, or vscode" >&2
        exit 2
      fi
      source_mode="$2"
      shift 2
      ;;
    --source=*)
      source_mode="${1#--source=}"
      shift
      ;;
    --disable-equations)
      disable_equations=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$source_mode" in
  github|file|vscode) ;;
  *)
    echo "error: --source must be github, file, or vscode" >&2
    exit 2
    ;;
esac

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/.." && pwd)"
docbuild="$repo_root/docbuild"

export DOCGEN_SRC="$source_mode"
if [[ "$disable_equations" -eq 1 ]]; then
  export DISABLE_EQUATIONS=1
else
  unset DISABLE_EQUATIONS || true
fi

# Git Bash on this Windows checkout can use the sibling user-local MinGW.
# Linux/macOS CI normally already has cc on PATH, so this block is optional.
mingw_bin="$(cd -- "$repo_root/../../../mingw64/bin" 2>/dev/null && pwd || true)"
if [[ -n "$mingw_bin" && -x "$mingw_bin/gcc.exe" ]]; then
  if [[ ! -e "$mingw_bin/cc.exe" ]]; then
    cp "$mingw_bin/gcc.exe" "$mingw_bin/cc.exe"
  fi
  export PATH="$mingw_bin:$PATH"
fi

cd "$docbuild"
lake build HighDimProb:docs

doc_dir="$docbuild/.lake/build/doc"

if [[ "$source_mode" == "github" ]]; then
  python3 - "$repo_root" "$doc_dir" <<'PY'
from pathlib import Path
from urllib.parse import unquote
import os
import re
import subprocess
import sys

repo_root = Path(sys.argv[1]).resolve()
doc_dir = Path(sys.argv[2]).resolve()


def git(cwd: Path, *args: str) -> str | None:
    try:
        result = subprocess.run(
            ["git", *args],
            cwd=str(cwd),
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
        )
    except (OSError, subprocess.CalledProcessError):
        return None
    return result.stdout.strip()


def github_base(remote: str) -> str | None:
    if remote.startswith("git@github.com:") and remote.endswith(".git"):
        return "https://github.com/" + remote[len("git@github.com:"):-len(".git")]
    if remote.startswith("https://github.com/"):
        return remote[:-len(".git")] if remote.endswith(".git") else remote
    return None


def repo_info(root: Path) -> tuple[str, str] | None:
    remote = git(root, "remote", "get-url", "origin")
    commit = git(root, "rev-parse", "HEAD")
    if remote is None or commit is None:
        return None
    base = github_base(remote)
    if base is None:
        return None
    return base, commit


repos: list[tuple[Path, str, str]] = []
for root in [repo_root, *(repo_root / ".lake" / "packages").glob("*")]:
    if not (root / ".git").exists():
        continue
    info = repo_info(root)
    if info is None:
        continue
    repos.append((root.resolve(), info[0], info[1]))

repos.sort(key=lambda item: len(item[0].as_posix()), reverse=True)


def resolve_file_url(path_text: str) -> Path | None:
    try:
        return Path(unquote(path_text)).resolve()
    except OSError:
        return None


def rel_to(path: Path, root: Path) -> str | None:
    try:
        return path.relative_to(root).as_posix()
    except ValueError:
        path_s = path.as_posix()
        root_s = root.as_posix()
        if path_s.lower().startswith(root_s.lower().rstrip("/") + "/"):
            return path_s[len(root_s.rstrip("/")) + 1:]
    return None


href_re = re.compile(r'(href=")file://([^"#]+?\.lean)(#[^"]*)?(")')
replacement_count = 0


def replace_href(match: re.Match[str]) -> str:
    global replacement_count
    prefix, path_text, fragment, suffix = match.groups()
    path = resolve_file_url(path_text)
    if path is None:
        return match.group(0)
    for root, base, commit in repos:
        rel = rel_to(path, root)
        if rel is not None:
            url = f"{base}/blob/{commit}/{rel}"
            replacement_count += 1
            return f"{prefix}{url}{fragment or ''}{suffix}"
    return match.group(0)


project_html_paths = [doc_dir / "HighDimProb.html"]
project_html_paths.extend((doc_dir / "HighDimProb").rglob("*.html"))

for html_path in project_html_paths:
    if not html_path.exists():
        continue
    text = html_path.read_text(encoding="utf-8")
    new_text = href_re.sub(replace_href, text)
    if new_text != text:
        html_path.write_text(new_text, encoding="utf-8")

print(f"postprocess: rewrote {replacement_count} HighDimProb source links to GitHub URLs")
PY
fi

if [[ -f "$doc_dir/HighDimProb.html" ]]; then
  cat > "$doc_dir/index.html" <<'HTML'
<html lang="en"><head><meta charset="UTF-8"></meta><meta name="viewport" content="width=device-width, initial-scale=1"></meta><meta http-equiv="refresh" content="0; url=./HighDimProb.html"></meta><link rel="canonical" href="./HighDimProb.html"></link><link rel="stylesheet" href="./style.css"></link><link rel="icon" href="./favicon.svg"></link><link rel="mask-icon" href="./favicon.svg" color="#000000"></link><title>HighDimProb documentation</title><script>window.location.replace("./HighDimProb.html");</script></head><body><main><h1>HighDimProb documentation</h1><p><a href="./HighDimProb.html">Open the HighDimProb API documentation.</a></p></main></body></html>
HTML
fi

python3 - "$doc_dir/navbar.html" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
if not path.exists():
    raise SystemExit(0)

html = path.read_text(encoding="utf-8")
marker = '<h3>Library</h3><div class="module_list">'
start = html.find(marker)
needle = '<details class="nav_sect" data-path="./HighDimProb.html">'
high_start = html.find(needle)
if start == -1 or high_start == -1 or high_start < start:
    raise SystemExit(0)

depth = 0
pos = high_start
high_end = -1
while pos < len(html):
    next_open = html.find("<details", pos)
    next_close = html.find("</details>", pos)
    if next_close == -1:
        break
    if next_open != -1 and next_open < next_close:
        depth += 1
        pos = next_open + len("<details")
    else:
        depth -= 1
        pos = next_close + len("</details>")
        if depth == 0:
            high_end = pos
            break

if high_end == -1:
    raise SystemExit(0)

block = html[high_start:high_end]
html_without = html[:high_start] + html[high_end:]
insert_at = html_without.find(marker)
if insert_at == -1:
    raise SystemExit(0)
insert_at += len(marker)
new_html = html_without[:insert_at] + block + html_without[insert_at:]
path.write_text(new_html, encoding="utf-8")
PY
