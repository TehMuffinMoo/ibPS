function Get-B1TDLookalikeTargetSummary {
    <#
    .SYNOPSIS
        Retrives the summary metrics from the Lookalike Activity Page within the CSP

    .DESCRIPTION
        This function is used to retrives the summary metrics from the Lookalike Activity Page within the CSP

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Start
        A date parameter used as the starting date/time of the lookalike search. By default, the search will start from 30 days ago and returns the latest results first. You may need to increase the -Limit parameter or increase the -Start date/time to view earlier events.
 
    .EXAMPLE
        PS> Get-B1TDLookalikeTargetSummary

    .EXAMPLE
        PS> Get-B1TDLookalikeTargetSummary -ThreatClass phishing,malware
    
    .EXAMPLE
        PS> Get-B1TDLookalikeTargetSummary -Start (Get-Date).AddDays(-7) -Domain 'google.com'

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
      [String]$Domain,
      [ValidateSet('malware','phishing','suspicious')]
      [String[]]$ThreatClass,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [datetime]$Start = (Get-Date).AddDays(-30),
      [Switch]$Strict
    )

	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Domain) {
        $Filters.Add("target_domain$MatchType`"$Domain`"") | Out-Null
    }
    $Start = $Start.ToUniversalTime()
    if ($Start) {
        $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ssZ")
        $Filters.Add("detected_at>=`"$StartTime`"") | Out-Null
    }
    
    [System.Collections.ArrayList]$ThreatClasses = @()
    if ($ThreatClass) {
        foreach ($TC in $ThreatClass) {
            $ThreatClasses.Add("$($TC)==`"true`"") | Out-Null
        }
        $ThreatClassFilter = Combine-Filters $ThreatClasses -Type 'or'
        if ($ThreatClasses) {
            $Filters.Add("($ThreatClassFilter)") | Out-Null
        }
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    $QueryFilters.Add("_limit=$Limit") | Out-Null
    $QueryFilters.Add("_offset=$Offset") | Out-Null

    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }

    if ($QueryFilters) {
        $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atclad/v1/target_lookalike_summaries$($QueryString)" -Method GET | Select-Object -ExpandProperty results -WA SilentlyContinue -EA SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atclad/v1/target_lookalike_summaries" -Method GET | Select-Object -ExpandProperty results -WA SilentlyContinue -EA SilentlyContinue
    }
  
    if ($Results) {
      return $Results
    }
}