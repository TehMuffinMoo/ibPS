function Remove-B1ConnectionProfile {
    <#
    .SYNOPSIS
        This function is used to remove a saved Infoblox Cloud connection profile.

    .DESCRIPTION
        Connection profiles provide a convenient way of saving API Keys for multiple Infoblox Cloud Accounts, with the ability to quickly switch between them.

    .PARAMETER Name
        Specify the connection profile name to remove. This field supports tab completion.

    .PARAMETER All
        Use this switch to remove all saved connection profiles, including the active connection profile.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1ConnectionProfile Dev

        WARNING: Are you sure you want to delete the connection profile: Dev?

        Confirm
        Continue with this operation?
        [Y] Yes  [A] Yes to All  [H] Halt Command  [S] Suspend  [?] Help (default is "Y"): y

        Removed connection profile: Dev

    .EXAMPLE
        PS> Remove-BCP -All

        Remove All Connection Profiles
        [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y
        Removed all connection profiles.

    .EXAMPLE
        PS> Remove-BCP Test -Confirm:$false

        Removed connection profile: Test

    .FUNCTIONALITY
        Infoblox Cloud

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
        [Parameter(Mandatory=$true, ParameterSetName="Name")]
        [String]$Name,
        [Parameter(Mandatory=$true, ParameterSetName="All")]
        [Switch]$All,
        [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    if ($All) {
        if($PSCmdlet.ShouldProcess("Remove All Connection Profiles","Remove All Connection Profiles",$MyInvocation.MyCommand)){
            $ContextConfig = (Get-B1Context)
            $ContextConfig.Contexts = [PSCustomObject]@{}
            $ContextConfig.CurrentContext = $null
            $ContextConfig | ConvertTo-Json -Depth 5 | Out-File $Script:B1ConfigFile -Force -Confirm:$false
            Write-Host "Removed all connection profiles." -ForegroundColor Green
        }
    } else {
        if (Get-B1ConnectionProfile -Name $Name) {
            $ContextConfig = (Get-B1Context)
            if ($ContextConfig.CurrentContext -ne $Name) {
                if($PSCmdlet.ShouldProcess("Remove Connection Profile: $($Name)","Remove Connection Profile: $($Name)",$MyInvocation.MyCommand)){
                    $ContextConfig.Contexts.PSObject.Members.Remove($Name)
                    $ContextConfig | ConvertTo-Json -Depth 5 | Out-File $Script:B1ConfigFile -Force -Confirm:$false
                    Write-Host "Removed connection profile: $($Name)" -ForegroundColor Green
                    break
                }
            } else {
                if ($Force) {
                    if($PSCmdlet.ShouldProcess("Remove Connection Profile: $($Name)","Remove Connection Profile: $($Name)",$MyInvocation.MyCommand)){
                        $ContextConfig.Contexts.PSObject.Members.Remove($Name)
                        $NextContext = ($ContextConfig.Contexts.PSObject.Members | Where-Object {$_.MemberType -eq 'NoteProperty'} | Select-Object -First 1).Name
                        if ($NextContext) {
                            $ContextConfig.CurrentContext = $NextContext
                            $ContextConfig | ConvertTo-Json -Depth 5 | Out-File $Script:B1ConfigFile -Force -Confirm:$false
                            Write-Host "Removed connection profile: $($Name) and set active connection profile to: $($ContextConfig.CurrentContext)" -ForegroundColor Green
                        } else {
                            $ContextConfig.CurrentContext = $null
                            $ContextConfig | ConvertTo-Json -Depth 5 | Out-File $Script:B1ConfigFile -Force -Confirm:$false
                            Write-Host "Removed last connection profile: $($Name)." -ForegroundColor Green
                        }

                        break
                    }
                } else {
                    Write-Error "Cannot delete $($Name) as it the current active connection profile. Please use -Force to remove the active connection profile, or switch to a different connection profile before removing $($Name)."
                    break
                }
            }
        } else {
            Write-Error "Unable to find a connection profile with name: $($Name)"
        }
    }
}