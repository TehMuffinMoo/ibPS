function Remove-NIOSConnectionProfile {
    <#
    .SYNOPSIS
        This function is used to remove a saved connection profile.

    .DESCRIPTION
        Connection profiles provide a convenient way of saving connection details to local or federated NIOS Grids. A list of connection profiles can be retrieved using [Get-NIOSConnectionProfile](https://ibps.readthedocs.io/en/latest/NIOS/Profiles/Get-NIOSConnectionProfile/). 

    .PARAMETER Name
        Specify the connection profile name to remove. This field supports tab completion.

    .EXAMPLE
        PS> Remove-NIOSConnectionProfile Corp-GM

        WARNING: Are you sure you want to delete the connection profile: Corp-GM?

        Confirm
        Continue with this operation?
        [Y] Yes  [A] Yes to All  [H] Halt Command  [S] Suspend  [?] Help (default is "Y"): y

        Removed connection profile: Corp-GM

    .EXAMPLE
        PS> Remove-NCP Corp-GM -Confirm:$false

        Removed connection profile: Corp-GM

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    [Alias('Remove-NCP')]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Bool]$Confirm = $true
    )

    if (Get-NIOSConnectionProfile -Name $Name) {
        $ContextConfig = (Get-NIOSContext)
        if ($ContextConfig.CurrentContext -ne $Name) {
            if ($Confirm) {
                Write-Warning "Are you sure you want to delete the connection profile: $($Name)?" -WarningAction Inquire
            }
            $ContextConfig.Contexts.PSObject.Members.Remove($Name)
            $ContextConfig | ConvertTo-Json -Depth 5 | Out-File $Script:NIOSConfigFile -Force
            Write-Host "Removed connection profile: $($Name)" -ForegroundColor Green
            break
        } else {
            Write-Error "Cannot delete $($Name) as it the current active connection profile."
            break
        }
    } else {
        Write-Error "Unable to find a connection profile with name: $($Name)"
    }
}