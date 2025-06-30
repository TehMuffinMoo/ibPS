function Get-B1BulkOperation {
    <#
    .SYNOPSIS
        Used to query BloxOne Bulk Operations

    .DESCRIPTION
        This function is used to query BloxOne Bulk Operations

    .PARAMETER id
        Filter the results by bulk operation id

    .PARAMETER Name
        Filter the results by bulk operation name

    .PARAMETER Type
        Filter the results by the operation type, such as 'export' or 'import'.

    .PARAMETER Status
        Filter the results by the operation status, such as 'completed' or 'failed'.

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER CaseSensitive
        Use Case Sensitive matching. By default, case-insensitive matching both for -Strict matching and regex matching.

    .EXAMPLE
        PS> Get-B1BulkOperation -Name "My Import Job"

    .EXAMPLE
        PS> Get-B1BulkOperation -Type 'export'

    .EXAMPLE
        PS> Get-B1BulkOperation -Type 'import'

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Tasks
    #>
    [CmdletBinding()]
    param(
        [String]$id,
        [String]$Name,
        [String]$Type,
        [ValidateSet('Active','Completed','Failed')]
        [String]$Status,
        [Switch]$Strict,
        [Switch]$CaseSensitive
    )

	$MatchType = Match-Type $Strict $CaseSensitive
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Type) {
        $Filters.Add("operation_type$MatchType`"$Type`"") | Out-Null
    }
    if ($Status) {
        $Filters.Add("overall_status==`"$($Status.ToLower())`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters -CaseSensitive:$CaseSensitive
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }

    Write-DebugMsg -Filters $QueryFilters

    if ($QueryString) {
        Invoke-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/bulk/v1/operation$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    } else {
        Invoke-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/bulk/v1/operation" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
}