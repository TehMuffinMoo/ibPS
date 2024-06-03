function New-B1SecurityPolicyIPAMNetwork {
    <#
    .SYNOPSIS
        This function is used to simplify the creation of the list of Subnets/Address Blocks/Ranges to append or remove to/from an existing or a New Security Policy, using Set-B1SecurityPolicy / New-B1SecurityPolicy.

    .DESCRIPTION
        This function is used to simplify the creation of the list of Subnets/Address Blocks/Ranges to append or remove to/from an existing or a New Security Policy, using Set-B1SecurityPolicy / New-B1SecurityPolicy.

    .PARAMETER Object
        The Address Block, Subnet or Range object

    .EXAMPLE
        $PolicyNetworks = @()
        $PolicyNetworks += Get-B1Subnet 10.10.0.0/16 -Space 'My IP Space' | New-B1SecurityPolicyIPAMNetwork
        $PolicyNetworks += Get-B1Subnet 10.15.0.0/16 -Space 'My IP Space' | New-B1SecurityPolicyIPAMNetwork
        $PolicyNetworks | ConvertTo-Json | ConvertFrom-Json | ft

        addr_net       external_scope_id                    ip_space_id                          scope_type
        --------       -----------------                    -----------                          ----------
        10.10.0.0/16   00011234-7b54-f4gf-gfgv-g4gh5h6rhrdg fdsjvf98-489j-v8rj-g54t-gefsffsdf34d SUBNET
        10.15.0.0/16   00015644-7t55-fsrg-g564-dfgbdrg48gdo fdsjvf98-489j-v8rj-g54t-gefsffsdf34d SUBNET

        
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
        [Parameter(
            ValueFromPipeline = $true,
            ParameterSetName="Object",
            Mandatory=$true
          )]
          [System.Object]$Object
    )
    
    process {
        if ($Object) {
            $SplitID = $Object.id.split('/')
            $PermittedObjects = @("ipam/subnet","ipam/address_block","ipam/range")
            if (("$($SplitID[0])/$($SplitID[1])") -notin $PermittedObjects) {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'ipam/subnet','ipam/address_block' & 'ipam/range' objects as input"
                return $null
            }
        }
        $ParentID = $(if ($Object.parent) {($Object.parent -split '/')[2]})
        $Obj = @{
            external_scope_id = $SplitID[2]
            ip_space_id = ($Object.space -split '/')[2]
            scope_type = $($SplitID[1]).ToUpper()
        }
        if ($SplitID[1] -eq 'range') {
            $Obj.start = $Object.start
            $Obj.end = $Object.end
        } else {
            $Obj.addr_net = "$($Object.address)/$($Object.cidr)"
        }

        return $Obj

    }
}