#!/usr/bin/env pwsh

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$base_dir = (Get-Item $MyInvocation.MyCommand.Path).Directory.FullName

if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output 'Please run as administrator'
    exit 1
}

