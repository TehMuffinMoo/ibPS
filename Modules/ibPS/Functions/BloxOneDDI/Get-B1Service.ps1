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
        Use this parameter to limit the quantity of results. The default number of results is 10001.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER id
        Use the id parameter to filter the results by ID

    .EXAMPLE
        Get-B1Service -Name "dns_bloxoneddihost1.mydomain.corp" -Detailed -Strict
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Service
    #>
    param(
        [Parameter(ParameterSetName="noID",Mandatory=$false)]
        [String]$Name,
        [Switch]$Detailed,
        [String]$Limit = "10001",
        [Switch]$Strict,
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
    if ($Detailed) {
      $ServicesUri = "detail_services"
    } else {
      $ServicesUri = "services"
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $Filters2.Add("_filter=$Filter") | Out-Null
    }
    $Filters2.Add("_limit=$Limit") | Out-Null
    $Filters2.Add("_offset=$Offset") | Out-Null
    if ($Filters2) {
        $Filter2 = Combine-Filters2 $Filters2
    }
    if ($Filter2) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/infra/v1/$($ServicesUri)$($Filter2)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/infra/v1/$($ServicesUri)?_limit=$Limit" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    
    if ($Results) {
        return $Results
    }
}