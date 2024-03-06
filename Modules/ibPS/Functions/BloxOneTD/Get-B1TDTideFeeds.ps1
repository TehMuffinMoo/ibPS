function Get-B1TDTideFeeds {
    <#
    .SYNOPSIS
        Queries a list BYOF RPZ threat feeds

    .DESCRIPTION
        This function is used to query a list of Bring Your Own File RPZ threat feeds

    .EXAMPLE
        PS> Get-B1TDTideFeeds
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
    )

    process {
      [System.Collections.ArrayList]$Filters = @()
      if ($Filters) {
          $Filter = "_filter="+(Combine-Filters $Filters)
      }
 
      if ($Filter) {
          $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/admin/v1/resources/feeds?$Filter" -Method GET | Select-Object -ExpandProperty feeds -ErrorAction SilentlyContinue
      } else {
          $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/admin/v1/resources/feeds" -Method GET | Select-Object -ExpandProperty feeds -ErrorAction SilentlyContinue
      }
  
      if ($Results) {
        return $Results
      }
    }
}