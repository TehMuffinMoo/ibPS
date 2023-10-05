function Get-B1AddressBlock {
    <#
    .SYNOPSIS
        Queries a list of Address Blocks from the BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to query a list of Address Blocks from the BloxOneDDI IPAM

    .PARAMETER Subnet
        Use this parameter to filter the list of Address Blocks by network address

    .PARAMETER CIDR
        Use this parameter to filter the list of Address Blocks by CIDR suffix

    .PARAMETER Name
        Use this parameter to filter the list of Address Blocks by Name

    .PARAMETER Space
        Use this parameter to filter the list of Address Blocks by Space

    .PARAMETER IncludeInheritance
        Whether to include data inherited from parent objects in results

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned from the Audit Log. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER id
        Filter by the id of the address block

    .Example
        Get-B1AddressBlock -Subnet "10.10.100.0/12" -Space "Global"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [String]$Subnet,
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [String]$Name,
      [String]$Space,
      [Switch]$IncludeInheritance,
      [Switch]$Strict = $false,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [String]$id
    )

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Subnet) {
        $Filters.Add("address==`"$Subnet`"") | Out-Null
    }
    if ($CIDR) {
        $Filters.Add("cidr==$CIDR") | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Space) {
        $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
        $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
        if ($IncludeInheritance) {
            $Query = "?_filter=$Filter&_inherit=full"
        } else {
            $Query = "?_filter=$Filter"
        }
    } else {
        if ($IncludeInheritance) {
            $Query = "?_inherit=full"
        }
    }

    if ($Query) {
        Query-CSP -Uri "ipam/address_block$Query&_limit=$Limit&_offset=$Offset" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Uri "ipam/address_block?_limit=$Limit&_offset=$Offset" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}