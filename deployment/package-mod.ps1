param(
    [Parameter(Mandatory=$true)] [string]$ArmaToolsPath,
    [string]$OutputRoot = "$PSScriptRoot\..\dist\@RHD-LifeServer",
    [switch]$IncludeServerConfig
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$addonBuilder = Join-Path $ArmaToolsPath "AddonBuilder.exe"
$source = Join-Path $repoRoot "addons\rhd_lifeserver"

if (-not (Test-Path $addonBuilder)) { throw "AddonBuilder.exe not found: $addonBuilder" }
if (-not (Test-Path $source)) { throw "Addon source not found: $source" }

if (Test-Path $OutputRoot) { Remove-Item -Recurse -Force $OutputRoot }
New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $OutputRoot "addons") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $OutputRoot "keys") | Out-Null

$addonOutput = Join-Path $OutputRoot "addons"
& $addonBuilder $source $addonOutput -clear
if ($LASTEXITCODE -ne 0) { throw "AddonBuilder failed with exit code $LASTEXITCODE" }

# Local-mod metadata and deployment documentation.
$rootFiles = @("README.md", "SETUP.txt", "LICENSE-RHD.md", "THIRD_PARTY_CREDITS.md", "PBO-Info.txt")
foreach ($name in $rootFiles) {
    $path = Join-Path $repoRoot $name
    if (Test-Path $path) { Copy-Item $path (Join-Path $OutputRoot $name) -Force }
}

$modCpp = @'
name = "RHD-LifeServer";
author = "LT. Toad";
description = "RHD-LifeServer - Altis Life roleplay server framework overlay";
logo = "";
logoOver = "";
logoSmall = "";
actionName = "RHD-LifeServer";
action = "https://github.com/heinrich4551-netizen/RHD-LifeServer";
'@
Set-Content -Path (Join-Path $OutputRoot "mod.cpp") -Value $modCpp -Encoding UTF8

$dependencyNote = @'
RHD-LifeServer local-mod package

The keys directory is intentionally empty until the server owner supplies or generates
an RHD-LifeServer signing key with Arma 3 DSCreateKey. Do not invent or reuse a key.

Required runtime dependency:
- SimplePersist (Steam Workshop ID 3006691432)

The upstream AsYetUntitled Framework remains a separate submodule/source dependency
and is not modified or repackaged here because its CC BY-NC-ND 4.0 license prohibits
unauthorized derivative redistribution.
'@
Set-Content -Path (Join-Path $OutputRoot "keys\README.txt") -Value $dependencyNote -Encoding UTF8

if ($IncludeServerConfig) {
    $serverOut = Join-Path $OutputRoot "server"
    New-Item -ItemType Directory -Force -Path $serverOut | Out-Null
    foreach ($dir in @("config", "database")) {
        $src = Join-Path $repoRoot $dir
        if (Test-Path $src) { Copy-Item $src (Join-Path $serverOut $dir) -Recurse -Force }
    }
}

$zipPath = "$OutputRoot.zip"
if (Test-Path $zipPath) { Remove-Item -Force $zipPath }
Compress-Archive -Path $OutputRoot -DestinationPath $zipPath -CompressionLevel Optimal

Write-Host "Created local Arma 3 mod folder: $OutputRoot"
Write-Host "Created package archive: $zipPath"
Write-Host "Install by placing the @RHD-LifeServer folder beside the Arma 3 executable/server root."
