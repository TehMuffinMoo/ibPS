function Get-B1TDLookalikeDomains {
    <#
    .SYNOPSIS
        Queries a list of detected Lookalike Domain objects with target domains specified by the account.

    .DESCRIPTION
        This function is used to retrieve information on all detected Lookalike Domain objects with target domains specified by the account.

    .PARAMETER Domain
        Filter the results by target domain

    .PARAMETER LookalikeHost
        Filter the results by lookalike domain

    .PARAMETER Reason
        Filter the results by reason

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .EXAMPLE
        PS> Get-B1TDLookalikeDomains -Domain google.com | ft detected_at,lookalike_domain,reason -AutoSize

        detected_at         lookalike_domain                                               reason
        -----------         ----------------                                               ------
        2/6/2024 6:40:48PM  googletah.shop                                                 Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2023-11-09.
        2/6/2024 6:41:09PM  cdn-google-tag.info                                            Domain is a lookalike to google.com and has suspicious registration, behavior, or associations with known threats. The creation or first seen date is 2024-01-16.
        2/6/2024 6:41:09PM  comgoogle.email                                                Domain is a lookalike to google.com and has suspicious registration, behavior, or associations with known threats. The creation or first seen date is 2023-11-12.
        2/6/2024 6:41:09PM  geminigoogle.xyz                                               Domain is a lookalike to google.com and has suspicious registration, behavior, or associations with known threats. The creation or first seen date is 2023-12-08.
        2/6/2024 6:41:36PM  123googleplaykarte.de                                          Domain is a lookalike to google.com. The creation date is unknown.
        2/6/2024 6:41:36PM  adsgoogle.gt                                                   Domain is a lookalike to google.com. The creation date is unknown.
        2/6/2024 6:41:36PM  a-googleseo.com                                                Domain is a lookalike to google.com. The creation date is 2023-10-27.
        2/6/2024 6:41:36PM  app-google.de                                                  Domain is a lookalike to google.com. The creation date is unknown.
        2/6/2024 6:41:36PM  bardgoogler.com                                                Domain is a lookalike to google.com. The creation date is 2023-04-02.
        2/6/2024 6:41:36PM  bestgoogles.shop                                               Domain is a lookalike to google.com. The creation date is 2023-11-09.
        2/6/2024 6:41:36PM  brightcastweightlossttgoogleuk.today                           Domain is a lookalike to google.com. The creation date is 2023-06-18.
        ...
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
      [String]$Domain,
      [String]$LookalikeHost,
      [String]$Reason,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [Switch]$Strict
    )

    $MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Domain) {
      $Filters += "target_domain$($MatchType)`"$Domain`""
    }
    if ($LookalikeHost) {
      $Filters += "lookalike_host$($MatchType)`"$LookalikeHost`""
    }
    if ($Reason) {
      $Filters += "reason$($MatchType)`"$Reason`""
    }

    if ($Filters) {
        $Filter = "_filter="+(Combine-Filters $Filters)
    }
 
    if ($Filter) {
        $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_domains?$Filter&_limit=$Limit&_offset=$Offset" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_domains?_limit=$Limit&_offset=$Offset" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
  
    if ($Results) {
      return $Results
    }
}