function Get-B1RecycleBin {
    <#
    .SYNOPSIS
        Queries the Universal DDI Recycle Bin

    .DESCRIPTION
        This function is used to query the Universal DDI Recycle Bin. This gives you visibility on deleted resources and their context.

    .PARAMETER ResourceName
        The name of the resource you would like to filter the recycle bin with

    .PARAMETER ResourceType
        Used to filter by Resource Type, such as "record" or "address_block"

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned from the Recycle Bin. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER CaseSensitive
        Use Case Sensitive matching. By default, case-insensitive matching both for -Strict matching and regex matching.

    .EXAMPLE
        PS> Get-B1RecycleBin -Limit "25" -Offset "0" -ResourceName "my.resource.name" -ResourceType "DNS Record"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Recycle Bin
    #>
    [CmdletBinding()]
    param(
      [string]$ResourceName,
      [string]$ResourceType,
      [Int]$Limit = 100,
      [Int]$Offset,
      [String]$OrderBy,
      [String[]]$Fields,
      $CustomFilters,
      [Switch]$CaseSensitive,
      [switch]$Strict,
      [String]$id
    )

    # Validate ResourceType parameter at runtime
    if ($ResourceType) {
        $ValidResourceTypes = Get-RecycleBinTypeFilters | ForEach-Object {$_.displayValue}
        if ($ResourceType -notin $ValidResourceTypes) {
            throw "ResourceType '$ResourceType' is not a valid recycle bin type filter."
        }
    }

    $MatchType = Match-Type $Strict $CaseSensitive
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($ResourceName) {
        $Filters.Add("name$MatchType`"$ResourceName`"") | Out-Null
    }
    if ($ResourceType) {
        $ObjectType = (Get-RecycleBinTypeFilters | Where-Object {$_.displayValue -eq $ResourceType}).objectType
        $Filters.Add("type$MatchType`"$ObjectType`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters -CaseSensitive:$CaseSensitive
    }
    if ($Filter) {
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($Limit) {
        $QueryFilters.Add("_limit=$Limit") | Out-Null
    }
    if ($Offset) {
        $QueryFilters.Add("_offset=$Offset") | Out-Null
    }
    if ($OrderBy) {
        $QueryFilters.Add("_order_by=$OrderBy") | Out-Null
    }
    $QueryString = ConvertTo-QueryString $QueryFilters

    Write-DebugMsg -Filters $QueryFilters

    if ($QueryString) {
        $Results = Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/atlas-recyclebin/v1/items$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        if ($Results) {
            return $Results
        } else {
            return $null
        }
    }
}