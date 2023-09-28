function Get-B1CSPUrl {
    <#
    .SYNOPSIS
        Retrieves the stored BloxOneDDI CSP Url, if available.

    .DESCRIPTION
        This function will retrieve the saved BloxOneDDI CSP Url from the local user/machine if it has previously been set.

    .Example
        Get-B1CSPUrl

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        API
    #>
    $CSPUrl = $ENV:B1CSPUrl
    if (!$CSPUrl) {
        return "https://csp.infoblox.com"
    } else {
        return $CSPUrl
    }
}