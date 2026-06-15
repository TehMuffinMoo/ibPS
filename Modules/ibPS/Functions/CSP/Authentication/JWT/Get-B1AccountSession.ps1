function Get-B1AccountSession {
    <#
    .SYNOPSIS
        Get the current session information for the active JWT Infoblox Cloud connection profile.

    .DESCRIPTION
        This function retrieves the session information for the currently active JWT Infoblox Cloud connection profile. It provides details about the session, including the account information and session status.

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