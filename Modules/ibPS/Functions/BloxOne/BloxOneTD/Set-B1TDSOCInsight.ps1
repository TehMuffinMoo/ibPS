function Set-B1TDSOCInsight {
    <#
    .SYNOPSIS
        Updates the status of an Insight from SOC Insights

    .DESCRIPTION
        This function is used to update the status of an Insight from SOC Insights

    .PARAMETER Status
        Which status the Insight should be updated to (Active/Closed)

    .PARAMETER Comment
        Optionally add a comment to be added to the Insight

    .PARAMETER insightId
        The insightId of the Insight to update. Accepts pipeline input (See examples)

    .EXAMPLE
        PS> Get-B1TDSOCInsight -ThreatType 'Lookalike Threat' -Priority LOW | Set-B1TDSOCInsight -Status Closed
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense

    .FUNCTIONALITY
        SOC Insights
    #>
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet('Active','Closed')]
      [String]$Status,
      [String]$Comment,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        Mandatory=$true
      )]
      [String[]]$insightId
    )

    process {
      $Body = @{
        "insight_ids" = @()
      }
      foreach ($ID in $insightId) {
        $Body.insight_ids += $ID
      }
      
      if ($Status) {
        $Body.status = $Status
      }
      if ($Comment) {
        $Body.comment = $Comment
      }

      $JSONBody = $Body | ConvertTo-Json -Depth 5
      
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/v1/insights/status" -Method PUT -Data $JSONBody

      if ($Results) {
        return $Results
      }
    }
}