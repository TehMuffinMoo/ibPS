function Get-B1CSPUrl {
    <#
    .SYNOPSIS
        Retrieves the stored Infoblox Portal Url, if available.

    .DESCRIPTION
        This function will retrieve the saved Infoblox Portal CSP from the local user/machine if it has previously been set.

    .EXAMPLE
        PS> Get-B1CSPUrl

        https://csp.infoblox.com

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        API
    #>
    [CmdletBinding()]
    param(
        $ProfileName
    )
    if ($ProfileName -or (!($Script:AuthManager))) {
        $Configs = Get-B1Context
        if ($Configs.Contexts.PSObject.Properties.Name.Count -gt 0) {
            if (!$($ProfileName)) {
                $ProfileName = $Configs.CurrentContext
            }
            if ($Configs.Contexts."$($ProfileName)") {
                $CSPUrl = ($Configs.Contexts | Select-Object -ExpandProperty $ProfileName).'URL'
            } else {
                Write-Error "Unable to find Connection Profile: $($ProfileName)"
                return $null
            }
        } else {
            Write-Error "No Connection Profiles or Global CSP API Key has been configured."
            Write-Colour "See the following link for more information: ","`nhttps://ibps.readthedocs.io/en/latest/#authentication-api-key" -Colour Cyan,Magenta
            return $null
        }
    } elseif ($Script:AuthManager) {
        $CSPUrl = ($Script:AuthManager).CSPUrl
    } else {
        $CSPUrl = "https://csp.infoblox.com"
    }

    return $CSPUrl
}