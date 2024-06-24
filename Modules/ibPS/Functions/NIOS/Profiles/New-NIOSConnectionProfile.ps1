function New-NIOSConnectionProfile {
    [Alias('New-NCP')]
    param (
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true,ParameterSetName='Local')]
        [String]$Server,
        [Parameter(Mandatory=$true,ParameterSetName='Local')]
        [PSCredential]$Creds,
        [Parameter(ParameterSetName='Local')]
        [Switch]$SkipCertificateCheck,
        [Parameter(Mandatory=$true)]
        [String]$APIVersion,
        [Parameter(Mandatory=$true,ParameterSetName='FederatedUID')]
        [String]$GridUID,
        [Parameter(Mandatory=$true,ParameterSetName='FederatedName')]
        [String]$GridName,
        [Switch]$NoSwitchProfile
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'FederatedUID' {
            $GridMember = Get-B1Host -tfilter "`"host/license_uid`"==`"$($GridUID)`""
            if ($GridMember) {
                $FederatedGridUID = $GridUID
                $GridName = $GridMember.display_name
            } else {
                Write-Error "Failed to find Grid associated with UID: $($GridUID)"
                break            
            }
        }
        'FederatedName' {
            $GridMember = (Get-B1Host -Name $GridName -Strict).tags.'host/license_uid'
            if ($GridMember) {
                $FederatedGridUID = $GridMember
            } else {
                Write-Error "Failed to find Grid associated with Name: $($GridName)"
                break            
            }
        }
        'Local' {
            $LocalGridConfig = $true
        }
    }

    if ($FederatedGridUID) {
        $Config = @{
            "Name" = $Name
            "Type" = "Federated"
            "GridName" = $($GridName)
            "GridUID" = $($FederatedGridUID)
            "Server" = "-"
            "APIVersion" = $APIVersion
            "Credentials" = @{
                "Username" = "-"
                "Password" = "-"
            }
            "SkipCertificateCheck" = "-"
        }
    }

    if ($LocalGridConfig) {
        $Config = @{
            "Name" = $Name
            "Type" = "Local"
            "GridName" = "-"
            "GridUID" = "-"
            "Server" = $Server
            "APIVersion" = $APIVersion
            "Credentials" = @{
                "Username" = $Creds.GetNetworkCredential().UserName
                "Password" = $([Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($($Creds.Password | ConvertFrom-SecureString))))
            }
            "SkipCertificateCheck" = $(if ($SkipCertificateCheck) { $True } else { $False })
        }
    }
    Set-NIOSContext -Name $Name -Config $Config -NoSwitchProfile:$($NoSwitchProfile)
}