function Get-B1AccountSession {
    <#
    .SYNOPSIS
        

    .DESCRIPTION
        

    .EXAMPLE
        PS> Get-B1AccountSession

    .FUNCTIONALITY
        Infoblox Portal

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    [CmdletBinding()]
    param()
    if ($Script:AuthManager) {
        $AuthManager = $Script:AuthManager
        $AuthManager.GetSessionInfo()
    } else {
        Write-Error "You are not currently connected to the Infoblox Portal. Please use Connect-B1Account first."
        return
    }
}