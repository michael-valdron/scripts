#!/usr/bin/env pwsh

# Variables
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

# Check if running as an administrator
if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error 'Please run as administrator'
    exit 1
}

# Check if winget is installed
try {
    # Install git if winget is installed
    winget install git
}
catch {
    # If not, install winget then git
    Write-Output 'winget is not installed, attempting install..'
    $winget_version = (Invoke-WebRequest "https://api.github.com/repos/microsoft/winget-cli/releases/latest" | ConvertFrom-Json)[0].tag_name
    $winget_package = "${env:TEMP}/winget.msixbundle"
    Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/$winget_version/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" `
        -OutFile $winget_package
    Add-AppxPackage -Path $winget_package -Confirm

    try {
        winget install git
    }
    catch {
        Write-Error 'winget did not install correctly'
        exit 2
    }
}

# Using git, download and install the Windows 10 Debloater scripts to debloat Windows
try {
    $windebloater_root = "${env:TEMP}/windows10debloater"
    git clone "https://github.com/Sycnex/Windows10Debloater.git" $windebloater_root
    Set-ExecutionPolicy Unrestricted -Force
    "$windebloater_root\Windows10SysPrepDebloater.ps1 -SysPrep -Debloat -Privacy"
    exit $LASTEXITCODE
}
catch {
    Write-Error 'git did not install correctly'
    exit 3
}
