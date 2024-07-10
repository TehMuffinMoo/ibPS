function Get-NIOSConnectionProfile {
    <#
    .SYNOPSIS
        This function is used to retrieved saved NIOS connection profiles. By default, the active profile is returned.

    .DESCRIPTION
        Connection profiles provide a convenient way of saving connection details to local or federated NIOS Grids. These can easily be switched between by using [Switch-NIOSConnectionProfile](https://ibps.readthedocs.io/en/latest/NIOS/Profiles/Switch-NIOSConnectionProfile/). 

    .PARAMETER Name
        Return a specific connection profile based on its name

    .PARAMETER List
        Return a list of all saved connection profiles.

    .EXAMPLE
        PS> Get-NCP | ft

        Active   Name          Type        APIVersion   GridName                              GridUID                           Server  Username  SkipCertificateCheck
        ------   ----          ----        ----------   --------                              -------                           ------  --------  --------------------
        True     BloxOne-GM1   Federated   2.12         Infoblox_infoblox.localdomain_A9E9CF  adsudas09dus0fu4rsf8yfsyysfd8fu9  -       -         -

    .EXAMPLE
        PS> Get-NIOSConnectionProfile -List | ft

        Active  Name          Type      APIVersion GridName                             GridUID                          Server                   Username  SkipCertificateCheck
        ------  ----          ----      ---------- --------                             -------                          ------                   --------  --------------------
        True    BloxOne-GM1   Federated 2.12.3     Infoblox_infoblox.localdomain_A9E9CF adsudas09dus0fu4rsf8yfsyysfd8fu9 -                        -         -
        False   Corp-GM1      Local     2.12       -                                    -                                10.10.175.225            admin     True
        False   DMZ-GM1       Local     2.12       -                                    -                                172.26.21.22             infoblox  False

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    [Alias('Get-NCP')]
    param(
        [String]$Name,
        [Switch]$List
    )
    $Configs = Get-NIOSContext
    $ReturnProperties = @{
        Property =  @{n="Active";e={if ($_.Name -eq $Configs.CurrentContext) { $True } else { $False } }},
                    @{n="Name";e={$_.Name}},
                    @{n="Type";e={$_.Type}},
                    @{n="APIVersion";e={$_.APIVersion}},
                    @{n="GridName";e={$_.GridName}},
                    @{n="GridUID";e={$_.GridUID}},
                    @{n="Server";e={$_.Server}},
                    @{n="Username";e={$_.Credentials.Username}},
                    @{n="SkipCertificateCheck";e={$_.SkipCertificateCheck}}
    }
    if ($Name) {
        if ($Configs.Contexts."$($Name)") {
            return $Configs.Contexts | Select-Object -ExpandProperty $Name
        }
    } elseif ($List) {
        $ReturnList = @()
        $Configs.Contexts.PSObject.Properties.Name | %{
            $ReturnList += $Configs.Contexts."$($_)" | Select-Object @ReturnProperties
        }
        return $ReturnList
    } else {
        if ($Configs.CurrentContext) {
            return $Configs.Contexts."$($Configs.CurrentContext)" | Select-Object @ReturnProperties
        }
    }
}