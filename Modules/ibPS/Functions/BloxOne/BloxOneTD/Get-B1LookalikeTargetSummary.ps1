function Get-B1LookalikeTargetSummary {
    <#
    .SYNOPSIS
        Retrives the summary metrics from the Lookalike Activity Page within the CSP

    .DESCRIPTION
        This function is used to retrives the summary metrics from the Lookalike Activity Page within the CSP

    .PARAMETER Domain
        Filter the results by target domain

    .PARAMETER ThreatClass
        Filter the results by one or more Threat Class

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER Start
        A date parameter used as the starting date/time of the lookalike search. By default, the search will start from 30 days ago and returns the latest results first. You may need to increase the -Limit parameter or increase the -Start date/time to view earlier events.

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.
 
    .EXAMPLE
        PS> Get-B1LookalikeTargetSummary

    .EXAMPLE
        PS> Get-B1LookalikeTargetSummary -ThreatClass phishing,malware
    
    .EXAMPLE
        PS> Get-B1LookalikeTargetSummary -Start (Get-Date).AddDays(-7) -Domain 'google.com'

        detected_at                     : 3/12/2024 5:42:32PM
        lookalike_count_threats         : 32
        lookalike_count_total           : 925
        lookalike_threat_types          : {phishing, suspicious}
        target_domain                   : google.com
        target_domain_content_category  : {Search Engines}
        target_domain_registration_date : 1997-09-15
        target_domain_type              : common

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
      [String[]]$Fields,
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
    if ($Limit) {
        $QueryFilters.Add("_limit=$Limit") | Out-Null
    }
    if ($Offset) {
        $QueryFilters.Add("_offset=$Offset") | Out-Null
    }
    if ($Fields) {
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atclad/v1/target_lookalike_summaries$($QueryString)" -Method GET | Select-Object -ExpandProperty results -WA SilentlyContinue -EA SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atclad/v1/target_lookalike_summaries" -Method GET | Select-Object -ExpandProperty results -WA SilentlyContinue -EA SilentlyContinue
    }
  
    if ($Results) {
      return $Results
    }
}