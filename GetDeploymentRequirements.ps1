<#
.SYNOPSIS
Retrieves deployment requirements for applications in a Microsoft Configuration Manager (MECM) environment.

.DESCRIPTION
This script connects to a specified Configuration Manager site and retrieves details about applications, their deployment types, and associated requirements. It generates a structured report containing the application name, CI_ID, CI_UniqueID, deployment type, and requirement name.

.PARAMETER SiteCode
Specifies the site code of the Configuration Manager site to connect to. This parameter is required to set the context for querying the Configuration Manager environment.

.EXAMPLE
.\GetDeploymentRequirements.ps1 -SiteCode "ABC"

This command retrieves deployment requirements for all applications in the Configuration Manager site with the site code "ABC" and outputs the results as a structured report.

.LINK

#>
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