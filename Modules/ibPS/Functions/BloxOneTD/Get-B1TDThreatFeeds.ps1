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

    .EXAMPLE
        PS> Get-B1TDThreatFeeds -Name "AntiMalware" | ft -AutoSize      

        confidence_level description
        ---------------- -----------                                                                                                                                                                                                                                                                   
        HIGH             Suspicious/malicious as destinations: Enables protection against known malicious hostname threats that can take action on or control of your systems, such as Malware Command & Control, Malware Download, and active Phishing sites.                                         
        MEDIUM           Suspicious/malicious as destinations: Enables protection against known malicious or compromised IP addresses. These are known to host threats that can take action on or control of your systems, such as Malware Command & Control, Malware Download, and active Phishing si…
        LOW              Suspicious/malicious as destinations: An extension of the AntiMalware IP feed that contains recently expired Malware IP's with an extended time-to-live (TTL) applied. The extended time-to-live (TTL) provides an extended reach of protection for the DNS FW, but may also …
        LOW              Suspicious/malicious as destinations: An extension of the Base and AntiMalware feed that contains recently expired hostname 
    
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
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atcfw/v1/threat_feeds?_filter=$Filter" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/atcfw/v1/threat_feeds" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
  
    if ($Results) {
      return $Results
    }
}