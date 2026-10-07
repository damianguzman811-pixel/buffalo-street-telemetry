[CmdletBinding()]
param(
  [string]$PythonPath = 'python.exe',
  [string]$OutputDirectory
)

$ErrorActionPreference = 'Stop'
$projectRoot = $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
  $OutputDirectory = Join-Path $projectRoot '..\..\outputs'
}
& $PythonPath (Join-Path $projectRoot 'scripts\generate_config.py')
if ($LASTEXITCODE -ne 0) { throw 'Config generation failed.' }
& $PythonPath (Join-Path $projectRoot 'scripts\preflight.py')
if ($LASTEXITCODE -ne 0) { throw 'Sheet preflight failed; package was not built.' }

$out = [System.IO.Path]::GetFullPath($OutputDirectory)
New-Item -ItemType Directory -Force -Path $out | Out-Null
$archive = Join-Path $out 'buffalo-street-telemetry-v0.1.3.zip'
if (Test-Path -LiteralPath $archive) {
  throw "Refusing to overwrite existing package: $archive"
}
Compress-Archive -Path (Join-Path $projectRoot '*') -DestinationPath $archive -CompressionLevel Optimal
Write-Output "Built $archive"

