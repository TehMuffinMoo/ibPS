function Get-B1UserAPIKey {
    <#
    .SYNOPSIS
        Retrieves a list of Interactive BloxOne Cloud API Keys for your user

    .DESCRIPTION
        This function is used to retrieve a list of Interactive BloxOne Cloud API Keys for your user
        The actual API Key is only available during initial creation and cannot be retrieved afterwards via this API.

    .PARAMETER Name
        Filter the results by the name of the API Key

    .PARAMETER State
        Filter the results by the state of the API Key

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned from the Audit Log. The default and maximum number of results is 101.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER id
        The id of the authoritative zone to filter by

    .EXAMPLE
        Get-B1UserAPIKey -Name "somename" -State Enabled

    .EXAMPLE
        Get-B1UserAPIKey -Name "apikeyname" -Strict

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Authentication
    #>
    param(
        [String]$Name,
        [ValidateSet("Enabled", "Disabled")]
        [String]$State,
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
    if ($State) {
        $ParamFilters += "state:=`"$State`""
    }
    if ($id) {
        $ParamFilters += "id==`"$id`""
    }

     if ($ParamFilters) {
        $ParamFilter = Combine-Filters($ParamFilters)
        $QueryFilters += "_filter=$ParamFilter"
    }

    $CombinedFilter += Combine-Filters2($QueryFilters)

    $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_api_keys$CombinedFilter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
        return $Results
    }

}