function Get-B1TDPoPRegion {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOne Threat Defense PoP Regions

    .DESCRIPTION
        This function is used to query a list of BloxOne Threat Defense Point of Presence (PoP) Regions

    .PARAMETER Region
        Filter results by Region

    .PARAMETER Location
        Filter results by Location

    .PARAMETER id
        Filter the results by id

    .EXAMPLE
        PS> Get-B1TDPoPRegion
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName="notid")]
    param(
      [parameter(ParameterSetName="notid")]
      [String]$Region,
      [parameter(ParameterSetName="notid")]
      [String]$Location,
      [parameter(ParameterSetName="id")]
      [String]$id
    )

    [System.Collections.ArrayList]$Filters = @()
    if ($Region) {
        $Filters.Add("region==`"$Region`"") | Out-Null
    }
    if ($Location) {
        $Filters.Add("location~`"$Location`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($id) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/pop_regions/$id" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
    } elseif ($Filter) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/pop_regions?_filter=$Filter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/pop_regions" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}