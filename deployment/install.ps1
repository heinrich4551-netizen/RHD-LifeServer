param(
    [string]$ArmaServerPath = ".\arma3server_x64.exe",
    [string]$ProfilePath = ".\profiles",
    [string]$ConfigPath = ".\config\server.cfg"
)

$ErrorActionPreference = "Stop"

Write-Host "RHD-LifeServer deployment helper" -ForegroundColor Cyan

if (-not (Test-Path $ArmaServerPath)) {
    Write-Warning "Arma 3 server executable not found at $ArmaServerPath. Update the path before starting the server."
}

if (-not (Test-Path $ProfilePath)) {
    New-Item -ItemType Directory -Path $ProfilePath | Out-Null
}

Write-Host "Updating upstream framework submodule..."
git submodule update --init --recursive

Write-Host "Checking configuration template..."
if (-not (Test-Path $ConfigPath)) {
    throw "Missing server configuration: $ConfigPath"
}

Write-Host "Deployment preparation complete." -ForegroundColor Green
Write-Host "IMPORTANT: change all CHANGE_ME credentials before production use."
Write-Host "Start the server using your normal Arma 3 dedicated-server command line."
