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

    .PARAMETER id
        Use the id parameter to filter the results by ID

    .Example
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
        [Parameter(
          ValueFromPipelineByPropertyName = $true,
          ParameterSetName="ID",
          Mandatory=$true
        )]
        [String]$id
    )
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
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
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/infra/v1/$($ServicesUri)?_limit=$Limit&_filter=$Filter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/infra/v1/$($ServicesUri)?_limit=$Limit" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    
    if ($Results) {
        return $Results
    }
}