function Switch-B1ConnectionProfile {
    <#
    .SYNOPSIS
        This function is used to switch between saved BloxOne connection profiles.

    .DESCRIPTION
        Connection profiles provide a convenient way of saving API Keys for multiple BloxOne Accounts, with the ability to quickly switch between them.

    .PARAMETER Name
        Specify the connection profile name to switch to. This field supports tab completion.

    .EXAMPLE
        PS> Switch-NCP Dev
        
        Dev has been set as the active BloxOne connection profile.

    .EXAMPLE
        PS> Switch-B1ConnectionProfile Test
        
        Test has been set as the active BloxOne connection profile.

    .FUNCTIONALITY
        BloxOne

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    [Alias('Switch-BCP')]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name
    )

    if (Get-B1ConnectionProfile -Name $Name) {
        $ContextConfig = (Get-B1Context)
        if ($ContextConfig.CurrentContext -ne $Name) {
            Write-Host "$($Name) has been set as the active BloxOne connection profile." -ForegroundColor Green
            $ContextConfig.CurrentContext = $Name
            $ContextConfig | ConvertTo-Json -Depth 5 | Out-File $Script:B1ConfigFile -Force
            break
        } else {
            Write-Host "$($Name) is already the active BloxOne connection profile." -ForegroundColor Green
            break
        }
    } else {
        Write-Error "Unable to find a BloxOne connection profile with name: $($Name)"
    }
}