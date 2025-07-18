﻿function Switch-B1ConnectionProfile {
    <#
    .SYNOPSIS
        This function is used to switch between saved Infoblox Cloud connection profiles.

    .DESCRIPTION
        Connection profiles provide a convenient way of saving API Keys for multiple Infoblox Cloud Accounts, with the ability to quickly switch between them.

    .PARAMETER Name
        Specify the connection profile name to switch to. This field supports tab completion.

    .EXAMPLE
        PS> Switch-BCP Dev

        Dev has been set as the active connection profile.

    .EXAMPLE
        PS> Switch-B1ConnectionProfile Test

        Test has been set as the active connection profile.

    .FUNCTIONALITY
        Infoblox Cloud

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    [Alias('Switch-BCP')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name
    )

    if (Get-B1ConnectionProfile -Name $Name) {
        $ContextConfig = (Get-B1Context)
        if ($ContextConfig.CurrentContext -ne $Name) {
            Write-Host "$($Name) has been set as the active connection profile." -ForegroundColor Green
            $ContextConfig.CurrentContext = $Name
            $ContextConfig | ConvertTo-Json -Depth 5 | Out-File $Script:B1ConfigFile -Force

            if ($ENV:B1APIKey -or $ENV:B1CSPUrl) {
                $Platform = Detect-OS
                if ($Platform -eq "Windows") {
                  [System.Environment]::SetEnvironmentVariable('B1APIKey',$null,[System.EnvironmentVariableTarget]::User)
                  [System.Environment]::SetEnvironmentVariable('B1CSPUrl',$null,[System.EnvironmentVariableTarget]::User)
                  $ENV:B1APIKey = $null
                  $ENV:B1CSPUrl = $null
                }
                if ($Platform -eq "Mac" -or $Platform -eq "Unix") {
                    if (Test-Path ~/.zshenv) {
                        sed -i '' -e '/B1APIKey/d' ~/.zshenv
                        sed -i '' -e '/B1CSPUrl/d' ~/.zshenv
                    }
                    $ENV:B1APIKey = $null
                    $ENV:B1CSPUrl = $null
                }
            }
            break
        } else {
            Write-Host "$($Name) is already the active connection profile." -ForegroundColor Green
            break
        }
    } else {
        Write-Error "Unable to find a connection profile with name: $($Name)"
    }
}