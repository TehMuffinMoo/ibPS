﻿function Get-B1CSPUrl {
    <#
    .SYNOPSIS
        Retrieves the stored BloxOneDDI CSP Url, if available.

    .DESCRIPTION
        This function will retrieve the saved BloxOneDDI CSP Url from the local user/machine if it has previously been set.

    .EXAMPLE
        PS> Get-B1CSPUrl

        https://csp.infoblox.com

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        API
    #>
    [CmdletBinding()]
    param(
        $ProfileName
    )
    if ($ProfileName -or !($ENV:B1APIKey)) {
        $Configs = Get-B1Context
        if ($Configs.Contexts.PSObject.Properties.Name.Count -gt 0) {
            if (!$($ProfileName)) {
                $ProfileName = $Configs.CurrentContext
            }
            if ($Configs.Contexts."$($ProfileName)") {
                $CSPUrl = ($Configs.Contexts | Select-Object -ExpandProperty $ProfileName).'URL'
            } else {
                Write-Error "Unable to find BloxOne Connection Profile: $($ProfileName)"
                return $null
            }
        } else {
            Write-Error "No BloxOne Connection Profiles or Global CSP API Key has been configured."
            Write-Colour "See the following link for more information: ","`nhttps://ibps.readthedocs.io/en/latest/#authentication-api-key" -Colour Cyan,Magenta
            return $null
        }
    } elseif ($ENV:B1CSPUrl) {
        $CSPUrl = $ENV:B1CSPUrl
    } else {
        $CSPUrl = "https://csp.infoblox.com"
    }

    return $CSPUrl
}