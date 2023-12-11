#!/usr/bin/env pwsh

# Variables
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$exe_path = "${env:TEMP}/surfshark.exe"

# Check if running as an administrator
if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error 'Please run as administrator'
    exit 1
}

# Download Surfshark
Invoke-WebRequest -Uri "https://downloads.surfshark.com/windows/latest/SurfsharkSetup.exe" `
    -OutFile $exe_path

# Install Surfshark
$exe_path

exit $LASTEXITCODE
