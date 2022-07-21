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
winget install -h 7zip.7zip Waterfox.Waterfox Microsoft.VisualStudioCode Microsoft.VisualStudio.2022.Community `
    Microsoft.WindowsTerminal WinSCP.WinSCP GIMP.GIMP Adobe.Acrobat.Reader.64-bit TheDocumentFoundation.LibreOffice.LTS `
    KDE.Kdenlive OBSProject.OBSStudio calibre.calibre KeePassXCTeam.KeePassXC VideoLAN.VLC DelugeTeam.Deluge Cyanfish.NAPS2 `
    HandBrake.HandBrake Telegram.TelegramDesktop GuinpinSoft.MakeMKV SlackTechnologies.Slack Postman.Postman Microsoft.Skype `
    AnyDeskSoftwareGmbH.AnyDesk Foundry376.Mailspring Zotero.Zotero Balena.Etcher Duplicati.Duplicati OpenVPNTechnologies.OpenVPN `
    GnuPG.Gpg4win --source winget
if ($LASTEXITCODE -ne 0) {
    Write-Error 'Failed to install winget packages.'
    exit $LASTEXITCODE
}

# Install WSL
wsl --install -d openSUSE-42
if ($LASTEXITCODE -ne 0) {
    Write-Error 'Failed to install WSL.'
    exit $LASTEXITCODE
}

# Install Xournalpp
powershell.exe -executionpolicy bypass "$base_dir/packages/xournalpp/win_install.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Error 'Xournalpp failed to install.'
    exit $LASTEXITCODE
}

# Install Surfshark
powershell.exe -executionpolicy bypass "$base_dir/packages/surfshark/win_install.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Error 'Surfshark failed to install.'
    exit $LASTEXITCODE
}

# TODO: Add WSL install packages script.
