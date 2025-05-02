[CmdletBinding()]
param(
    [string]$SiteCode
)

try{
    Import-Module "$($env:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" -ErrorAction Stop
} catch {
    exit 1
}

Set-Location "$($SiteCode):"

class DeploymentRequirement {
    [string]$ApplicationName
    [string]$CI_ID
    [string]$CI_UniqueID
    [string]$DeploymentType
    [string]$RequirementName
}

$Report = [System.Collections.Generic.List[psobject]]::new()

Get-CMApplication -Fast | ForEach-Object -Begin {
    Write-Host 'Rolling out...'
} -Process {
    Write-Host $PSItem.LocalizedDisplayName
    $ThisRun = New-Object -TypeName DeploymentRequirement
    $ThisRun.ApplicationName = $PSItem.LocalizedDisplayName
    $ThisRun.CI_ID = $PSItem.CI_ID
    $ThisRun.CI_UniqueID = $PSItem.CI_UniqueID
    $ThisDeployment = Get-CMDeploymentType -InputObject $PSItem 
    $ThisRun.DeploymentType = $ThisDeployment.LocalizedDisplayName
    Write-Output $ThisDeployment
} | ForEach-Object { 
    $ThisRequirement = Get-CMDeploymentTypeRequirement -InputObject $PSItem 
    $ThisRun.RequirementName = $ThisRequirement.Name
    $Report.Add($ThisRun)
} -End {
    Write-Output $Report
}