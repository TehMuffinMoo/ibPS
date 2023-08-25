function Get-B1Service {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOneDDI Services

    .DESCRIPTION
        This function is used to query a list of deployed BloxOneDDI Services/Containers

    .PARAMETER Name
        Filters the results by the name of the container

    .PARAMETER Detailed
        Additionally returns related host information

    .PARAMETER Limit
        Used to limit the number of results. The default is 10001

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1Service -Name "dns_bloxoneddihost1.mydomain.corp" -Detailed -Strict
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Service
    #>
    param(
        [Parameter(Mandatory=$false)]
        [String]$Name,
        [Parameter(Mandatory=$false)]
        [Switch]$Detailed,
        [Parameter(Mandatory=$false)]
        [String]$Limit = "10001",
        [Parameter(Mandatory=$false)]
        [Switch]$Strict = $false
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Detailed) {
      $ServicesUri = "detail_services"
    } else {
      $ServicesUri = "services"
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $Results = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/infra/v1/$($ServicesUri)?_limit=$Limit&_filter=$Filter" | select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/infra/v1/$($ServicesUri)?_limit=$Limit" | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
    
    if ($Results) {
        return $Results
    }
}