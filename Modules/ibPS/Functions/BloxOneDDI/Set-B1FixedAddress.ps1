function Set-B1FixedAddress {
    <#
    .SYNOPSIS
        Updates an existing fixed addresses in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to update an existing fixed addresses in BloxOneDDI IPAM

    .PARAMETER IP
        The IP of the fixed address

    .PARAMETER Name
        The name of the fixed address

    .PARAMETER Description
        The description of the fixed address

    .PARAMETER MatchType
        The match type for the new fixed address (i.e MAC)

    .PARAMETER MatchValue
        The match value for the new fixed address (i.e ab:cd:ef:ab:cd:ef)

    .PARAMETER DHCPOptions
        A list of DHCP Options you want to apply to the existing fixed address. This will overwrite any existing DHCP options.
        
        Example usage when combined with Get-B1DHCPOptionCode

        $DHCPOptions = @()
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

    .PARAMETER Tags
        Any tags you want to apply to the fixed address

    .PARAMETER Space
        Use this parameter to filter the list of fixed addresses by Space

    .Example
        Set-B1FixedAddress -IP 10.10.100.12 -Name "New name" -Description "A new description"

    .Example
        Get-B1FixedAddress -IP 10.10.100.12 | Set-B1FixedAddress -MatchValue "ab:cd:ef:ab:cd:ef"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
      [Parameter(
        ParameterSetName="noID",
        Mandatory=$true
      )]
      [String]$IP = $null,
      [Parameter(
        ParameterSetName="noID",
        Mandatory=$true
      )]
      [String]$Space,
      [String]$Name,
      [String]$Description,
      [String]$MatchType,
      [ValidateSet("mac","client_text","client_hex","relay_text","relay_hex")]
      [String]$MatchValue,
      [System.Object]$DHCPOptions,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="ID"
      )]
      [String]$id
    )

    process {

      if ($id) {
        $B1FixedAddress = Get-B1FixedAddress -id $id
      } elseif ($IP) {
        $B1FixedAddress = Get-B1FixedAddress -IP $IP -Space $Space
      } else {
        Write-Error "No fixed address selected for modification. Please use either the -IP or -id parameters."
      }

      if ($B1FixedAddress) {
        if ($Name) { $B1FixedAddress.name = $Name }
        if ($Description) { $B1FixedAddress.comment = $Description }
        if ($MatchType) { $B1FixedAddress.match_type = $MatchType }
        if ($MatchValue) { $B1FixedAddress.match_value = $MatchValue }
        if ($DHCPOptions) { $B1FixedAddress.dhcp_options = $DHCPOptions }
        if ($Tags) { $B1FixedAddress.tags = $Tags }
        $B1FixedAddressJSON = $B1FixedAddress | select -Property * -ExcludeProperty id,inheritance_assigned_hosts,inheritance_parent,inheritance_sources,parent | ConvertTo-Json -Depth 10
        $Results = Query-CSP -Method PATCH -Uri $B1FixedAddress.id -Data $B1FixedAddressJSON
        if ($Results) {
          return $Results | Select -ExpandProperty result
        } else {
          Write-Error "No results from API"
        }
      } else {
        Write-Error "No Fixed Address found to update"
      }

    }
}