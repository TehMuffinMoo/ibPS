function Get-B1SOCInsight {
    <#
    .SYNOPSIS
        Queries a list of Insights from SOC Insights

    .DESCRIPTION
        This function is used to query a list of Insights from SOC Insights

    .PARAMETER Status
        Filter the results by the status of the Insight. By default, only active insights will be displayed. To see closed insights, use this parameter with a value of 'Closed'.

    .PARAMETER ThreatType
        Filter the results by the threat type of the Insight

    .PARAMETER Priority
        Filter the results by the priority of the Insight

    .PARAMETER insightId
        Filter the results by the insightId of the Insight

    .EXAMPLE
        PS> Get-B1SOCInsight -Priority CRITICAL | ft -AutoSize

        tClass    tFamily    insightId                            feedSource                  startedAt           threatType       status persistentDate     numEvents mostRecentAt
        ------    -------    ---------                            ----------                  ---------           ----------       ------ --------------     --------- ------------
        TI-DGA    ZLoader    41670f23-4149-4552-a32e-07ab6e57b99e Insight Detection Framework 2/7/2024 4:00:00PM  DGA              Active 2/7/2024 4:00:00PM 376       3/26/2024 8:57:56AM
        TI-DNST   Generic    7846a2ca-3d0c-4b6e-a017-bb765e4ccab0 Insight Detection Framework 4/3/2023 7:00:00AM  DNS Tunneling    Active 4/5/2023 6:00:00AM 20308     3/26/2024 10:59:30AM
        Lookalike Suspicious 35a1d37e-a1f6-492f-8329-70a42ea50d43 Insight Detection Framework 3/13/2024 8:00:00PM Lookalike Threat Active 3/4/2024 7:00:00PM 10        3/15/2024 4:27:00PM

    .EXAMPLE
        PS> Get-B1SOCInsight -ThreatType 'DGA'                         

        tClass             : TI-DGA
        tFamily            : SUPPOBOX
        insightId          : e06e383a-eee3-4cd9-ba3a-25a6ded9eeb4
        feedSource         : Insight Detection Framework
        startedAt          : 2/7/2024 4:00:00PM
        threatType         : DGA
        status             : Active
        persistentDate     : 2/12/2024 8:00:00PM
        numEvents          : 12
        mostRecentAt       : 3/26/2024 8:57:56AM
        eventsBlockedCount : 12
        dateChanged        : 3/18/2024 4:05:49PM
        priorityText       : MEDIUM
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense

    .FUNCTIONALITY
        SOC Insights
    #>
    param(
      [ValidateSet('Active','Closed')]
      [String]$Status,
      [String]$ThreatType,
      [ValidateSet('LOW','MEDIUM','HIGH','CRITICAL')]
      [String]$Priority,
      [String]$insightId
    )

    process {
      $QueryFilters = @()
      
      if ($Status) {
        $QueryFilters += "status=$($Status)"
      }
      if ($ThreatType) {
        $QueryFilters += "threat_type=$($ThreatType)"
      }
      if ($Priority) {
        $QueryFilters += "priority=$($Priority)"
      }
      if ($QueryFilters) {
        $QueryFilter = ConvertTo-QueryString $QueryFilters
      }

      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/v1/insights$QueryFilter" -Method GET | Select-Object -ExpandProperty insightList -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
  
      if ($Results) {
        return $Results
      }
    }
}