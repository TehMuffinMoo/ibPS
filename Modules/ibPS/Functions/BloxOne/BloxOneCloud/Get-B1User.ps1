function Get-B1User {
    <#
    .SYNOPSIS
        Retrieves a list of users from the BloxOne Cloud

    .DESCRIPTION
        This function is used to retrieve a list of users from the BloxOne Cloud

    .PARAMETER Name
        Filter the results by the name of the user

    .PARAMETER Email
        Filter the results by the email associated with the user

    .PARAMETER State
        Filter the results by the state of the user

    .PARAMETER Type
        Filter the results by the user type

    .PARAMETER Authenticator
        Filter the results by the user's authenticator

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.
        
    .PARAMETER id
        The id of the authoritative zone to filter by

    .EXAMPLE
        PS> Get-B1User -Name "MyName"

    .EXAMPLE
        PS> Get-B1User -Email "MyName@domain.corp"

    .EXAMPLE
        PS> Get-B1User -State Inactive

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Authentication
    #>
    param(
        [String]$Name,
        [String]$Email,
        [ValidateSet("Active", "Deactivated")]
        [String]$State,
        [ValidateSet("Local", "IdP","Service")]
        [String]$Type,
        [ValidateSet("Local", "IdP","Service")]
        [String]$Authenticator,
        [Int]$Limit = 101,
        [Int]$Offset = 0,
        [Switch]$Strict,
        [String[]]$Fields,
        [String]$OrderBy,
        [String]$id
    )

    $MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Limit) {
        $QueryFilters += "_limit=$Limit"
    }
    if ($Offset) {
        $QueryFilters += "_offset=$Offset"
    }

    $ParamFilters = @()
    if ($Name) {
        $ParamFilters += "name$MatchType`"$Name`""
    }
    if ($Email) {
        $ParamFilters += "email$MatchType`"$Email`""
    }
    if ($State) {
        $ParamFilters += "state:=`"$State`""
    }
    if ($Type) {
        $ParamFilters += "type:=`"$Type`""
    }
    if ($id) {
        $ParamFilters += "id==`"$id`""
    }
    if ($ParamFilters) {
        $ParamFilter = Combine-Filters($ParamFilters)
        $QueryFilters += "_filter=$ParamFilter"
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($OrderBy) {
        $QueryFilters.Add("_order_by=$($OrderBy)") | Out-Null
    }

    $CombinedFilter += ConvertTo-QueryString($QueryFilters)

    $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/users$CombinedFilter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
        return $Results
    }

}