function Remove-B1ConnectionProfile {
    <#
    .SYNOPSIS
        This function is used to remove a saved BloxOne connection profile.

    .DESCRIPTION
        Connection profiles provide a convenient way of saving API Keys for multiple BloxOne Accounts, with the ability to quickly switch between them. A list of connection profiles can be retrieved using [Get-B1ConnectionProfile](https://ibps.readthedocs.io/en/latest/BloxOne/Profiles/Get-B1ConnectionProfile/).

    .PARAMETER Name
        Specify the connection profile name to remove. This field supports tab completion.

    .EXAMPLE
        PS> Remove-B1ConnectionProfile Dev

        WARNING: Are you sure you want to delete the connection profile: Dev?

        Confirm
        Continue with this operation?
        [Y] Yes  [A] Yes to All  [H] Halt Command  [S] Suspend  [?] Help (default is "Y"): y

        Removed connection profile: Dev

    .EXAMPLE
        PS> Remove-BCP Test -Confirm:$false

        Removed connection profile: Test

    .FUNCTIONALITY
        BloxOne

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    [Alias('Remove-BCP')]
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name
    )

    if (Get-B1ConnectionProfile -Name $Name) {
        $ContextConfig = (Get-B1Context)
        if ($ContextConfig.CurrentContext -ne $Name) {
            if($PSCmdlet.ShouldProcess("Remove BloxOne Connection Profile: $($Name)","Remove BloxOne Connection Profile: $($Name)",$MyInvocation.MyCommand)){
                $ContextConfig.Contexts.PSObject.Members.Remove($Name)
                $ContextConfig | ConvertTo-Json -Depth 5 | Out-File $Script:B1ConfigFile -Force -Confirm:$false
                Write-Host "Removed BloxOne connection profile: $($Name)" -ForegroundColor Green
                break
            }
        } else {
            Write-Error "Cannot delete $($Name) as it the current active BloxOne connection profile."
            break
        }
    } else {
        Write-Error "Unable to find a BloxOne connection profile with name: $($Name)"
    }
}