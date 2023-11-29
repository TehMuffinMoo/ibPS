function Get-B1AuthoritativeNSG {
    <#
    .SYNOPSIS
        Retrieves a list of Authoritative DNS Server Groups from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list Authoritative DNS Server Groups from BloxOneDDI

    .PARAMETER Name
        The name of the Authoritative DNS Server Group

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER id
        Return results based on the authoritative NSG id

    .EXAMPLE
        Get-B1AuthoritativeNSG -Name "Data Centre" -Strict
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [String]$Name,
        [Switch]$Strict = $false,
        [String]$tfilter,
        [String]$id
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$Filters2 = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $Filters2.Add("_filter=$Filter") | Out-Null
    }
    if ($tfilter) {
        $Filters2.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($Filters2) {
        $Filter2 = Combine-Filters2 $Filters2
    }

    if ($Filters2) {
        $Filter2 = Combine-Filters2 $Filters2
        Query-CSP -Method GET -Uri "dns/auth_nsg$($Filter2)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dns/auth_nsg" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}