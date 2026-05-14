param(
    [switch]$SkipRun
)

$ErrorActionPreference = "Stop"

$RepoRoot = $PSScriptRoot
$VenvPath = Join-Path $RepoRoot ".venv"
$PythonInVenv = Join-Path $VenvPath "Scripts\python.exe"
$RequirementsFile = Join-Path $RepoRoot "requirements.txt"
$ScriptToRun = Join-Path $RepoRoot "mdns_browse.py"

if (-not (Test-Path $RequirementsFile)) {
    throw "requirements.txt not found at $RequirementsFile"
}

if (-not (Test-Path $ScriptToRun)) {
    throw "mdns_browse.py not found at $ScriptToRun"
}

if (-not (Test-Path $PythonInVenv)) {
    Write-Host "Creating virtual environment at $VenvPath..."
    py -m venv $VenvPath
}

Write-Host "Upgrading pip in virtual environment..."
& $PythonInVenv -m pip install --upgrade pip

Write-Host "Installing dependencies from requirements.txt..."
& $PythonInVenv -m pip install -r $RequirementsFile

if (-not $SkipRun) {
    Write-Host "Running mdns_browse.py..."
    & $PythonInVenv $ScriptToRun
} else {
    Write-Host "Setup complete. Skipped running script because -SkipRun was provided."
}
