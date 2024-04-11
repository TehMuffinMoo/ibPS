function Get-B1Range {
    <#
    .SYNOPSIS
        Queries a list of DHCP Ranges from BloxOneDDI

    .DESCRIPTION
        This function is used to get one or more next available address blocks from IPAM based on the criteria entered

    .PARAMETER StartAddress
        Use this parameter to search by the DHCP Range start address

    .PARAMETER EndAddress
        Use this parameter to search by the DHCP Range end address

    .PARAMETER Name
        Use this parameter to search by the DHCP Range Name

    .PARAMETER Space
        Use this parameter to filter the list of Address Blocks by Space

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

    .PARAMETER id
        Filter the results by range id

    .EXAMPLE
        PS> Get-B1Range -StartAddress "10.10.100.200" -EndAddress "10.10.100.250"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
      [String]$StartAddress,
      [String]$EndAddress,
      [String]$Name,
      [String]$Space,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [Switch]$Strict,
      [String]$tfilter,
      [String[]]$Fields,
      [String]$OrderBy,
      [String]$OrderByTag,
      [String]$id
    )

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($StartAddress) {
        $Filters.Add("start==`"$StartAddress`"") | Out-Null
    }
    if ($EndAddress) {
        $Filters.Add("end==`"$EndAddress`"") | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Space) {
        $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
        $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
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
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        Invoke-CSP -Uri "ipam/range$($QueryString)" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Uri "ipam/range?_limit=$Limit&_offset=$Offset" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}