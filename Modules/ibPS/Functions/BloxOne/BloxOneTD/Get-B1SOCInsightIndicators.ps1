function Get-B1SOCInsightIndicators {
    <#
    .SYNOPSIS
        Queries a list of indicators related to a specific SOC Insight

    .DESCRIPTION
        This function is used to query a list of indicators related to a specific SOC Insight

    .PARAMETER Start
        Filter indicators which were added after the -Start date

    .PARAMETER End
        Filter indicators which were added before the -End date

    .PARAMETER insightId
        The insightId of the Insight to retrieve impacted indicators for.  Accepts pipeline input (See examples)

    .PARAMETER Confidence
        Filter the indicators by confidence level

    .PARAMETER Indicator
        Filter the indicator result by a specific indicator

    .PARAMETER Action
        Filter the indicators by the associated action

    .PARAMETER Actor
        Filter the indicators by the associated actor

    .PARAMETER Limit
        Set the limit for the quantity of event results (defaults to 100)

    .EXAMPLE
        PS> Get-B1SOCInsight -Priority CRITICAL | Get-B1SOCInsightIndicators | ft -AutoSize            

        action      confidence count threatLevelMax indicator                                    timeMax              timeMin
        ------      ---------- ----- -------------- ---------                                    -------              -------
        Blocked     3              3 3              gsgedgbdf.com                     3/26/2024 8:00:00AM  3/26/2024 8:00:00AM
        Blocked     3            270 2              gfsdfg.scrn.twgfdgfdrt.veryfastsecureweb.com 3/26/2024 1:00:00PM  3/26/2024 1:00:00PM
        Blocked     3            319 2              gddg43.scrn.gergdrgxd†.youfastsecureweb.com  3/26/2024 1:00:00PM  3/26/2024 1:00:00PM
        Blocked     3             17 2              scrn.dgrdegrdf.veryfastsecureweb.com         3/26/2024 1:00:00PM  3/26/2024 1:00:00PM
        ...

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense

    .FUNCTIONALITY
        SOC Insights
    #>
    param(
      [String]$Confidence,
      [String]$Indicator,
      [ValidateSet('Blocked','Not Blocked')]
      [String]$Action,
      [String]$Actor,
      [String]$Limit,
      [DateTime]$Start = (Get-Date).AddDays(-1),
      [DateTime]$End = (Get-Date),
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        Mandatory=$true
      )]
      [String[]]$insightId
    )

    process {
      $QueryFilters = @()
      
      if ($Confidence) {
        $QueryFilters += "confidence=$($ConfidenceLevel)"
      }
      if ($Indicator) {
        $QueryFilters += "indicator=$($Indicator)"
      }
      if ($Action) {
        $QueryFilters += "action=$($Action)"
      }
      if ($Actor) {
        $QueryFilters += "actor=$($Actor)"
      }
      if ($Start) {
        $Start = $Start.ToUniversalTime()
        $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ss.000")
        $QueryFilters += "from=$($StartTime)"
      }
      if ($End) {
        $End = $End.ToUniversalTime()
        $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ss.000")
        $QueryFilters += "to=$($EndTime)"
      }
      if ($Limit) {
        $QueryFilters += "limit=$($Limit)"
      }
      if ($QueryFilters) {
        $QueryFilter = ConvertTo-QueryString $QueryFilters
      }
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/v1/insights/$insightId/indicators$QueryFilter" -Method GET | Select-Object -ExpandProperty indicators -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
  
      if ($Results) {
        return $Results
      }
    }
}