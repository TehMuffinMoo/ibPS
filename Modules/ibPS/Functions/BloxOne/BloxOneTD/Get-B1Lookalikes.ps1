function Get-B1Lookalikes {
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

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields. This doesn't currently work due to the API side not filtering as expected.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER Muted
        Using the -Muted parameter allows you to filter results based on muted status

    .EXAMPLE
        PS> Get-B1Lookalikes -Domain google.com -Reason "phishing" | ft registration_date,lookalike_domain,type,categories,reason -AutoSize

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
      [String[]]$Fields,
      [ValidateSet('true','false')]
      [String]$Muted,
      [Switch]$Strict,
      $CustomFilters
    )

    $MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($Domain) {
      $Filters.Add("target_domain$($MatchType)`"$Domain`"") | Out-Null
    }
    if ($LookalikeDomain) {
      $Filters.Add("lookalike_domain$($MatchType)`"$LookalikeDomain`"") | Out-Null
    }
    if ($Reason) {
      $Filters.Add("reason$($MatchType)`"$Reason`"") | Out-Null
    }
    if ($Muted) {
        $Filters.Add("hidden==`"$($Muted)`"") | Out-Null
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
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalikes$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalikes" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
  
    if ($Results) {
      return $Results
    }
}