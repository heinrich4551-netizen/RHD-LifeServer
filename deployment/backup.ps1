param(
    [string]$BackupRoot = ".\backups",
    [string]$MySqlDumpPath = "mysqldump.exe",
    [string]$ConfigDirectory = ".\config",
    [string]$DatabaseExtensions = ".\database\rhd_extensions.sql"
)

$ErrorActionPreference = "Stop"

function Require-EnvironmentVariable([string]$Name) {
    $value = [Environment]::GetEnvironmentVariable($Name)
    if ([string]::IsNullOrWhiteSpace($value)) {
        throw "Required environment variable '$Name' is not set."
    }
    return $value
}

$databaseHost = Require-EnvironmentVariable "RHD_DB_HOST"
$databaseName = Require-EnvironmentVariable "RHD_DB_NAME"
$databaseUser = Require-EnvironmentVariable "RHD_DB_USER"
$databasePassword = Require-EnvironmentVariable "RHD_DB_PASSWORD"

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$destination = Join-Path $BackupRoot $timestamp
New-Item -ItemType Directory -Force -Path $destination | Out-Null

Write-Host "RHD-LifeServer backup: $timestamp" -ForegroundColor Cyan

if (-not (Test-Path $MySqlDumpPath)) {
    throw "mysqldump was not found at '$MySqlDumpPath'."
}

$dumpFile = Join-Path $destination "$databaseName.sql"
$env:MYSQL_PWD = $databasePassword
try {
    & $MySqlDumpPath --host=$databaseHost --user=$databaseUser --single-transaction --routines --events --triggers $databaseName | Out-File -FilePath $dumpFile -Encoding utf8
    if ($LASTEXITCODE -ne 0) {
        throw "mysqldump failed with exit code $LASTEXITCODE."
    }
}
finally {
    Remove-Item Env:MYSQL_PWD -ErrorAction SilentlyContinue
}

if (Test-Path $ConfigDirectory) {
    Copy-Item -Path $ConfigDirectory -Destination (Join-Path $destination "config") -Recurse -Force
}

if (Test-Path $DatabaseExtensions) {
    Copy-Item -Path $DatabaseExtensions -Destination (Join-Path $destination "rhd_extensions.sql") -Force
}

$manifest = @{
    timestamp = (Get-Date).ToString("o")
    database = $databaseName
    databaseHost = $databaseHost
    backupDirectory = (Resolve-Path $destination).Path
}
$manifest | ConvertTo-Json | Set-Content -Path (Join-Path $destination "manifest.json") -Encoding utf8

Write-Host "Backup completed: $destination" -ForegroundColor Green
