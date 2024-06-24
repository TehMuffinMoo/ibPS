function Get-NIOSConnectionProfile {
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