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
        A date parameter used as the starting date/time of the log search. By default, the search will start from 7 days ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned from the Audit Log. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .EXAMPLE
        PS> Get-B1AuditLog -Limit "25" -Offset "0" -Username "my.email@domain.com" -Method "POST" -Action "Create" -ClientIP "1.2.3.4" -ResponseCode "200"
    
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
      [datetime]$Start = (Get-Date).AddDays(-7),
      [datetime]$End = (Get-Date),
      [Int]$Limit = 100,
      [Int]$Offset,
      [String]$OrderBy,
      [String[]]$Fields,
      $CustomFilters,
      [switch]$Strict
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()

    if ($CustomFilters) {
        $Filter = Combine-Filters $CustomFilters
    } else {
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
    }

    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Filter) {
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($Limit) {
        $QueryFilters.Add("_limit=$Limit") | Out-Null
    }
    if ($Offset) {
        $QueryFilters.Add("_offset=$Offset") | Out-Null
    }
    if ($OrderBy) {
        $QueryFilters.Add("_order_by=$OrderBy") | Out-Null
    }
    $QueryString = ConvertTo-QueryString $QueryFilters

    Write-DebugMsg -Filters $QueryFilters

    if ($QueryString) {
        $Results = Query-CSP -Uri "$(Get-B1CSPUrl)/api/auditlog/v1/logs$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if ($Results) {
        return $Results
    } else {
        return $null
    }
}