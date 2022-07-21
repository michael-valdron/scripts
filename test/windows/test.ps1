#!/usr/bin/env pwsh

# Check if script to test if specified
if (!$args[0]) {
    Write-Error 'Please specify script to test.'
    exit 1
}

$script = Resolve-Path -Path $args[0]
$target_dir = (Get-Item $script).Directory.FullName
$build_path = (Get-Item $MyInvocation.MyCommand.Path).Directory.FullName
$img = ([System.Environment]::UserName + "/" + (Get-Item $build_path).BaseName)
$tag = "testing"

# Copy target script to pwd
Copy-Item -Recurse $target_dir ($build_path + "/" + (Get-Item $target_dir).BaseName)

# Test build image with target script
$target_wkdir = (Get-Item $target_dir).BaseName
$target_script = (Get-Item $script).Name
docker build --no-cache --force-rm -t ($img + ":" + $tag) `
--build-arg target=$target_wkdir `
--build-arg script=$target_script `
$build_path

# Set build status code
$status = $LASTEXITCODE

# Remove testing image
docker rmi ($img + ":" + $tag)

# Remove target script from pwd
Remove-Item -Recurse ($build_path + "/" + (Get-Item $target_dir).BaseName)

# Exit with build status code
exit $status

