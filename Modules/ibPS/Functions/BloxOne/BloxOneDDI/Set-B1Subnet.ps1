function Set-B1Subnet {
    <#
    .SYNOPSIS
        Updates an existing subnet in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to update an existing subnet in BloxOneDDI IPAM

    .PARAMETER Subnet
        The network address of the subnet you want to update

    .PARAMETER CIDR
        The CIDR suffix of the subnet you want to update

    .PARAMETER Space
        The IPAM space where the subnet is located

    .PARAMETER Name
        The name of the subnet. If more than one subnet object within the selected space has the same name, this will error and you will need to use Pipe as shown in the first example.

    .PARAMETER NewName
        Use -NewName to update the name of the subnet

    .PARAMETER Description
        The description to update the subnet to.

    .PARAMETER HAGroup
        The name of the HA group to apply to this subnet

    .PARAMETER DHCPOptions
        A list of DHCP Options you want to apply to the existing subnet. This will overwrite existing DHCP options for this subnet.

    .PARAMETER DDNSDomain
        The DDNS Domain to update the subnet to

    .PARAMETER DHCPLeaseSeconds
        The default DHCP Lease duration in seconds

    .PARAMETER Tags
        Any tags you want to apply to the subnet

    .PARAMETER Object
        The Subnet Object to update. Accepts pipeline input

    .EXAMPLE
        PS> Set-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -NewName "MySubnet" -Space "Global" -Description "Comment for description"

    .EXAMPLE
        ## Example usage when combined with Get-B1DHCPOptionCode
        $DHCPOptions = @()
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

        PS> Get-B1Subnet -Subnet "10.10.10.0" -CIDR 24 | Set-B1Subnet -NewName "MySubnet" -Space "Global" -Description "Comment for description" -DHCPOptions $DHCPOptions
    
    .EXAMPLE
        ## Example updating the HA Group and DDNSDomain properties of a subnet

        PS> Set-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -Space "Global" -DDNSDomain "myddns.domain.corp" -HAGroup "MyDHCPHAGroup"

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Parameter(ParameterSetName="Subnet",Mandatory=$true)]
      [String]$Subnet,
      [Parameter(ParameterSetName="Subnet",Mandatory=$true)]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [Parameter(ParameterSetName="Subnet",Mandatory=$true)]
      [Parameter(ParameterSetName="Name",Mandatory=$true)]
      [String]$Space,
      [Parameter(ParameterSetName="Name",Mandatory=$true)]
      [String]$Name,
      [String]$NewName,
      [String]$HAGroup,
      [System.Object]$DHCPOptions,
      [String]$Description,
      [String]$DHCPLeaseSeconds,
      [String]$DDNSDomain,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Object",
        Mandatory=$true
      )]
      [System.Object]$Object
    )

    begin {
        if ($HAGroup) {
            $HAGroupID = (Get-B1HAGroup -Name $HAGroup -Strict).id
            if (!($HAGroupID)) {
                Write-Error "Unable to find HA Group: $($HAGroup)"
                return $null
            }
        }
    }

    process {
        $ObjectExclusions = @('id','utilization','utilization_v6','updated_at','created_at','federation','federated_realms','address','discovery_attrs','inheritance_parent','parent','protocol','space','usage','dhcp_utilization','asm_scope_flag','inheritance_assigned_hosts')
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "ipam/subnet") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'ipam/subnet' objects as input"
                return $null
            }
            if (($DHCPLeaseSeconds -or $DDNSDomain) -and ($Object.inheritance_sources -eq $null)) {
                $Object = Get-B1Subnet -id $Object.id -IncludeInheritance
            } else {
                $ObjectExclusions += "inheritance_sources"
            }
        } else {
            $Object = Get-B1Subnet -Subnet $Subnet -CIDR $CIDR -Space $Space -IncludeInheritance -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find Subnet: $($Subnet)/$($CIDR) in Space: $($Space)"
                return $null
            }
            if ($Object.count -gt 1) {
                Write-Error "Multiple Subnet were found, to update more than one Subnet you should pass those objects using pipe instead."
                return $null
            }
        }

        $NewObj = $Object | Select-Object * -ExcludeProperty $ObjectExclusions
        $NewObj.dhcp_config = $NewObj.dhcp_config | Select-Object * -ExcludeProperty abandoned_reclaim_time,abandoned_reclaim_time_v6,echo_client_id

        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($DHCPOptions) {
            $NewObj.dhcp_options = $DHCPOptions
        }
        if ($HAGroupID) {
            $NewObj.dhcp_host = $HAGroupID
        }
        if ($Tags) {
            $AddressBlockPatch.tags = $Tags
        }
        if ($DHCPLeaseSeconds) {
            $NewObj.inheritance_sources.dhcp_config.lease_time.action = "override"
            $NewObj.inheritance_sources.dhcp_config.lease_time.value = $DHCPLeaseSeconds
            $NewObj.dhcp_config.lease_time = $DHCPLeaseSeconds
        }
        if ($DDNSDomain) {
            $NewObj.inheritance_sources.ddns_update_block.action = "override"
            $NewObj.inheritance_sources.ddns_update_block.value = @{}
            $NewObj.ddns_domain = $DDNSDomain
        }
        $JSON = $NewObj | ConvertTo-Json -Depth 10 -Compress
        $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
        if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
            $Results | Select-Object -ExpandProperty result
        } else {
            $Results
        }
    }
}
