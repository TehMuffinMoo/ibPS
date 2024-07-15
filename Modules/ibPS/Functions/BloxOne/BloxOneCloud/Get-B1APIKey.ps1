function Get-B1APIKey {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOne Cloud API Keys

    .DESCRIPTION
        This function is used to retrieve a list of API Keys from the BloxOne Cloud
        The actual API Key is only available during initial creation and cannot be retrieved afterwards via this API, except for Legacy Keys which are being deprecated.

    .PARAMETER User
        Filter the results by user_email

    .PARAMETER CreatedBy
        Filter the results by the original creator of the API Key

    .PARAMETER Name
        Filter the results by the name of the API Key

    .PARAMETER Type
        Filter the results by the API Key Type

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

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER id
        The id of the API Key to filter by

    .EXAMPLE
        PS> Get-B1APIKey -User "user@domain.corp" -Name "somename" -Type "interactive" -State Enabled

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Authentication
    #>
    param(
        [String]$User,
        [string]$CreatedBy,
        [String]$Name,
        [ValidateSet("Interactive", "Legacy", "Service")]
        [String]$Type,
        [ValidateSet("Enabled", "Disabled","Expired")]
        [String]$State,
        [Int]$Limit = 101,
        [Int]$Offset = 0,
        [Switch]$Strict,
        [String[]]$Fields,
        [String]$OrderBy,
        $CustomFilters,
        [String]$id
    )

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    $MatchType = Match-Type $Strict
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($User) {
        $Filters.Add("user_email$MatchType`"$User`"") | Out-Null
    }
    if ($CreatedBy) {
        $Filters.Add("created_by$MatchType`"$CreatedBy`"") | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Type) {
        $Filters.Add("type:=`"$Type`"") | Out-Null
    }
    if ($State) {
        $Filters.Add("state:=`"$State`"") | Out-Null
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
        $QueryFilters.Add("_fields=$($Fields -join ",")")
    }
    if ($OrderBy) {
        $QueryFilters.Add("_order_by=$($OrderBy)") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }

    Write-DebugMsg -Filters $QueryFilters

    $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/api_keys$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
        return $Results
    }

}