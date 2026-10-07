[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$CyberpunkPath,
  [Parameter(Mandatory = $true)][string]$GtaPath,
  [switch]$NoLaunch
)

$ErrorActionPreference = 'Stop'
$projectRoot = $PSScriptRoot

$cpRoot = (Resolve-Path -LiteralPath $CyberpunkPath).Path
$gtaRoot = (Resolve-Path -LiteralPath $GtaPath).Path
$cpExe = Join-Path $cpRoot 'bin\x64\Cyberpunk2077.exe'
$cetRoot = Join-Path $cpRoot 'bin\x64\plugins\cyber_engine_tweaks'
$modsRoot = Join-Path $cetRoot 'mods'
$gtaExe = Join-Path $gtaRoot 'GTA5.exe'
$archive = Join-Path $gtaRoot 'update\update.rpf'
$rage = Join-Path $projectRoot 'tools\rage-windows-x86_64.exe'
$modFolderName = 'BuffaloStreetTelemetry'
$modTarget = Join-Path $modsRoot $modFolderName
$markerName = 'prototype.marker'
$expectedMarker = 'Buffalo Street Telemetry local prototype v0.1.3'

foreach ($required in @($cpExe, $gtaExe, $archive, (Join-Path (Split-Path -Parent $cetRoot) 'cyber_engine_tweaks.asi'), $rage)) {
  if (-not (Test-Path -LiteralPath $required -PathType Leaf)) {
    throw "Required file not found: $required"
  }
}
if (-not (Test-Path -LiteralPath $modsRoot -PathType Container)) {
  throw "CET mods directory not found: $modsRoot"
}
if (Test-Path -LiteralPath $modTarget) {
  throw "Refusing to overwrite an existing mod folder: $modTarget. Remove or rename that exact folder first if it is your previous prototype copy."
}
$principal = New-Object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())
$programFilesRoot = [System.IO.Path]::GetFullPath($env:ProgramFiles).TrimEnd('\') + '\'
if ($cpRoot.StartsWith($programFilesRoot, [System.StringComparison]::OrdinalIgnoreCase) -and
    -not $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Warning 'Cyberpunk is installed under Program Files. If the install step is denied, close this window and rerun from PowerShell opened with Run as administrator. This script will not elevate itself.'
}

$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("BuffaloStreetTelemetry-" + [guid]::NewGuid().ToString('N'))
$extractRoot = Join-Path $tempRoot 'extracted'
$cacheRoot = Join-Path $tempRoot 'rage-cache'
New-Item -ItemType Directory -Force -Path $extractRoot, $cacheRoot | Out-Null

try {
  # Keep all Rage CLI caches and extracted GTA metadata in this temporary directory.
  $env:RAGE_KEYS_CACHE = Join-Path $cacheRoot 'keys'
  $env:RAGE_NO_UPDATE_CHECK = '1'
  $env:RAGE_UPDATE_CACHE = Join-Path $cacheRoot 'update'
  $env:RAGE_NAMES = Join-Path $cacheRoot 'names.txt'
  $env:RAGE_CATALOG = Join-Path $cacheRoot 'catalog.sqlite'

  & $rage --exe $gtaExe extract $archive `
    'common/data/handling.meta' `
    'common/data/levels/gta5/vehicles.meta' `
    -o $extractRoot
  if ($LASTEXITCODE -ne 0) {
    throw "Rage CLI extraction failed with exit code $LASTEXITCODE. GTA V was not modified."
  }

  $handlingPath = Join-Path $extractRoot 'common\data\handling.meta'
  $vehiclesPath = Join-Path $extractRoot 'common\data\levels\gta5\vehicles.meta'
  if (-not (Test-Path -LiteralPath $handlingPath -PathType Leaf) -or -not (Test-Path -LiteralPath $vehiclesPath -PathType Leaf)) {
    throw 'The two requested GTA data records were not extracted. GTA V was not modified.'
  }

  [xml]$handlingDoc = Get-Content -LiteralPath $handlingPath -Raw
  [xml]$vehiclesDoc = Get-Content -LiteralPath $vehiclesPath -Raw
  $handlingNode = $handlingDoc.SelectSingleNode("/CHandlingDataMgr/HandlingData/Item[handlingName='BUFFALO']")
  $vehicleNode = $vehiclesDoc.SelectSingleNode("/CVehicleModelInfo__InitDataList/InitDatas/Item[modelName='buffalo']")
  if ($null -eq $handlingNode -or $null -eq $vehicleNode) {
    throw 'The stock Buffalo vehicle or handling record is missing from this GTA V build.'
  }
  $resolvedHandlingId = $vehicleNode.SelectSingleNode('handlingId').InnerText
  if ($resolvedHandlingId -ne 'BUFFALO') {
    throw "The GTA vehicle record resolved to unexpected handling ID '$resolvedHandlingId'."
  }

  function Get-ValueAttribute([System.Xml.XmlNode]$Node, [string]$Field) {
    $fieldNode = $Node.SelectSingleNode($Field)
    if ($null -eq $fieldNode -or -not $fieldNode.HasAttribute('value')) {
      throw "Required GTA field missing: $Field"
    }
    return $fieldNode.GetAttribute('value')
  }

  $profileLines = @(
    'profile_schema_version=1',
    ('generated_at_utc=' + [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()),
    'source_game=Grand Theft Auto V Legacy',
    ('model_name=' + $vehicleNode.SelectSingleNode('modelName').InnerText),
    ('brand=' + $vehicleNode.SelectSingleNode('vehicleMakeName').InnerText),
    ('vehicle_class=' + $vehicleNode.SelectSingleNode('vehicleClass').InnerText),
    ('handling_id=' + $resolvedHandlingId),
    ('fMass=' + (Get-ValueAttribute $handlingNode 'fMass')),
    ('fInitialDriveForce=' + (Get-ValueAttribute $handlingNode 'fInitialDriveForce')),
    ('nInitialDriveGears=' + (Get-ValueAttribute $handlingNode 'nInitialDriveGears')),
    ('fInitialDriveMaxFlatVel=' + (Get-ValueAttribute $handlingNode 'fInitialDriveMaxFlatVel')),
    ('fBrakeForce=' + (Get-ValueAttribute $handlingNode 'fBrakeForce')),
    ('fSteeringLock=' + (Get-ValueAttribute $handlingNode 'fSteeringLock')),
    ('fTractionCurveMax=' + (Get-ValueAttribute $handlingNode 'fTractionCurveMax')),
    ('fTractionCurveMin=' + (Get-ValueAttribute $handlingNode 'fTractionCurveMin')),
    ('fSuspensionForce=' + (Get-ValueAttribute $handlingNode 'fSuspensionForce'))
  )

  Copy-Item -LiteralPath (Join-Path $projectRoot 'src\CetMod') -Destination $modTarget -Recurse
  [System.IO.File]::WriteAllText((Join-Path $modTarget $markerName), $expectedMarker, (New-Object System.Text.UTF8Encoding($false)))
  [System.IO.File]::WriteAllText((Join-Path $modTarget 'profile.ini'), (($profileLines -join "`r`n") + "`r`n"), (New-Object System.Text.UTF8Encoding($false)))
  Write-Output "Installed additive CET folder: $modTarget"
  Write-Output 'Imported only the stock Buffalo scalar fields from the player-owned GTA V Legacy base update archive.'
  Write-Output 'GTA V was read-only; extracted metadata and Rage CLI caches are temporary.'

  if ($NoLaunch) {
    Write-Output 'NoLaunch selected; the companion profile is ready. Start Cyberpunk 2077 when convenient.'
    return
  }
  if (Get-Process -Name 'Cyberpunk2077' -ErrorAction SilentlyContinue) {
    Write-Output 'Cyberpunk2077.exe is already running; the newly installed CET mod will load on the next game start.'
    return
  }
  Start-Process -FilePath $cpExe -WorkingDirectory (Split-Path -Parent $cpExe)
  Write-Output 'Started Cyberpunk 2077.'
}
finally {
  if (Test-Path -LiteralPath $tempRoot) {
    $tempBase = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath()).TrimEnd('\') + '\'
    $tempFull = [System.IO.Path]::GetFullPath($tempRoot)
    if (-not $tempFull.StartsWith($tempBase, [System.StringComparison]::OrdinalIgnoreCase) -or
        (Split-Path -Leaf $tempFull) -notmatch '^BuffaloStreetTelemetry-[0-9a-f]{32}$') {
      throw "Refusing to remove an unexpected temporary path: $tempFull"
    }
    Remove-Item -LiteralPath $tempFull -Recurse -Force
  }
}

