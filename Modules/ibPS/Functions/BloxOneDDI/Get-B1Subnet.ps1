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

    .PARAMETER id
        Use this parameter to query a particular subnet id

    .EXAMPLE
        Get-B1Subnet -Subnet 10.10.100.0 -CIDR 24 -IncludeInheritance

    .EXAMPLE
        Get-B1Subnet -Name "subnet-1" -Space "Global" -Strict
    
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
      [String]$id
    )

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$Filters2 = @()
    if ($Space) {
        $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
        if ($SpaceUUID) {
            $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
        }
    }
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
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $Filters2.Add("_filter=$Filter") | Out-Null
    }
    $Filters2.Add("_limit=$Limit") | Out-Null
    $Filters2.Add("_offset=$Offset") | Out-Null
    if ($tfilter) {
        $Filters2.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($IncludeInheritance) {
        $Filters2.Add("_inherit=full") | Out-Null
    }
    if ($Filters2) {
        $Filter2 = Combine-Filters2 $Filters2
    }

    if ($Filter2) {
        Query-CSP -Uri "ipam/subnet$($Filter2)" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Uri "ipam/subnet?_limit=$Limit&_offset=$Offset" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}