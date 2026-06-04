#!/usr/bin/env python3
"""Export readable Graphviz views from the codebase-memory SQLite graph."""

from __future__ import annotations

import argparse
import shutil
import sqlite3
import subprocess
from pathlib import Path


def dot_quote(value: object) -> str:
    text = str(value)
    return '"' + text.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'


def short_name(qualified_name: str, file_path: str = "") -> str:
    if file_path:
        return file_path.removesuffix(".lean")
    parts = qualified_name.split(".")
    for marker in ("HighDimProbTest", "HighDimProb", "docs"):
        if marker in parts:
            return ".".join(parts[parts.index(marker) :])
    return parts[-1] if parts else qualified_name


def package_color(label: str) -> str:
    palette = {
        "Concentration": "#d9ead3",
        "RandomMatrix": "#cfe2f3",
        "LimitTheorems": "#fce5cd",
        "Distributions": "#eadcf8",
        "Scalar": "#fff2cc",
        "docs": "#eeeeee",
        "HighDimProbTest": "#f4cccc",
    }
    for key, color in palette.items():
        if key in label:
            return color
    return "#ffffff"


def write_module_imports(con: sqlite3.Connection, out_path: Path) -> None:
    rows = con.execute(
        """
        select s.id, s.qualified_name, s.file_path,
               t.id, t.qualified_name, t.file_path
        from edges e
        join nodes s on s.id = e.source_id
        join nodes t on t.id = e.target_id
        where e.type = 'IMPORTS'
          and s.label = 'File'
          and t.label = 'Module'
          and (s.file_path like 'HighDimProb%' or s.file_path like 'HighDimProbTest%')
          and (t.file_path like 'HighDimProb%' or t.file_path like 'HighDimProbTest%')
        order by s.file_path, t.file_path
        """
    ).fetchall()
    nodes: dict[int, tuple[str, str]] = {}
    edges: list[tuple[int, int]] = []
    for sid, sqn, sfile, tid, tqn, tfile in rows:
        nodes[sid] = (short_name(sqn, sfile), sfile)
        nodes[tid] = (short_name(tqn, tfile), tfile)
        edges.append((sid, tid))

    lines = [
        "digraph module_imports {",
        '  graph [rankdir=LR, overlap=false, splines=true, fontname="Arial"];',
        '  node [shape=box, style="rounded,filled", fontname="Arial", fontsize=10];',
        '  edge [color="#666666", arrowsize=0.7];',
    ]
    for node_id, (label, file_path) in sorted(nodes.items(), key=lambda item: item[1][0]):
        lines.append(
            f"  n{node_id} [label={dot_quote(label)}, fillcolor={dot_quote(package_color(file_path))}];"
        )
    for source_id, target_id in edges:
        lines.append(f"  n{source_id} -> n{target_id};")
    lines.append("}")
    out_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_call_hotspots(con: sqlite3.Connection, out_path: Path, top: int, callers_per_hotspot: int) -> None:
    hotspots = con.execute(
        """
        select n.id, n.name, n.qualified_name, n.file_path, count(*) as fan_in
        from nodes n
        join edges e on e.target_id = n.id
        where n.label = 'Function' and e.type = 'CALLS'
        group by n.id, n.name, n.qualified_name, n.file_path
        order by fan_in desc, n.name
        limit ?
        """,
        (top,),
    ).fetchall()
    hotspot_ids = [row[0] for row in hotspots]
    nodes: dict[int, tuple[str, str, bool]] = {}
    edges: list[tuple[int, int]] = []

    for node_id, name, _qn, file_path, fan_in in hotspots:
        nodes[node_id] = (f"{name}\\nfan-in: {fan_in}", file_path, True)
        caller_rows = con.execute(
            """
            select s.id, s.name, s.qualified_name, s.file_path
            from edges e
            join nodes s on s.id = e.source_id
            where e.type = 'CALLS' and e.target_id = ?
            order by s.file_path, s.name
            limit ?
            """,
            (node_id, callers_per_hotspot),
        ).fetchall()
        for caller_id, caller_name, _caller_qn, caller_file in caller_rows:
            nodes.setdefault(caller_id, (caller_name, caller_file, False))
            edges.append((caller_id, node_id))

    lines = [
        "digraph call_hotspots {",
        '  graph [rankdir=LR, overlap=false, splines=true, fontname="Arial"];',
        '  node [shape=box, style="rounded,filled", fontname="Arial", fontsize=10];',
        '  edge [color="#666666", arrowsize=0.7];',
    ]
    for node_id, (label, file_path, is_hotspot) in sorted(nodes.items(), key=lambda item: item[1][0]):
        fill = "#ffe599" if is_hotspot else package_color(file_path)
        penwidth = "2.0" if is_hotspot else "1.0"
        lines.append(
            f"  n{node_id} [label={dot_quote(label)}, fillcolor={dot_quote(fill)}, penwidth={penwidth}];"
        )
    for source_id, target_id in edges:
        lines.append(f"  n{source_id} -> n{target_id};")
    lines.append("}")
    out_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def render_svg(dot_path: Path) -> None:
    dot = shutil.which("dot")
    if not dot:
        raise SystemExit("Graphviz 'dot' command not found. Install Graphviz or omit --render.")
    svg_path = dot_path.with_suffix(".svg")
    subprocess.run([dot, "-Tsvg", str(dot_path), "-o", str(svg_path)], check=True)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--db", default="external/codebase-memory/HighDimProb.db")
    parser.add_argument("--out-dir", default="external/codebase-memory/graphviz")
    parser.add_argument("--top-hotspots", type=int, default=12)
    parser.add_argument("--callers-per-hotspot", type=int, default=16)
    parser.add_argument("--render", action="store_true", help="Render SVG files with Graphviz dot.")
    args = parser.parse_args()

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(args.db) as con:
        module_dot = out_dir / "module-imports.dot"
        hotspots_dot = out_dir / "call-hotspots.dot"
        write_module_imports(con, module_dot)
        write_call_hotspots(con, hotspots_dot, args.top_hotspots, args.callers_per_hotspot)

    if args.render:
        render_svg(module_dot)
        render_svg(hotspots_dot)

    print(f"Wrote Graphviz views to {out_dir}")


if __name__ == "__main__":
    main()
