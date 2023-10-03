function Get-B1TDTideInfoRank {
    <#
    .SYNOPSIS
        Queries the InfoRank List

    .DESCRIPTION
        This function will query the InfoRank List for specific or related domains

    .PARAMETER Domain
        Return results based on this domain name. When -Strict is not specified, this will match on whole or part domain names.

    .PARAMETER Strict
        Return results for this domain name only, by default all related domains will be returned

    .Example
        Get-B1TDTideInfoRank -Domain "amazonaws.com" -Strict

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>

    param(
      [Parameter(Mandatory=$true)]
      [string]$Domain,
      [switch]$Strict
    )

    if ($Strict) {
      $Uri = "/tide/api/data/set/inforank/lookup?domain=$Domain"
    } else {
      $Uri = "/tide/api/data/set/inforank/search?search=$Domain"
    }

    if ($Uri) {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)$Uri" -Method GET -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
      if ($Results) {
        if ($Strict) {
          return $Results
        } else {
          return $Results | Select -ExpandProperty matches -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        }
      }
    }
}