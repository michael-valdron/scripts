#!/usr/bin/env pwsh

# Variables
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$tag = (Invoke-WebRequest "https://api.github.com/repos/xournalpp/xournalpp/releases/latest" | ConvertFrom-Json)[0].tag_name
$version = $version.substring(1)
$unzip_path = "${env:TEMP}/xournalpp"
$zip_path = "$unzip_path.zip"

# Check if running as an administrator
if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error 'Please run as administrator'
    exit 1
}

# Download Xournalpp
Invoke-WebRequest -Uri "https://github.com/xournalpp/xournalpp/releases/download/$tag/xournalpp-$version-windows.zip" `
    -OutFile $zip_path

# Extract Installer
Expand-Archive $zip_path -DestinationPath $unzip_path

# Install Xournalpp
"$unzip_path/xournalpp-$version-windows.exe"

exit $LASTEXITCODE
