function Get-B1ForwardZone {
    <#
    .SYNOPSIS
        Retrieves a list of forward zones from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list forward zones from BloxOneDDI

    .PARAMETER FQDN
        The fqdn of the forward zone to filter by

    .PARAMETER Disabled
        Filter results based on if the forward zone is disabled or not

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER View
        The DNS View where the forward zone(s) are located

    .PARAMETER Compartment
        Filter the results by Compartment Name

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
        Filter the results by forward zone id

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        PS> Get-B1ForwardZone -FQDN "prod.mydomain.corp"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DNS
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(
      [String]$FQDN,
      [bool]$Disabled,
      [switch]$Strict = $false,
      [String]$View,
      [String]$Compartment,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [String]$tfilter,
      [String[]]$Fields,
      [String]$OrderBy,
      [String]$OrderByTag,
      $CustomFilters,
      [String]$id
    )
    if ($View) {$ViewUUID = (Get-B1DNSView -Name $View -Strict).id}
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($FQDN) {
        $Filters.Add("fqdn$MatchType`"$FQDN`"") | Out-Null
    }
    if ($Disabled) {
        $Filters.Add("disabled==`"$Disabled`"") | Out-Null
    }
    if ($ViewUUID) {
        $Filters.Add("view==`"$ViewUUID`"") | Out-Null
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
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/forward_zone$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/forward_zone?_limit=$Limit&_offset=$Offset" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}