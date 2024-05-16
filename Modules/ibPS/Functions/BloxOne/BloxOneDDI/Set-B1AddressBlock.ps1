function Set-B1AddressBlock {
    <#
    .SYNOPSIS
        Updates an existing address block in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to update an existing address block in BloxOneDDI IPAM

    .PARAMETER Subnet
        The network address of the address block you want to update

    .PARAMETER CIDR
        The CIDR suffix of the address block you want to update

    .PARAMETER Space
        The IPAM space where the address block is located

    .PARAMETER Name
        The new name for the address block

    .PARAMETER Description
        The new description for the address block

    .PARAMETER DHCPOptions
        A list of DHCP Options you want to update the address block with. This will overwrite existing options.

    .PARAMETER DDNSDomain
        The new DDNS Domain for the address block

    .PARAMETER DHCPLeaseSeconds
        The default DHCP Lease duration in seconds

    .PARAMETER Tags
        A list of tags to update on the address block. This will replace existing tags, so would normally be a combined list of existing and new tags

    .PARAMETER Object
        The Address Block Object to update. Accepts pipeline input

    .EXAMPLE
        ## Example usage when combined with Get-B1DHCPOptionCode
        $DHCPOptions = @()
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "domain-name-servers").id;"option_value"="10.10.10.10,10.10.10.11";}

        PS> Set-B1AddressBlock -Subnet "10.10.100.0" -Name "Updated name" -Space "Global" -Description "Comment for description" -DHCPOptions $DHCPOptions
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Subnet,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Space,
      [String]$Name,
      [System.Object]$DHCPOptions,
      [String]$Description,
      [Int]$DHCPLeaseSeconds,
      [String]$DDNSDomain,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Object",
        Mandatory=$true
      )]
      [System.Object]$Object
    )

    process {
        $ObjectExclusions = @('id','utilization','utilization_v6','updated_at','created_at','federation','federated_realms','address','discovery_attrs','inheritance_parent','parent','protocol','space','usage','dhcp_utilization')
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "ipam/address_block") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'ipam/address_block' objects as input"
                return $null
            }
            if (($DHCPLeaseSeconds -or $DDNSDomain) -and ($Object.inheritance_sources -eq $null)) {
                $Object = Get-B1AddressBlock -id $Object.id -IncludeInheritance
            } else {
                $ObjectExclusions += "inheritance_sources"
            }
        } else {
            $Object = Get-B1AddressBlock -Subnet $Subnet -CIDR $CIDR -Space $Space -IncludeInheritance
            if (!($Object)) {
                Write-Error "Unable to find Address Block: $($Subnet)/$($CIDR) in Space: $($Space)"
                return $null
            }
        }
        $NewObj = $Object | Select-Object * -ExcludeProperty $ObjectExclusions
        $NewObj.dhcp_config = $NewObj.dhcp_config | Select-Object * -ExcludeProperty abandoned_reclaim_time,abandoned_reclaim_time_v6,echo_client_id

        if ($Name) {
            $NewObj.name = $Name
        }
        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($DHCPOptions) {
            $NewObj.dhcp_options = $DHCPOptions
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
