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

    .PARAMETER Compartment
        Filter the results by Compartment Name

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

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER OrderByTag
        Optionally return the list ordered by a particular tag value. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

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
    [CmdletBinding()]
    param(
      [String]$Subnet,
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [String]$Space,
      [String]$Name,
      [String]$Compartment,
      [Switch]$IncludeInheritance,
      [Switch]$Strict,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [String]$tfilter,
      [String[]]$Fields,
      [String]$OrderBy,
      [String]$OrderByTag,
      $CustomFilters,
      [String]$id
    )
	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
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
    if ($Compartment) {
        $CompartmentID = (Get-B1Compartment -Name $Compartment -Strict).id
        if ($CompartmentID) {
            $Filters.Add("compartment_id==`"$CompartmentID`"") | Out-Null
        } else {
            Write-Error "Unable to find compartment with name: $($Compartment)"
            return $null
        }
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    if ($Limit) {
        $QueryFilters.Add("_limit=$Limit") | Out-Null
    }
    if ($Offset) {
        $QueryFilters.Add("_offset=$Offset") | Out-Null
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($OrderBy) {
        $QueryFilters.Add("_order_by=$OrderBy") | Out-Null
    }
    if ($OrderByTag) {
        $QueryFilters.Add("_torder_by=$OrderByTag") | Out-Null
    }
    if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($IncludeInheritance) {
        $QueryFilters.Add("_inherit=full") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/subnet$($QueryString)" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/subnet?_limit=$Limit&_offset=$Offset" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}