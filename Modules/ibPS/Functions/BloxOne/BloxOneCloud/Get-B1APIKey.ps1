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
        [ValidateSet("Enabled", "Disabled")]
        [String]$State,
        [Int]$Limit = 101,
        [Int]$Offset = 0,
        [Switch]$Strict,
        [String[]]$Fields,
        $CustomFilters,
        [String]$id
    )

    $QueryFilters = @()
    $QueryFilters += "_limit=$Limit"
    $QueryFilters += "_offset=$Offset"

    if ($CustomFilters) {
        $ParamFilter = Combine-Filters $CustomFilters
    } else {
        $MatchType = Match-Type $Strict

        [System.Collections.ArrayList]$ParamFilters = @()
        if ($User) {
            $ParamFilters += "user_email$MatchType`"$User`""
        }
        if ($CreatedBy) {
            $ParamFilters += "created_by$MatchType`"$CreatedBy`""
        }
        if ($Name) {
            $ParamFilters += "name$MatchType`"$Name`""
        }
        if ($Type) {
            $ParamFilters += "type:=`"$Type`""
        }
        if ($State) {
            $ParamFilters += "state:=`"$State`""
        }
        if ($id) {
            $ParamFilters += "id==`"$id`""
        }

        $ParamFilter = Combine-Filters($ParamFilters)
    }

    if ($ParamFilter) {
        $QueryFilters += "_filter=$ParamFilter"
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters += "_fields=$($Fields -join ",")"
    }
    $CombinedFilter += ConvertTo-QueryString($QueryFilters)

    $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/api_keys$CombinedFilter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
        return $Results
    }

}