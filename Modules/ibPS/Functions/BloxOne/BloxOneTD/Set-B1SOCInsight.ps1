function Set-B1SOCInsight {
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

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Get-B1SOCInsight -ThreatType 'Lookalike Threat' -Priority LOW | Set-B1SOCInsight -Status Closed

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        BloxOne Threat Defense

    .FUNCTIONALITY
        SOC Insights
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet('Active','Closed')]
      [String]$Status,
      [String]$Comment,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        Mandatory=$true
      )]
      [String[]]$insightId,
      [Switch]$Force
    )

    process {
      $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
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

      $JSON = $Body | ConvertTo-Json -Depth 5
      if($PSCmdlet.ShouldProcess("Update SOC Insight:`n$(JSONPretty($JSON))","Update SOC Insight: $($insightId -join ', ')",$MyInvocation.MyCommand)){
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/v1/insights/status" -Method PUT -Data $JSON

        if ($Results) {
          return $Results
        }
      }
    }
}