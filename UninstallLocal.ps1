[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$CyberpunkPath
)

$ErrorActionPreference = 'Stop'
$cpRoot = (Resolve-Path -LiteralPath $CyberpunkPath).Path
$modsRoot = Join-Path $cpRoot 'bin\x64\plugins\cyber_engine_tweaks\mods'
$target = Join-Path $modsRoot 'BuffaloStreetTelemetry'
$marker = Join-Path $target 'prototype.marker'
$expectedMarker = 'Buffalo Street Telemetry local prototype v0.1.3'

if (-not (Test-Path -LiteralPath $marker -PathType Leaf)) {
  throw "Prototype marker not found; nothing removed: $marker"
}
if ((Get-Content -LiteralPath $marker -Raw).Trim() -ne $expectedMarker) {
  throw "Folder marker does not match this prototype; nothing removed: $target"
}

$modsFull = [System.IO.Path]::GetFullPath($modsRoot).TrimEnd('\') + '\'
$targetFull = [System.IO.Path]::GetFullPath($target)
if (-not $targetFull.StartsWith($modsFull, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw "Resolved removal target escaped the CET mods directory; nothing removed: $targetFull"
}
Remove-Item -LiteralPath $targetFull -Recurse -Force
Write-Output "Removed only $targetFull"

