function Get-B1Record {
    <#
    .SYNOPSIS
        Queries DNS records from BloxOneDDI

    .DESCRIPTION
        This function is used to query DNS records from BloxOneDDI

    .PARAMETER Type
        The record type to filter by

    .PARAMETER Name
        The record name to filter by

    .PARAMETER Zone
        The record zone to filter by

    .PARAMETER rdata
        The record data to filter by

    .PARAMETER FQDN
        The record FQDN to filter by

    .PARAMETER Source
        Use this to filter by the record source type (i.e Static/Dynamic)

    .PARAMETER View
        The DNS View to filter by

        Filtering by DNS View is not supported by this API endpoint, so the filtering is done in postprocessing after the query is made. This means if the -View parameter is specified, it will only filter on already returned results.

    .PARAMETER Compartment
        Filter the results by Compartment Name

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER IncludeInheritance
        Whether to include inherited properties in the results

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
        Use the id parameter to filter the results by ID

    .EXAMPLE
        PS> Get-B1Record -Name "myArecord" -Zone "corp.mydomain.com" -View "default" | ft name_in_zone,rdata,type

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DNS
    #>
    [CmdletBinding()]
    param(
      [ValidateSet("A","AAAA","CAA","CNAME","DNAME","HTTPS","MX","NAPTR","NS","PTR","SRV","SVCB","TXT")]
      [String]$Type,
      [String]$Name,
      [String]$Zone,
      [String]$rdata,
      [String]$FQDN,
      [String]$Source,
      [String]$Compartment,
      [String]$View,
      [Switch]$Strict,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [switch]$IncludeInheritance = $false,
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
    if ($Type) {
      $Filters.Add("type==`"$Type`"") | Out-Null
    }
    if ($Name) {
        $Filters.Add("name_in_zone$MatchType`"$Name`"") | Out-Null
    }
    if ($rdata) {
        $Filters.Add("dns_rdata$MatchType`"$rdata`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($FQDN) {
        if ($Strict -and !($FQDN.EndsWith('.'))) { $FQDN += '.' }
        $Filters.Add("absolute_name_spec$MatchType`"$FQDN`"") | Out-Null
    }
    if ($Zone) {
        if ($Strict -and !($Zone.EndsWith('.'))) { $Zone += '.' }
        $Filters.Add("absolute_zone_name$MatchType`"$Zone`"") | Out-Null
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
        $QueryFilters.Add('_inherit=full') | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }

    if ($QueryString) {
        $Result = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/record$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Result = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/record?_limit=$Limit&_offset=$Offset" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($View) {
        $Result = $Result | Where-Object {$_.view_name -eq $View}
    }
    if ($Source) {
        $Result = $Result | Where-Object {$_.source -contains $Source}
    }
    return $Result
}