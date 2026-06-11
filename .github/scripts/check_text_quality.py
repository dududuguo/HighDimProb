#!/usr/bin/env python3
"""Reject common text encoding damage in tracked source and docs files."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


TEXT_SUFFIXES = {
    ".css",
    ".html",
    ".json",
    ".lean",
    ".md",
    ".ps1",
    ".py",
    ".sh",
    ".svg",
    ".toml",
    ".txt",
    ".yml",
    ".yaml",
}

TEXT_BASENAMES = {
    ".cbmignore",
    ".gitattributes",
    ".gitignore",
    "LICENSE",
    "lean-toolchain",
}

BAD_PATTERNS = {
    "\ufffd": "Unicode replacement character, usually from a broken decode",
    "\u951f": "Chinese mojibake marker, often from double-decoded UTF-8",
    "\u00c3": "Latin-1 mojibake marker for UTF-8 text",
    "\u00c2": "Latin-1 mojibake marker for UTF-8 text",
    "\u00e2\u20ac": "mojibake marker for UTF-8 punctuation",
}


def git_files() -> list[Path]:
    result = subprocess.run(
        ["git", "ls-files", "-z"],
        check=True,
        stdout=subprocess.PIPE,
    )
    return [Path(p.decode("utf-8")) for p in result.stdout.split(b"\0") if p]


def is_text_file(path: Path) -> bool:
    return path.suffix in TEXT_SUFFIXES or path.name in TEXT_BASENAMES


def line_col(text: str, index: int) -> tuple[int, int]:
    line = text.count("\n", 0, index) + 1
    line_start = text.rfind("\n", 0, index) + 1
    return line, index - line_start + 1


def main() -> int:
    failures: list[str] = []

    for path in git_files():
        if not is_text_file(path):
            continue

        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError as exc:
            failures.append(f"{path}: invalid UTF-8: {exc}")
            continue

        for pattern, reason in BAD_PATTERNS.items():
            start = 0
            while True:
                index = text.find(pattern, start)
                if index == -1:
                    break
                line, col = line_col(text, index)
                shown = pattern.encode("unicode_escape").decode("ascii")
                failures.append(f"{path}:{line}:{col}: {shown}: {reason}")
                start = index + len(pattern)

    if failures:
        print("Text quality check failed. Fix the following encoding artifacts:")
        for failure in failures:
            print(f"  {failure}")
        return 1

    print("Text quality check passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
