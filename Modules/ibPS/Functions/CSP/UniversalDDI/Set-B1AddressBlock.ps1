﻿function Set-B1AddressBlock {
    <#
    .SYNOPSIS
        Updates an existing address block in Universal DDI IPAM

    .DESCRIPTION
        This function is used to update an existing address block in Universal DDI IPAM

    .PARAMETER Subnet
        The network address of the address block you want to update

    .PARAMETER CIDR
        The CIDR suffix of the address block you want to update

    .PARAMETER Space
        The IPAM space where the address block is located

    .PARAMETER Name
        The name of the Address Block. If more than one Address Block object within the selected space has the same name, this will error and you will need to use Pipe as shown in the first example.

    .PARAMETER NewName
        Use -NewName to update the name of the address block

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

    .PARAMETER Compartment
        The name of the compartment to assign to this address block

    .PARAMETER Object
        The Address Block Object to update. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        ## Example usage when combined with Get-B1DHCPOptionCode
        $DHCPOptions = @()
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "domain-name-servers").id;"option_value"="10.10.10.10,10.10.10.11";}

        PS> Get-B1AddressBlock -Subnet "10.10.100.0" -Space "Global" | Set-B1AddressBlock -Description "Comment for description" -DHCPOptions $DHCPOptions

    .EXAMPLE
        PS> Set-B1AddressBlock -Subnet "10.10.100.0" -NewName "Updated name" -Space "Global" -Description "Comment for description" -DHCPOptions $DHCPOptions

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        IPAM
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
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
      [System.Object]$DHCPOptions,
      [String]$Description,
      [Int]$DHCPLeaseSeconds,
      [String]$DDNSDomain,
      [String]$Compartment,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Object",
        Mandatory=$true
      )]
      [System.Object]$Object,
      [Switch]$Force
    )

    begin {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        if ($Compartment) {
            $CompartmentID = (Get-B1Compartment -Name $Compartment -Strict).id
            if (!($CompartmentID)) {
                Write-Error "Unable to find compartment with name: $($Compartment)"
                return $null
            }
        }
    }

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
            } elseif ($Object.inheritance_sources -eq $null) {
                $ObjectExclusions += "inheritance_sources"
            }
        } else {
            $Object = Get-B1AddressBlock -Subnet $Subnet -CIDR $CIDR -Space $Space -IncludeInheritance -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find Address Block: $($Subnet)/$($CIDR) in Space: $($Space)"
                return $null
            }
            if ($Object.count -gt 1) {
                Write-Error "Multiple Address Blocks were found, to update more than one Address Block you should pass those objects using pipe instead."
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
        if ($Tags) {
            $NewObj.tags = $Tags
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
        if ($CompartmentID) {
            $NewObj.compartment_id = $CompartmentID
        }
        $JSON = $NewObj | ConvertTo-Json -Depth 10 -Compress
        if($PSCmdlet.ShouldProcess("Update Address Block:`n$(JSONPretty($JSON))","Update Address Block: $($Object.address)/$($Object.cidr) ($($Object.id))",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}
