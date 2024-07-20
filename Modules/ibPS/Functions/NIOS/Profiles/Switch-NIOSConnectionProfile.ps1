function Switch-NIOSConnectionProfile {
    <#
    .SYNOPSIS
        This function is used to switch between saved connection profiles.

    .DESCRIPTION
        Connection profiles provide a convenient way of saving connection details to local or federated NIOS Grids, with the ability to quickly switch between them.

    .PARAMETER Name
        Specify the connection profile name to switch to. This field supports tab completion.

    .EXAMPLE
        PS> Switch-NCP Corp-GM

        Corp-GM has been set as the active connection profile.

    .EXAMPLE
        PS> Switch-NIOSConnectionProfile BloxOne-GM

        BloxOne-GM has been set as the active connection profile.

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    [Alias('Switch-NCP')]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name
    )

    if (Get-NIOSConnectionProfile -Name $Name) {
        $ContextConfig = (Get-NIOSContext)
        if ($ContextConfig.CurrentContext -ne $Name) {
            Write-Host "$($Name) has been set as the active NIOS connection profile." -ForegroundColor Green
            $ContextConfig.CurrentContext = $Name
            $ContextConfig | ConvertTo-Json -Depth 5 | Out-File $Script:NIOSConfigFile -Force
            break
        } else {
            Write-Host "$($Name) is already the active NIOS connection profile." -ForegroundColor Green
            break
        }
    } else {
        Write-Error "Unable to find a NIOS connection profile with name: $($Name)"
    }
}