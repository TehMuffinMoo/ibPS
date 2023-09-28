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

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1BulkOperation -Name "Backup of all CSP data"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Tasks
    #>
    param(
        [string]$id,
        [string]$Name,
        [switch]$Strict = $false
    )

	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $FilterIncQuery = "?_filter=$Filter"
    }

    if ($id) {
        Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/bulk/v1/operation/$id$FilterIncQuery" | select -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    } else {
        Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/bulk/v1/operation$FilterIncQuery" | select -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
}