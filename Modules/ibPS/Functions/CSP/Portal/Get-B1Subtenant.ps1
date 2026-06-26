function Get-B1Subtenant {
    <#
    .SYNOPSIS
        Retrieves a list of Subtenant (Sandbox) accounts

    .DESCRIPTION
        This function will retrieve a list of Subtenant (Sandbox) accounts associated with the current account

    .PARAMETER Name
        Filter the list of subtenants by their name

    .PARAMETER State
        Filter the list of subtenants by their state. Available states are "active" and "disabled"

    .PARAMETER Description
        Filter the list of subtenants by their description

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination
    
    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.
    
    .PARAMETER id
        Return a subtenant by its id

    .EXAMPLE
        PS> Get-B1Subtenant

    .EXAMPLE
        PS> Get-B1Subtenant -Name "My Subtenant"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Authentication
    #>
    param(
        [String]$Name,
        [ValidateSet("active", "disabled")]
        [String]$State,
        [String]$Description,
        [Int]$Limit = 100,
        [Int]$Offset,
        [Switch]$Strict,
        [String]$id
    )

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()

    $MatchType = Match-Type $Strict
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($State) {
        $Filters.Add("state$MatchType`"$State`"") | Out-Null
    }
    if ($Description) {
        $Filters.Add("description$MatchType`"$Description`"") | Out-Null
    }
    if ($id) {
        $id = $id -replace 'identity/accounts/',''
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
    $QueryString = ConvertTo-QueryString $QueryFilters
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        $Results = Invoke-CSP -Uri "$(Get-B1CSPUrl)/v2/sandbox/accounts$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        if ($Results) {
            return $Results
        } else {
            return $null
        }
    }
}
