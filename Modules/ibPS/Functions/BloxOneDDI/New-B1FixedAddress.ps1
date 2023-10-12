function New-B1FixedAddress {
    <#
    .SYNOPSIS
        Creates a new fixed addresses in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to create a new fixed addresses in BloxOneDDI IPAM

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
        A list of DHCP Options you want to apply to the new fixed address.
        
        Example usage when combined with Get-B1DHCPOptionCode

        $DHCPOptions = @()
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

    .PARAMETER Tags
        Any tags you want to apply to the fixed address

    .PARAMETER Space
        Use this parameter to filter the list of fixed addresses by Space

    .Example
        New-B1FixedAddress -IP 10.10.100.12 -Name "New name" -Description "A new description"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$IP,
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [Parameter(Mandatory=$true)]
      [ValidateSet("mac","client_text","client_hex","relay_text","relay_hex")]
      [String]$MatchType,
      [Parameter(Mandatory=$true)]
      [String]$MatchValue,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [System.Object]$DHCPOptions = $null,
      [System.Object]$Tags = $null
    )

    if ($Space) {$SpaceUUID = (Get-B1Space -Name $Space -Strict).id}

    $splat = @{
      name = $Name
      comment = $Description
      ip_space = $SpaceUUID
      address = $IP
      match_type = $MatchType
      match_value = $MatchValue
      dhcp_options = $DHCPOptions
      tags = $Tags
    }
    $splat = $splat | ConvertTo-Json -Depth 10

    if ($Debug) {$splat}
    $Result = Query-CSP -Method POST -Uri "dhcp/fixed_address" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
    if ($Result.address -eq $IP) {
      Write-Host "Created Fixed Address Successfully." -ForegroundColor Green
      return $Result
    } else {
      Write-Host "Failed to create Fixed Address." -ForegroundColor Red
    }
}