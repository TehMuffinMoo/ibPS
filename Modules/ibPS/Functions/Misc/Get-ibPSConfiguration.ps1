function Get-ibPSConfiguration {
    <#
    .SYNOPSIS
        Used to get the current configuration for ibPS

    .DESCRIPTION
        This function is used to get the current configuration for ibPS

    .PARAMETER IncludeAPIKey
        The -IncludeAPIKey indicates whether the API Key should be returned in the response

    .PARAMETER Details
        The -Details parameter optionally includes the Build Version, Github Commit SHA & Module Location in the response

    .EXAMPLE
        PS> Get-ibPSConfiguration

        CSP Url          : https://csp.infoblox.com
        CSP API User     : svc-csp
        CSP Account      : ACME Corp
        CSP API Key      : ********
        ibPS Version     : 1.9.4.4
        ibPS Branch      : main
        Debug Mode       : Disabled
        Development Mode : Disabled

    .FUNCTIONALITY
        ibPS
    #>
    [CmdletBinding()]
    param (
        [Switch]$IncludeAPIKey,
        [Switch]$Details
    )

    $ibPSModule = Get-Module -ListAvailable -Name ibPS

    $CurrentConfig = [PSCustomObject]@{
        "CSP Url" = $(if ($Script:AuthManager) {($Script:AuthManager).CSPUrl} elseif ($BCP = Get-B1ConnectionProfile) {$BCP.'CSP Url'} else {'API Key Not Set'})
        "CSP API User" = $(if ($Script:AuthManager) {(Get-B1CSPCurrentUser).name} elseif ($BCP = Get-B1ConnectionProfile) {$BCP.'CSP User'} else {'API Key Not Set'})
        "CSP Account" = $(if ($Script:AuthManager) {(Get-B1CSPCurrentUser -Account).name} elseif ($BCP = Get-B1ConnectionProfile) {$BCP.'CSP Account'} else {'API Key Not Set'})
        "CSP API Key" = $(if ($Script:AuthManager) { 'Connect-B1Account is overriding the Active Profile' } elseif ($BCP = Get-B1ConnectionProfile -IncludeAPIKey:$IncludeAPIKey) {$BCP.'API Key'} else {'API Key Not Set'})
        "CSP Profile" = $(if ($Script:AuthManager) { 'Connect-B1Account is overriding the Active Profile' } elseif ($BCP = Get-B1ConnectionProfile) { $BCP.Name } else { 'None' })
        "NIOS Profile" = $(if ($NCP = Get-NIOSConnectionProfile) { $NCP.Name} else { 'None' })
        "DoH Server" = $(if ($ENV:IBPSDoH) {$ENV:IBPSDoH} else { 'Not Set' })
        "ibPS Version" = $ibPSModule.Version.ToString()
        "Debug Mode" = $(if ($ENV:IBPSDebug) {$ENV:IBPSDebug} else {'Disabled'})
        "Development Mode" = $(if ($ENV:IBPSDevelopment) {$ENV:IBPSDevelopment} else {'Disabled'})
        "Telemetry Status" = $(if ($ENV:IBPSTelemetry) {$ENV:IBPSTelemetry} else {'Disabled'})
    }

    if ($Details) {
        $PSGalleryModule = Get-InstalledModule -Name ibPS -EA SilentlyContinue -WA SilentlyContinue
        $ModulePath = "$($ibPSModule.ModuleBase)"
        if (Test-Path "$($ModulePath)/Functions/Misc/build.json") {
            $Build = Get-Content "$($ModulePath)/Functions/Misc/build.json" | ConvertFrom-Json
            $CurrentConfig | Add-Member -MemberType NoteProperty -Name "Branch" -Value $Build.Branch
            $CurrentConfig | Add-Member -MemberType NoteProperty -Name "Build" -Value $Build.Build
            $CurrentConfig | Add-Member -MemberType NoteProperty -Name "SHA" -Value $Build.SHA
        }
        $CurrentConfig | Add-Member -MemberType NoteProperty -Name "Install Path" -Value $ModulePath
        $CurrentConfig | Add-Member -MemberType NoteProperty -Name "Install Type" -Value $(if ($PSGalleryModule) { "Powershell Gallery" } else { "Local"})
    }
    return $CurrentConfig
}