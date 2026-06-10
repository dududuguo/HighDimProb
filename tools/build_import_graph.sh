#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/.." && pwd)"

cd "$repo_root"
lake exe graph --to HighDimProb \
  ./docs/visualizations/lake_import_graph.dot \
  ./docs/visualizations/lake_import_graph.html
