[CmdletBinding()]
param(
    [string]$ProjectRoot = $PSScriptRoot,
    [string]$OutputPath = (Join-Path $PSScriptRoot "HighDimProb.zip")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-NormalizedFullPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    return [System.IO.Path]::GetFullPath($Path).TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar
    )
}

$root = Get-NormalizedFullPath -Path (Resolve-Path -LiteralPath $ProjectRoot).ProviderPath
$rootWithSeparator = $root + [System.IO.Path]::DirectorySeparatorChar

$outputFullPath = [System.IO.Path]::GetFullPath(
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
)
$outputParent = Split-Path -Parent $outputFullPath

if (-not (Test-Path -LiteralPath $outputParent)) {
    New-Item -ItemType Directory -Path $outputParent | Out-Null
}

if (Test-Path -LiteralPath $outputFullPath) {
    Remove-Item -LiteralPath $outputFullPath -Force
}

$excludedRootDirectoryNames = @(".lake", ".github")
$items = New-Object "System.Collections.Generic.List[System.IO.FileSystemInfo]"

foreach ($topLevelItem in Get-ChildItem -LiteralPath $root -Force) {
    if ($topLevelItem.PSIsContainer -and $excludedRootDirectoryNames -contains $topLevelItem.Name) {
        continue
    }

    $items.Add($topLevelItem)

    if ($topLevelItem.PSIsContainer) {
        foreach ($childItem in Get-ChildItem -LiteralPath $topLevelItem.FullName -Recurse -Force) {
            $items.Add($childItem)
        }
    }
}

$archive = [System.IO.Compression.ZipFile]::Open($outputFullPath, [System.IO.Compression.ZipArchiveMode]::Create)

try {
    foreach ($item in $items) {
        $itemFullPath = [System.IO.Path]::GetFullPath($item.FullName)

        if ([string]::Equals($itemFullPath, $outputFullPath, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }

        if (-not $itemFullPath.StartsWith($rootWithSeparator, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }

        $relativePath = $itemFullPath.Substring($rootWithSeparator.Length).Replace("\", "/")

        if ($item.PSIsContainer) {
            $hasChildren = $null -ne (Get-ChildItem -LiteralPath $item.FullName -Force | Select-Object -First 1)
            if (-not $hasChildren) {
                [void]$archive.CreateEntry($relativePath.TrimEnd("/") + "/")
            }
            continue
        }

        [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $archive,
            $itemFullPath,
            $relativePath,
            [System.IO.Compression.CompressionLevel]::Optimal
        )
    }
}
finally {
    $archive.Dispose()
}

Write-Host "Created archive: $outputFullPath"
Write-Host "Excluded directories: $root\.lake, $root\.github"
