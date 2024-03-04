function Get-B1TDTideThreatClass {
    <#
    .SYNOPSIS
        Queries a list of threat classes

    .DESCRIPTION
        This function will query a list of threat classes

    .PARAMETER id
        Filter the results by class ID

    .EXAMPLE
        PS> Get-B1TDTideThreatClass -id "Bot"

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>

    param(
      [string]$id
    )

    if ($id) {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/threat_classes/$id" -Method GET -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    } else {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/threat_classes" -Method GET | Select-Object -ExpandProperty threat_class -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}