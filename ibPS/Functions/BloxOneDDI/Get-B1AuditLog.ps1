function Get-B1AuditLog {
    <#
    .SYNOPSIS
        Queries the BloxOneDDI Audit Log

    .DESCRIPTION
        This function is used to query the BloxOneDDI Audit Log. This gives you visibility on changes made both via the WebUI and API, along with the context of what has been modified.

    .PARAMETER Username
        The username of which you would like to filter the audit log with

    .PARAMETER ResourceType
        Used to filter by Resource Type, such as "record" or "address_block"

    .PARAMETER Method
        Use this parameter to filter by the HTTP Method of the API call

    .PARAMETER ResponseCode
        Use this parameter to filter by the HTTP Response Code of the API call

    .PARAMETER ClientIP
        Used to filter the Audit Log by IP Address

    .PARAMETER Action
        Use this parameter to filter by the Audit Log Action, i.e "Create" or "Update"

    .PARAMETER Start
        A date parameter used as the starting date/time of the log search. By default, the search will start from 24hrs ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned from the Audit Log. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1AuditLog -Limit "25" -Offset "0" -Username "my.email@domain.com" -Method "POST" -Action "Create" -ClientIP "1.2.3.4" -ResponseCode "200"
    
    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Logs
    #>
    param(
      [string]$Username,
      [string]$ResourceType,
      [ValidateSet("GET","POST","PUT", "PATCH", "DELETE")]
      [string]$Method,
      [int]$ResponseCode,
      [string]$ClientIP,
      [string]$Action,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [Int]$Limit = 100,
      [Int]$Offset,
      [switch]$Strict
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Username) {
        $Filters.Add("user_name$MatchType`"$Username`"") | Out-Null
    }
    if ($ResourceType) {
        $Filters.Add("resource_type$MatchType`"$ResourceType`"") | Out-Null
    }
    if ($Method) {
        $Filters.Add("http_method$MatchType`"$Method`"") | Out-Null
    }
    if ($ResponseCode) {
        $Filters.Add("http_code==$ResponseCode") | Out-Null
    }
    if ($ClientIP) {
        $Filters.Add("client_ip$MatchType`"$ClientIP`"") | Out-Null
    }
    if ($Action) {
        $Filters.Add("action$MatchType`"$Action`"") | Out-Null
    }
    if ($Start) {
        $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ssZ")
        $Filters.Add("created_at>=`"$StartTime`"") | Out-Null
    }
    if ($End) {
        $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ssZ")
        $Filters.Add("created_at<=`"$EndTime`"") | Out-Null
    }

    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }
        
    if ($Limit -and $Filters) {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/api/auditlog/v1/logs?_limit=$Limit&_offset=$Offset&_filter=$Filter" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } elseif ($Limit) {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/api/auditlog/v1/logs?_limit=$Limit" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } elseif ($Filters) {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/api/auditlog/v1/logs?_filter=$Filter" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "https://csp.infoblox.com/api/auditlog/v1/logs" -Method GET | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results) {
        return $Results
    } else {
        Write-Host "Error. Unable to find any audit logs." -ForegroundColor Red
        break
    }
}