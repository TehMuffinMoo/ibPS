function Get-B1TideThreatEnrichment {
    <#
    .SYNOPSIS
        Used to retrieve threat enrichment data from Infoblox Threat Defense

    .DESCRIPTION
        This function is used to retrieve threat enrichment data from Infoblox Threat Defense

    .PARAMETER Type
        Use this parameter to specify the type of enrichment search to perform

    .PARAMETER Indicator
        Use this parameter to specify the indicator to search by. This will be either the domain name, URL or IP.
        When using the Threat Actor lookup, the indicator should be the name of the Threat Actor, e.g "APT1","Carbanak","FIN6", etc.

    .EXAMPLE
        PS> Get-B1TideThreatEnrichment

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Infoblox Threat Defense
    #>
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("Threat Actor","Nameserver Reputation","URLHaus","ThreatFox","TLD Risk","Mandiant","Whois","Geoinfo")] ## Mitre Lookup not yet implemented
      [String]$Type,
      [Parameter(Mandatory=$true)]
      [String]$Indicator
    )

    switch ($Type) {
      "Threat Actor" {
        $Uri = "/tide/threat-enrichment/threat_actor/lookup?name=$Indicator"
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)$Uri" -Method GET | Select-Object -ExpandProperty description -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
      }
      "Nameserver Reputation" {
        $Uri = "/tide/threat-enrichment/nameserver_reputation/search?indicator=$Indicator"
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)$Uri" -Method GET # Unable to test due to HTTP403
      }
      "URLHaus" {
        $Uri = "/tide/threat-enrichment/urlhaus/search?indicator=$Indicator"
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)$Uri" -Method GET # Unable to test due to HTTP403
      }
      "ThreatFox" {
        $Uri = "/tide/threat-enrichment/threatfox/search?indicator=$Indicator"
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)$Uri" -Method GET # Unable to test due to HTTP403
      }
      "TLD Risk" {
        $Uri = "/tide/threat-enrichment/tld_risk/search?indicator=$Indicator"
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)$Uri" -Method GET # Unable to test due to HTTP403
      }
      "Mandiant" {
        $Uri = "/tide/threat-enrichment/mandiant/indicator/search?indicator=$Indicator"
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)$Uri" -Method GET | Select-Object -ExpandProperty matches -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
      }
      "Whois" {
        $Uri = "/tide/threat-enrichment/whois/search?indicator=$Indicator"
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)$Uri" -Method GET # Unable to test due to HTTP403
      }
      "Geoinfo" {
        $Uri = "/tide/threat-enrichment/geoinfo/search?ip=$Indicator"
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)$Uri" -Method GET # Unable to test due to HTTP403
      }
    }
    if ($Results) {
      return $Results
    }
}