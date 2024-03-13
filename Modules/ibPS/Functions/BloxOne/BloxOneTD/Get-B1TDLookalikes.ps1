function Get-B1TDLookalikes {
    <#
    .SYNOPSIS
        Queries a list of lookalike domains

    .DESCRIPTION
        This function is used to retrieve information on lookalike domains

    .PARAMETER Domain
        Filter the results by target domain

    .PARAMETER LookalikeDomain
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
        PS> Get-B1TDLookalikes -Domain google.com -Reason "phishing" | ft registration_date,lookalike_domain,type,categories,reason -AutoSize

        registration_date lookalike_domain                type   categories       reason
        ----------------- ----------------                ----   ----------       ------
        2024-02-07        adsbygoogle.top                 common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-02-07.
        2023-11-27        apps-ai-assist-goo-gle.shop     common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2023-11-27.
        2024-03-01        gdgoogle.cn                     common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-03-01.
        2024-01-03        gogogle.cn                      common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-01-03.
        2024-02-16        googelphotos.life               common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-02-16.
        2024-02-21        google-com.top                  common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-02-21.
        2024-02-21        googlegames.vip                 common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-02-21.
        2024-02-29        googlehop.cn                    common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-02-29.
        2024-01-30        googleoglasi.top                common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-01-30.
        ...
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
      [String]$Domain,
      [String]$LookalikeDomain,
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
    if ($LookalikeDomain) {
      $Filters += "lookalike_domain$($MatchType)`"$LookalikeDomain`""
    }
    if ($Reason) {
      $Filters += "reason$($MatchType)`"$Reason`""
    }

    if ($Filters) {
        $Filter = "_filter="+(Combine-Filters $Filters)
    }
 
    if ($Filter) {
        $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalikes?$Filter&_limit=$Limit&_offset=$Offset" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalikes?_limit=$Limit&_offset=$Offset" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
  
    if ($Results) {
      return $Results
    }
}