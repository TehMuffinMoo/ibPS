function Get-ibPSConfiguration {
    <#
    .SYNOPSIS
        Used to get the current configuration for ibPS

    .DESCRIPTION
        This function is used to get the current configuration for ibPS

    .PARAMETER IncludeAPIKey
        The -IncludeAPIKey indicates whether the API Key should be returned in the response

    .EXAMPLE
        PS> Get-ibPSConfiguration               

        CSP Url          : https://csp.infoblox.com
        CSP API User     : svc-csp
        CSP API Key      : ********
        ibPS Version     : 1.9.4.4
        ibPS Branch      : main
        Debug Mode       : Disabled
        Development Mode : Disabled

    .FUNCTIONALITY
        ibPS
    #>
  param (
    [Switch]$IncludeAPIKey
  )

  $CurrentConfig = [PSCustomObject]@{
    "CSP Url" = $(if ($ENV:B1CSPUrl) {$ENV:B1CSPUrl} else {'https://csp.infoblox.com'})
    "CSP API User" = $(if ($ENV:B1APIKey) {(Get-B1CSPCurrentUser).name} else {'API Key Not Set'})
    "CSP API Key" = $(if ($ENV:B1APIKey) {if ($IncludeAPIKey) {Get-B1CSPAPIKey} else { "********" }} else {'API Key Not Set'})
    "ibPS Version" = $(Get-ibPSVersion)
    "ibPS Branch" = $(if ($ENV:IBPSBranch) {$ENV:IBPSBranch} else {'Unknown'})
    "Debug Mode" = $(if ($ENV:IBPSDebug) {$ENV:IBPSDebug} else {'Disabled'})
    "Development Mode" = $(if ($ENV:IBPSDevelopment) {$ENV:IBPSDevelopment} else {'Disabled'})
    "Telemetry Status" = $(if ($ENV:IBPSTelemetry) {$ENV:IBPSTelemetry} else {'Disabled'})
  }
  $CurrentConfig
}