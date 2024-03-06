function Get-B1TDTideThreatCounts {
    <#
    .SYNOPSIS
        Queries the threats count from TIDE API

    .DESCRIPTION
        This function will query the threat counts TIDE API which returns threat counts organized by type over time.

    .PARAMETER Historical
        Specify this switch to retrieve historical threat counts

    .EXAMPLE
        PS> Get-B1TDTideThreatCounts

    .EXAMPLE
        Get-B1TDTideThreatCounts | Select-Object -ExpandProperty class_counts | Select-Object -ExpandProperty ip | Select-Object -ExpandProperty iid

        APT                    : 1010
        Cryptocurrency         : 6
        InternetInfrastructure : 209
        MalwareC2              : 61
        MalwareDownload        : 5
        Phishing               : 5
        Proxy                  : 4113
        Suspicious             : 192
        UnwantedContent        : 8

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
          $NewResult = $r | Select-Object -ExpandProperty $ObjName
          $NewResult | Add-Member -MemberType NoteProperty -Name "Date" -Value $ObjName
          $NewResults += $NewResult
        }
        return $NewResults
      }
    } else {
        $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/threat/counts" -Method GET | Select-Object -ExpandProperty counts
        if ($Results) {
            return $Results
        }
    }
}