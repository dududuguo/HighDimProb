$ErrorActionPreference = "Stop"

Push-Location (Join-Path $PSScriptRoot "..")
try {
  lake exe graph --to HighDimProb `
    .\docs\visualizations\lake_import_graph.dot `
    .\docs\visualizations\lake_import_graph.html
} finally {
  Pop-Location
}
