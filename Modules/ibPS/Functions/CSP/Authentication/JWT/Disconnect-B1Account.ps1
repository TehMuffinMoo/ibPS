function Disconnect-B1Account {
    <#
    .SYNOPSIS
        Disconnects from the Infoblox Portal and invalidates the interactive JWT session token.

    .DESCRIPTION
        Disconnects from the Infoblox Portal and invalidates the interactive JWT session token.

    .EXAMPLE
        PS> Disconnect-B1Account

        Successfully disconnected from the Infoblox Portal.

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
        $AuthManager.Disconnect()
        $Script:AuthManager = $null
    } else {
        Write-Error "You are not currently connected to the Infoblox Portal. Please use Connect-B1Account first."
        return
    }
}