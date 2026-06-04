#!/usr/bin/env python3
"""Write metadata for the checked-in codebase-memory SQLite graph."""

from __future__ import annotations

import argparse
import json
import sqlite3
from datetime import datetime, timezone
from pathlib import Path
from pathlib import PurePosixPath


ARCHITECTURE_LAYERS = {
    "entry": ["Concentration", "Isotropic", "MetricEntropy", "RandomMatrix"],
    "core": [
        "Distributions",
        "Expectation",
        "Nets",
        "RandomVariable",
        "RandomVector",
        "Scalar",
        "SubGaussian",
        "Tail",
    ],
    "internal": ["Covariance"],
}


def dict_counts(cur: sqlite3.Cursor, query: str) -> dict[str, int]:
    return {name: count for name, count in cur.execute(query)}


def module_packages(cur: sqlite3.Cursor) -> list[str]:
    packages: set[str] = set()
    rows = cur.execute(
        """
        select file_path
        from nodes
        where label = 'Module'
        """
    )
    for (file_path,) in rows:
        path = PurePosixPath(file_path)
        parts = path.parts
        if len(parts) < 2 or parts[0] != "HighDimProb":
            continue
        package = parts[1]
        if package.endswith(".lean"):
            package = package.removesuffix(".lean")
        packages.add(package)
    return sorted(packages)


def hotspots(cur: sqlite3.Cursor, limit: int = 5) -> list[str]:
    rows = cur.execute(
        """
        select n.name, count(*) as fan_in
        from nodes n
        join edges e on e.target_id = n.id
        where n.label = 'Function' and e.type = 'CALLS'
        group by n.id, n.name
        order by fan_in desc, n.name
        limit ?
        """,
        (limit,),
    )
    return [f"{name} (fan_in: {fan_in})" for name, fan_in in rows]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--db", default="external/codebase-memory/HighDimProb.db")
    parser.add_argument("--out", default="external/codebase-memory/metadata.json")
    parser.add_argument("--project", default="HighDimProb")
    args = parser.parse_args()

    db_path = Path(args.db)
    out_path = Path(args.out)

    with sqlite3.connect(db_path) as con:
        cur = con.cursor()
        project_row = cur.execute(
            "select name, indexed_at, root_path from projects order by indexed_at desc limit 1"
        ).fetchone()
        indexed_at = project_row[1] if project_row else None
        graph_stats = {
            "total_nodes": cur.execute("select count(*) from nodes").fetchone()[0],
            "total_edges": cur.execute("select count(*) from edges").fetchone()[0],
            "node_labels": dict_counts(
                cur,
                "select label, count(*) from nodes group by label order by count(*) desc",
            ),
            "edge_types": dict_counts(
                cur,
                "select type, count(*) from edges group by type order by count(*) desc",
            ),
            "packages": module_packages(cur),
            "top_hotspots": hotspots(cur),
            "architecture_layers": ARCHITECTURE_LAYERS,
        }

    metadata = {
        "project": args.project,
        "generated_at": datetime.now(timezone.utc).date().isoformat(),
        "indexed_at": indexed_at,
        "tool": "codebase-memory-mcp",
        "graph_stats": graph_stats,
        "database_file": db_path.name,
        "database_size_bytes": db_path.stat().st_size,
    }

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
