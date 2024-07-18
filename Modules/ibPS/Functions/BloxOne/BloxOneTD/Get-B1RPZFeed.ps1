function Get-B1RPZFeed {
    <#
    .SYNOPSIS
        Return a list of current records within one or more RPZ Feeds

    .DESCRIPTION
        Return a list of current records within one or more RPZ Feeds

    .PARAMETER FeedName
        One or more feed names to return current records for

    .EXAMPLE
        PS>

    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    [CmdletBinding()]
    param(
        [String[]]$FeedName
    )

    [System.Collections.ArrayList]$QueryFilters = @()
    if ($FeedName) {
        $QueryFilters.Add("feed_name=$($FeedName -join ",")") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/rpz-indicator/v1/current/rest$QueryString" -Method GET -AdditionalHeaders @{'Accept' = 'application/json'} | Select-Object -ExpandProperty records -ErrorAction SilentlyContinue
    } else {
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/rpz-indicator/v1/current/rest" -Method GET -AdditionalHeaders @{'Accept' = 'application/json'} | Select-Object -ExpandProperty records -ErrorAction SilentlyContinue
    }

    if ($Results) {
      return $Results
    }
}