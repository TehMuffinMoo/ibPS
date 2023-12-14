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

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER id
        The id of the authoritative zone to filter by

    .EXAMPLE
        Get-B1User -Name "MyName"

    .EXAMPLE
        Get-B1User -Email "MyName@domain.corp"

    .EXAMPLE
        Get-B1User -State Inactive

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
        [String]$id
    )

    $MatchType = Match-Type $Strict

    $QueryFilters = @()
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

    $CombinedFilter += ConvertTo-QueryString($QueryFilters)

    $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/users$CombinedFilter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
        return $Results
    }

}