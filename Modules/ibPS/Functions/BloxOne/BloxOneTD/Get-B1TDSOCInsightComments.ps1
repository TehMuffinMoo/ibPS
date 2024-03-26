function Get-B1TDSOCInsightComments {
    <#
    .SYNOPSIS
        Queries a list of comments related to a specific SOC Insight

    .DESCRIPTION
        This function is used to query a list of comments related to a specific SOC Insight

    .PARAMETER Start
        Filter comments which were added after the -Start date

    .PARAMETER End
        Filter comments which were added before the -End date

    .PARAMETER insightId
        The insightId of the Insight to retrieve impacted comments for.  Accepts pipeline input (See examples)

    .EXAMPLE
        PS> Get-B1TDSOCInsight -Priority CRITICAL | Get-B1TDSOCInsightComments

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense

    .FUNCTIONALITY
        SOC Insights
    #>
    param(
      [DateTime]$Start,
      [DateTime]$End,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        Mandatory=$true
      )]
      [String[]]$insightId
    )

    process {
      $QueryFilters = @()

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
      if ($QueryFilters) {
        $QueryFilter = ConvertTo-QueryString $QueryFilters
      }

      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/v1/insights/$insightId/comments$QueryFilter" -Method GET | Select-Object -ExpandProperty comments -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
  
      if ($Results) {
        return $Results
      }
    }
}