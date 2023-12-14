function Get-B1TDTideThreatProperty {
    <#
    .SYNOPSIS
        Queries a list of threat properties

    .DESCRIPTION
        This function will query a list of threat properties

    .PARAMETER id
        Filter the results by property ID

    .PARAMETER Name
        Filter the results by property name

    .PARAMETER Class
        Filter the results by property threat class

    .PARAMETER ThreatLevel
        Filter the results by property threat level

    .Example
        Get-B1TDTideThreatProperty -Name "CamelCase" -ThreatLevel 100

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>

    param(
      [string]$id,
      [string]$Name,
      [string]$Class,
      [int]$ThreatLevel
    )

    $Filters = @()
    if ($Name) {
      $Filters += "name=$Name"
    }
    if ($Class) {
      $Filters += "class=$Class"
    }
    if ($ThreatLevel) {
      $Filters += "threat_level=$ThreatLevel"
    }
    if ($Filters) {
        $Filter = ConvertTo-QueryString($Filters)
    }

    if ($id) {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/properties/$id$filter" -Method GET | Select-Object -ExpandProperty property -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    } else {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/properties$filter" -Method GET | Select-Object -ExpandProperty property -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}