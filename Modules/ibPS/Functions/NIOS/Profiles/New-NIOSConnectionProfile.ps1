function New-NIOSConnectionProfile {
    <#
    .SYNOPSIS
        This function is used to create new NIOS connection profiles. By default, the new profile will be set as active.

    .DESCRIPTION
        Connection profiles provide a convenient way of saving connection details to local or federated NIOS Grids. These can easily be switched between by using [Switch-NIOSConnectionProfile](https://ibps.readthedocs.io/en/latest/NIOS/Profiles/Switch-NIOSConnectionProfile/).

    .PARAMETER Name
        Specify the name for the new connection profile

    .PARAMETER GridUID
        Specify the NIOS Grid UID (license_uid) to use for the new connection profile. This indicates which Grid to connect to when using NIOS Federation within BloxOne.

        Using this parameter will set the connection profile type to Federated.

    .PARAMETER GridName
        Specify the NIOS Grid Name in BloxOne DDI to use for the new connection profile.

        Using this parameter will set the connection profile type to Federated.

    .PARAMETER ApiVersion
        The version of the NIOS WAPI to use for the new connection profile. (i.e 2.12)

    .PARAMETER Server
        Specify the NIOS Grid Manager IP or FQDN for the new connection profile

        Using this parameter will set the connection profile type to Local.

    .PARAMETER Creds
        Specify the NIOS Grid Manager credentials for the new connection profile

        Using this parameter will set the connection profile type to Local.

    .PARAMETER SkipCertificateCheck
        If this parameter is set, SSL Certificates Checks will be ignored.

        Using this parameter will set the connection profile type to Local.

    .PARAMETER NoSwitchProfile
        Do not make this profile active upon creation

    .EXAMPLE
        PS> New-NCP

    .EXAMPLE
        PS> New-NIOSConnectionProfile

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
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