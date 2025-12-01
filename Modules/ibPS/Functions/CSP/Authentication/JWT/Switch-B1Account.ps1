function Switch-B1Account {
    <#
    .SYNOPSIS
        Switches an interactive JWT session token to a different Infoblox Portal account.

    .DESCRIPTION
        Switches an interactive JWT session token to a different Infoblox Portal account. This can be used to switch into the context of Sandboxes/Subtenants using the parent account's JWT session token.

        This only works when connected to the Infoblox Portal using Connect-B1Account and an Email / Password. API Keys do not support account switching.

    .PARAMETER Name
        The name of the Infoblox Portal account to switch to. This is the name as displayed in the Infoblox Portal.

    .PARAMETER id
        The ID of the Infoblox Portal account to switch to. This is the unique identifier for the account, which can be obtained by using Get-B1CSPCurrentUser -Accounts.

    .EXAMPLE
        PS> Switch-B1Account -Name "Sandbox Account"

        Successfully switched to Sandbox Account using: my.name@email.com.

    .FUNCTIONALITY
        Infoblox Portal

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    param(
        [Parameter(Mandatory=$true, ParameterSetName="name")]
        [string]$Name,
        [Parameter(Mandatory=$true, ParameterSetName="id")]
        [string]$id
    )

    if (!$Script:AuthManager) {
        Write-Error "You must be connected to the Infoblox Portal before switching accounts. Please use Connect-B1Account first."
        return
    }

    if ($Name) {
        $Account = Get-B1CSPCurrentUser -Accounts | Where-Object { $_.name -eq $Name }
        if (!$Account) {
            Write-Error "No account found with the name: $Name"
            return
        }
        $id = $Account.id
    }

    try {
        if (!($Script:AuthManager).SwitchSession($id)) {
            Write-Error "Failed to switch accounts. Please check the account ID and try again."
            return
        }
    } catch {
        Write-Error $_
        return
    }
}