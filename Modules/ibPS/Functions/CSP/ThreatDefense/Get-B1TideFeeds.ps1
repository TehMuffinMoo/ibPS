﻿function Get-B1TideFeeds {
    <#
    .SYNOPSIS
        Queries a list BYOF RPZ threat feeds

    .DESCRIPTION
        This function is used to query a list of Bring Your Own File RPZ threat feeds

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .EXAMPLE
        PS> Get-B1TideFeeds | ft -AutoSize

        id                        name                   description                  profiles                                        csp_id storage_id
        --                        ----                   -----------                  --------                                        ------ ----------
        123456.amfeed             amfeed                 AntiMalware Feed            {0014B00014BaC3hQKF:AntiMalware-Profile}         123456    654321
        123456.kbfeed             kbfeed                 Known Bad Feed              {0014B00014BaC3hQKF:KnownBad-Profile}            123456    654321
        123456.tsfeed             tsfeed                 Test Feed                   {0014B00014BaC3hQKF:Test-Profile}                123456    654321
        123456.scfeed             scfeed                 Secure Feed                 {0014B00014BaC3hQKF:Secure-Profile}              123456    654321
        ...

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Infoblox Threat Defense
    #>
    [CmdletBinding()]
    param(
        $CustomFilters
    )

    process {
      [System.Collections.ArrayList]$Filters = @()
      if ($CustomFilters) {
          $Filters.Add($CustomFilters) | Out-Null
    }
      if ($Filters) {
          $Filter = "_filter="+(Combine-Filters $Filters)
      }

      if ($Filter) {
          $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/tide/admin/v1/resources/feeds?$Filter" -Method GET | Select-Object -ExpandProperty feeds -ErrorAction SilentlyContinue
      } else {
          $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/tide/admin/v1/resources/feeds" -Method GET | Select-Object -ExpandProperty feeds -ErrorAction SilentlyContinue
      }

      if ($Results) {
        return $Results
      }
    }
}