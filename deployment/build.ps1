param(
    [Parameter(Mandatory=$true)] [string]$ArmaToolsPath,
    [string]$OutputPath = "$PSScriptRoot\..\dist"
)

$ErrorActionPreference = "Stop"
$addonBuilder = Join-Path $ArmaToolsPath "AddonBuilder.exe"
$source = Join-Path $PSScriptRoot "..\addons\rhd_lifeserver"

if (-not (Test-Path $addonBuilder)) { throw "AddonBuilder.exe not found: $addonBuilder" }
if (-not (Test-Path $source)) { throw "Addon source not found: $source" }

New-Item -ItemType Directory -Force -Path $OutputPath | Out-Null
& $addonBuilder $source (Join-Path $OutputPath "RHD_LifeServer") -clear
if ($LASTEXITCODE -ne 0) { throw "AddonBuilder failed with exit code $LASTEXITCODE" }

Write-Host "Built RHD_LifeServer PBO into $OutputPath"
