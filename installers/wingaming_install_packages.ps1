#!/usr/bin/env pwsh

# Variables
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$base_dir = (Get-Item $MyInvocation.MyCommand.Path).Directory.FullName

# Check if running as an administrator
if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error 'Please run as administrator'
    exit 1
}

# Run base setup
powershell.exe -executionpolicy bypass "$base_dir/win_setup.ps1"
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

# Update packages
winget upgrade -h --all

# Install packages
winget install -h Waterfox.Waterfox Microsoft.WindowsTerminal OBSProject.OBSStudio `
    Discord.Discord Valve.Steam ElectronicArts.EADesktop DolphinEmulator.Dolphin `
    Mupen64.Mupen64 DOSBox.DOSBox Duplicati.Duplicati --source winget
if ($LASTEXITCODE -ne 0) {
    Write-Error 'Failed to install winget packages.'
    exit $LASTEXITCODE
}

# Install Surfshark
powershell.exe -executionpolicy bypass "$base_dir/packages/surfshark/win_install.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Error 'Surfshark failed to install.'
    exit $LASTEXITCODE
}

# Install GameRanger
powershell.exe -executionpolicy bypass "$base_dir/packages/gameranger/win_install.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Error 'GameRanger failed to install.'
    exit $LASTEXITCODE
}

# Install Well Of Souls
powershell.exe -executionpolicy bypass "$base_dir/packages/wos/win_install.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Error 'Well Of Souls failed to install.'
    exit $LASTEXITCODE
}
