function Get-B1TideThreatCounts {
    <#
    .SYNOPSIS
        Queries the threats count from TIDE API

    .DESCRIPTION
        This function will query the threat counts TIDE API which returns threat counts organized by type over time.

    .PARAMETER Historical
        Specify this switch to retrieve historical threat counts

    .Example
        Get-B1TideThreatCounts

    .Example
        Get-B1TideThreatCounts -Historical

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>

    param(
        [Switch]$Historical
    )


    if ($Historical) {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/threat/counts/historical" -Method GET
      if ($Results) {
        $NewResults = @()
        foreach ($r in $Results.data) {
          $ObjName = $r[0].PSObject.Properties.Name
          $NewResult = $r | Select -ExpandProperty $ObjName
          $NewResult | Add-Member -MemberType NoteProperty -Name "Date" -Value $ObjName
          $NewResults += $NewResult
        }
        return $NewResults
      }
    } else {
        $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/threat/counts" -Method GET | select -ExpandProperty counts
        if ($Results) {
            return $Results
        }
    }
}