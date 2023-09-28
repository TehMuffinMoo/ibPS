function Get-B1Tag {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOneDDI Tags

    .DESCRIPTION
        This function is used to query a list of BloxOneDDI Tags

    .PARAMETER Name
        The name of the tag to filter by

    .PARAMETER Status
        The status of the tag to filter by

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1Tag -Name "siteCode"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Tags
    #>
    param(
        [String]$Name,
        [ValidateSet("active","revoked")]
        [String]$Status,
        [switch]$Strict
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("key$MatchType`"$Name`"") | Out-Null
    }
    if ($Status) {
        $Filters.Add("status$MatchType`"$Status`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
    if ($Filter) {
        Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atlas-tagging/v2/tags?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atlas-tagging/v2/tags" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}