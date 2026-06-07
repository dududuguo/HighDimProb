param(
  [switch]$DisableEquations,
  [ValidateSet("github", "file", "vscode")]
  [string]$Source = "file"
)

$ErrorActionPreference = "Stop"

$env:DOCGEN_SRC = $Source
if ($DisableEquations) {
  $env:DISABLE_EQUATIONS = "1"
} else {
  Remove-Item Env:DISABLE_EQUATIONS -ErrorAction SilentlyContinue
}

Push-Location (Join-Path $PSScriptRoot "..")
try {
  Push-Location .\docbuild
  try {
    $mingwBin = "..\..\..\mingw64\bin"
    $gcc = Join-Path $mingwBin "gcc.exe"
    $cc = Join-Path $mingwBin "cc.exe"

    if (Test-Path $gcc) {
      if (-not (Test-Path $cc)) {
        Copy-Item -LiteralPath $gcc -Destination $cc
      }
      $env:PATH = "$mingwBin;$env:PATH"
    }

    lake build HighDimProb:docs
  } finally {
    Pop-Location
  }
} finally {
  Pop-Location
}
