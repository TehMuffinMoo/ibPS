function Get-B1Subnet {
    <#
    .SYNOPSIS
        Queries a list of Subnets from the BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to query a list of Subnets from the BloxOneDDI IPAM

    .PARAMETER Subnet
        Use this parameter to filter the list of Subnets by network address

    .PARAMETER CIDR
        Use this parameter to filter the list of Subnets by CIDR suffix

    .PARAMETER Name
        Use this parameter to filter the list of Subnets by Name

    .PARAMETER Space
        Use this parameter to filter the list of Subnets by Space

    .PARAMETER IncludeInheritance
        Whether to include data inherited from parent objects in results

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.
        
    .PARAMETER id
        Use this parameter to query a particular subnet id

    .EXAMPLE
        PS> Get-B1Subnet -Subnet 10.10.100.0 -CIDR 24 -IncludeInheritance

    .EXAMPLE
        PS> Get-B1Subnet -Name "subnet-1" -Space "Global" -Strict
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [String]$Subnet,
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [String]$Space,
      [String]$Name,
      [Switch]$IncludeInheritance,
      [Switch]$Strict,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [String]$tfilter,
      [String[]]$Fields,
      [String]$id
    )

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Space) {
        $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
        if ($SpaceUUID) {
            $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
        }
    }
    if ($Subnet) {
        if ($Subnet -match '/\d') { 
            $IPandMask = $Subnet -Split '/' 
            $Subnet = $IPandMask[0]
            $CIDR = $IPandMask[1]
        }
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
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    $QueryFilters.Add("_limit=$Limit") | Out-Null
    $QueryFilters.Add("_offset=$Offset") | Out-Null
    if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($IncludeInheritance) {
        $QueryFilters.Add("_inherit=full") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }

    if ($QueryString) {
        Query-CSP -Uri "ipam/subnet$($QueryString)" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Uri "ipam/subnet?_limit=$Limit&_offset=$Offset" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}