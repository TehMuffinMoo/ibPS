function Get-B1LookalikeDomains {
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

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .EXAMPLE
        PS> Get-B1LookalikeDomains -Domain google.com | ft detected_at,lookalike_domain,reason -AutoSize

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
    [CmdletBinding()]
    param(
      [String]$Domain,
      [String]$LookalikeHost,
      [String]$Reason,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [String[]]$Fields,
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
    if ($LookalikeHost) {
      $Filters.Add("lookalike_host$($MatchType)`"$LookalikeHost`"") | Out-Null
    }
    if ($Reason) {
      $Filters.Add("reason$($MatchType)`"$Reason`"") | Out-Null
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
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_domains$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_domains" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
      return $Results
    }
}