$local:datapath = "/data"
$local:templates = "${PSScriptRoot}/templates"
$local:temp = "${PSScriptRoot}/temp"

$progressPreference = 'silentlyContinue'

. "${PSScriptRoot}/common.ps1"

LoadEnvVars

DebugOut "Debugging is enabled"

while ($true) {
    Write-Host "Running at $(Get-Date)"

    & ${PSScriptRoot}/burnaware.ps1
    & ${PSScriptRoot}/pdfshaper.ps1
    & ${PSScriptRoot}/rpcs3.ps1
    & ${PSScriptRoot}/roccatswarm.ps1
    & ${PSScriptRoot}/siril.ps1

    Write-Host "-----------------------------"
    
    if (-not $DELAY -or $DELAY -eq 0) {break}
    Start-Sleep -Seconds ([int]$DELAY * 60)
}
