function Get-B1SOCInsightComments {
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
        PS> Get-B1SOCInsight -Priority LOW | Get-B1SOCInsightComments

        commentsChanger                                                     newComment       dateChanged          status
        ---------------                                                     ----------       -----------          ------
        me@company.corp                                                     Investigating    3/26/2024 12:25:07PM Active
        me@company.corp                                                     Closed Insight   3/26/2024 12:21:49PM Active
        me@company.corp                                                     Opened Insight   3/26/2024 12:20:49PM Closed
        ...

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Infoblox Threat Defense

    .FUNCTIONALITY
        SOC Insights
    #>
    [CmdletBinding()]
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
      Write-DebugMsg -Filters $QueryFilters
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/v1/insights/$insightId/comments$QueryFilter" -Method GET | Select-Object -ExpandProperty comments -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

      if ($Results) {
        return $Results
      }
    }
}