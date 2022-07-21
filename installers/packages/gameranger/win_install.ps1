#!/usr/bin/env pwsh

# Variables
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$exe_path = "${env:TEMP}/gameranger.exe"

# Check if running as an administrator
if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error 'Please run as administrator'
    exit 1
}

# Download GameRanger
Invoke-WebRequest -Uri "http://www.gameranger.com/download/GameRangerSetup.exe" `
    -OutFile $exe_path

# Install GameRanger
$exe_path

exit $LASTEXITCODE
