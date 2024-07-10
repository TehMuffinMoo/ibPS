function Get-B1CSPUrl {
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
    param(
        $Profile
    )
    if ($Profile) {
        $Configs = Get-B1Context
        if ($Configs.Contexts."$($Profile)") {
            $CSPUrl = ($Configs.Contexts | Select-Object -ExpandProperty $Profile).'URL'
        } else {
            Write-Error "Unable to find BloxOne Connection Profile: $($Profile)"
            return $null
        }
    } else {
        $CSPUrl = $ENV:B1CSPUrl
    }

    if (!$CSPUrl) {
        return "https://csp.infoblox.com"
    } else {
        return $CSPUrl
    }
}