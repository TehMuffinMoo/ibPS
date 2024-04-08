function Set-B1Range {
    <#
    .SYNOPSIS
        Updates an existing DHCP Range in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to update an existing DHCP Range in BloxOneDDI IPAM

    .PARAMETER StartAddress
        The start address of the DHCP Range you want to update

    .PARAMETER EndAddress
        The end address of the DHCP Range you want to update

    .PARAMETER Space
        The IPAM space where the DHCP Range is to be placed

    .PARAMETER Name
        The name to update the DHCP Range to

    .PARAMETER Description
        The description to update the DHCP Range to

    .PARAMETER HAGroup
        The name of the HA group to apply to this DHCP Range. This will overwrite the existing HA Group.

    .PARAMETER Tags
        Any tags you want to apply to the DHCP Range. This will overwrite existing tags.

    .PARAMETER id
        The id of the range. Accepts pipeline input

    .EXAMPLE
        PS> Set-B1Range -StartAddress 10.250.20.20 -EndAddress 10.250.20.100 -Description -Tags @{"siteCode"="12345"}
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DHCP
    #>
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$StartAddress,
      [Parameter(ParameterSetName="Default",Mandatory=$false)]
      [String]$EndAddress,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [string]$Space,
      [String]$Name,
      [String]$Description,
      [String]$HAGroup,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
      if ($id) {
        $DHCPRange = Get-B1Range -id $id
      } else {
        $DHCPRange = Get-B1Range -StartAddress $StartAddress -EndAddress $EndAddress -Space $Space
      }
      if ($DHCPRange) {
        if ($Description) {
            $DHCPRange.comment = $Description
        }
        if ($Tags) {
            if ($DHCPRange.PSObject.Properties.name -match "tags") {
                $DHCPRange.tags = $Tags
            } else {
                $DHCPRange | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
            }
        }
        if ($Name) {
            $DHCPRange.name = $Name
        }
        if ($HAGroup) {
          $DHCPRange.dhcp_host = (Get-B1HAGroup -Name $HAGroup -Strict).id
        }
        $splat = $DHCPRange | Select-Object * -ExcludeProperty utilization,utilization_v6,id,inheritance_assigned_hosts,inheritance_parent,parent,protocol,space,inheritance_sources | ConvertTo-Json -Depth 10
        $Result = Query-CSP -Method PATCH -Uri $($DHCPRange.id) -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        if ($($Result.id) -eq $($DHCPRange.id)) {
            Write-Host "Updated DHCP Range: $($DHCPRange.name) - $($DHCPRange.start) - $($DHCPRange.end) Successfully." -ForegroundColor Green
            return $Result
        } else {
            Write-Host "Failed to update DHCP Range: $($DHCPRange.name) - $($DHCPRange.start) - $($DHCPRange.end)" -ForegroundColor Red
        }
      } else {
        Write-Host "Error. DHCP Range does not exist: $StartAddress$id - $EndAddress" -ForegroundColor Red
      }
    }
}