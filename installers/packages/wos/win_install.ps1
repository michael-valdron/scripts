#!/usr/bin/env pwsh

# Variables
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$exe_path = "${env:TEMP}/wos.exe"

# Check if running as an administrator
if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error 'Please run as administrator'
    exit 1
}

# Download Well Of Souls
Invoke-WebRequest -Uri "http://www.synthetic-reality.us/WellOfSouls.exe" `
    -OutFile $exe_path

# Install Well Of Souls
$exe_path

exit $LASTEXITCODE
