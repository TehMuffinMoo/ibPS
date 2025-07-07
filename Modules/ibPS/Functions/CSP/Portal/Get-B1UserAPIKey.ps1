function Get-B1UserAPIKey {
    <#
    .SYNOPSIS
        Retrieves a list of Interactive Infoblox Portal API Keys for your user

    .DESCRIPTION
        This function is used to retrieve a list of Interactive Infoblox Portal API Keys for your user
        The actual API Key is only available during initial creation and cannot be retrieved afterwards via this API.

    .PARAMETER Name
        Filter the results by the name of the API Key

    .PARAMETER State
        Filter the results by the state of the API Key

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default and maximum number of results is 101.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER CaseSensitive
        Use Case Sensitive matching. By default, case-insensitive matching both for -Strict matching and regex matching.

    .PARAMETER id
        The id of the authoritative zone to filter by

    .EXAMPLE
        PS> Get-B1UserAPIKey -Name "somename" -State Enabled

    .EXAMPLE
        PS> Get-B1UserAPIKey -Name "apikeyname" -Strict

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Authentication
    #>
    [CmdletBinding()]
    param(
        [String]$Name,
        [ValidateSet("Enabled", "Disabled")]
        [String]$State,
        [Int]$Limit = 101,
        [Int]$Offset = 0,
        [Switch]$Strict,
        [String[]]$Fields,
        $CustomFilters,
        [Switch]$CaseSensitive,
        [String]$id
    )
	$MatchType = Match-Type $Strict $CaseSensitive
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($State) {
        $Filters.Add("state:=`"$State`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters -CaseSensitive:$CaseSensitive
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($Limit) {
        $QueryFilters.Add("_limit=$($Limit)") | Out-Null
    }
    if ($Offset) {
        $QueryFilters.Add("_offset=$($Offset)") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_api_keys$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_api_keys" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}