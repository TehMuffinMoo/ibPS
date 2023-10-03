function Get-B1TDThreatFeeds {
    <#
    .SYNOPSIS
        Use this cmdlet to retrieve information on all Threat Feed objects for the account

    .DESCRIPTION
        Use this cmdlet to retrieve information on all Threat Feed objects for the account. BloxOne Cloud provides predefined threat intelligence feeds based on your subscription. The Plus subscription offers a few more feeds than the Standard subscription. The Advanced subscription offers a few more feeds than the Plus subscription. A threat feed subscription for RPZ updates offers protection against malicious hostnames.

    .PARAMETER Name
        Use this parameter to filter the list of Subnets by Name

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1TDThreatFeeds -Name "FarSightNOD","AntiMalware"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
        [String]$Name,
        [Switch]$Strict
    )
 
	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()

    if ($Name) {
        $Filters.Add("name$($MatchType)`"$Name`"") | Out-Null
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atcfw/v1/threat_feeds?_filter=$Filter" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atcfw/v1/threat_feeds" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
  
    if ($Results) {
      return $Results
    }
}