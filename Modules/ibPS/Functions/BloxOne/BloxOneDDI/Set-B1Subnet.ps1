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
        The name to update the subnet to

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

    .PARAMETER id
        The id of the subnet to update. Accepts pipeline input

    .EXAMPLE
        PS> Set-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -Name "MySubnet" -Space "Global" -Description "Comment for description"

    .EXAMPLE
        ## Example usage when combined with Get-B1DHCPOptionCode
        $DHCPOptions = @()
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

        PS> Set-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -Name "MySubnet" -Space "Global" -Description "Comment for description" -DHCPOptions $DHCPOptions
    
    .EXAMPLE
        ## Example updating the HA Group and DDNSDomain properties of a subnet

        PS> Set-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -Space "Global" -DDNSDomain "myddns.domain.corp" -HAGroup "MyDHCPHAGroup"

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Parameter(
        ParameterSetName="Default",
        Mandatory=$true
      )]
      [String]$Subnet,
      [Parameter(
        ParameterSetName="Default",
        Mandatory=$true
      )]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [Parameter(
        ParameterSetName="Default",
        Mandatory=$true
      )]
      [String]$Space,
      [String]$Name,
      [String]$HAGroup,
      [System.Object]$DHCPOptions,
      [String]$Description,
      [String]$DHCPLeaseSeconds,
      [String]$DDNSDomain,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID"
      )]
      [string[]]$id
    )

    process {

      if ($id) {
        $BloxSubnet = Get-B1Subnet -id $id -IncludeInheritance
      } else {
        $BloxSubnet = Get-B1Subnet -Subnet $Subnet -CIDR $CIDR -Space $Space -IncludeInheritance
      }
 
      if ($BloxSubnet) {
          $BloxSubnetUri = $BloxSubnet.id

          $BloxSubnetPatch = @{}
          if ($Name) {$BloxSubnetPatch.name = $Name}
          if ($Description) {$BloxSubnetPatch.comment = $Description}
          if ($DHCPOptions) {$BloxSubnetPatch.dhcp_options = $DHCPOptions}
          if ($HAGroup) {$BloxSubnetPatch.dhcp_host = (Get-B1HAGroup -Name $HAGroup -Strict).id}

          if ($DHCPLeaseSeconds) {
              $BloxSubnet.inheritance_sources.dhcp_config.lease_time.action = "override"
              $BloxSubnet.dhcp_config.lease_time = $DHCPLeaseSeconds

              $BloxSubnetPatch.inheritance_sources = $BloxSubnet.inheritance_sources
              $BloxSubnetPatch.dhcp_config += $BloxSubnet.dhcp_config | Select-Object * -ExcludeProperty abandoned_reclaim_time,abandoned_reclaim_time_v6
          }

          if ($DDNSDomain) {
              $BloxSubnetPatch."ddns_domain" = $DDNSDomain
              $DDNSupdateBlock = @{
                  ddns_update_block = @{
		  	        "action" = "override"
			        "value" = @{}
		          }
              }
              $BloxSubnetPatch.inheritance_sources = $DDNSupdateBlock
          }

          if ($Tags) {
              $BloxSubnetPatch.tags = $Tags
          }
  
          if ($BloxSubnetPatch.Count -eq 0) {
              Write-Host "Nothing to update." -ForegroundColor Gray
          } else {
              $splat = $BloxSubnetPatch | ConvertTo-Json -Depth 10
              if ($Debug) {$splat}

              $Result = Query-CSP -Method PATCH -Uri "$BloxSubnetUri" -Data $splat
              $Result = $Result | Select-Object -ExpandProperty result
              if ($Result.id -eq $BloxSubnetUri) {
                  Write-Host "Updated Subnet $($Result.address)/$($result.CIDR) successfully." -ForegroundColor Green
              } else {
                  Write-Host "Failed to update Subnet $Subnet/$CIDR - $BloxSubnetUri." -ForegroundColor Red
                  break
              }
          }

      } else {
          Write-Host "The Subnet $Subnet/$CIDR - $BloxSubnetUri does not exist." -ForegroundColor Red
      }
    }
}