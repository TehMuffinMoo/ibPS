function Get-B1DNSEvent {
    <#
    .SYNOPSIS
        Queries the Infoblox Threat Defense DNS Events

    .DESCRIPTION
        This function is used to query the Infoblox Threat Defense DNS Events. This is the log which contains all security policy hits.

    .PARAMETER Query
        Use this parameter to filter the DNS Events by hostname or FQDN

    .PARAMETER IP
        Use the IP parameter to filter the DNS Events by the IP of the source making the query

    .PARAMETER Network
        Filter the DNS Events by one or more DFP Servers, External Networks & BloxOne Endpoints (i.e "ddihost.mydomain.corp (DFP)" or "ddihost1.mydomain.corp (DFP)","myddihost2.mydomain.corp (DFP)","BloxOne Endpoint"

    .PARAMETER Policy
        Used to filter the DNS Events by Policy Name

    .PARAMETER ThreatLevel
        Used to filter the DNS Events by Threat Level

    .PARAMETER ThreatClass
        Used to filter the DNS Events by Threat Class

    .PARAMETER FeedName
        Used to filter the DNS Events by Feed Name

    .PARAMETER FeedType
        Used to filter the DNS Events by Feed Type

    .PARAMETER AppCategory
        Used to filter the DNS Events by App Category

    .PARAMETER ThreatProperty
        Used to filter the DNS Events by Threat Property

    .PARAMETER ThreatIndicator
        Used to filter the DNS Events by Threat Indicator

    .PARAMETER PolicyAction
        Used to filter the DNS Events by Policy Action

    .PARAMETER AppName
        Used to filter the DNS Events by App Name

    .PARAMETER DNSView
        Used to filter the DNS Events by DNS View

    .PARAMETER Response
        Use this parameter to filter the DNS Log by the response, i.e "NXDOMAIN"

    .PARAMETER Start
        A date parameter used as the starting date/time of the log seatrch. By default, the search will start from 24hrs ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .EXAMPLE
        PS> Get-B1DNSEvent -Start (Get-Date).AddDays(-7)

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Logs
    #>
    [CmdletBinding()]
    param(
      [String]$Query,
      [String]$IP,
      [String[]]$Response,
      [ValidateSet("RPZ","Analytic","Category")]
      [String[]]$Network,
      [String[]]$Policy,
      [ValidateSet("Info","Low","Medium","High")]
      [String[]]$ThreatLevel,
      [String[]]$ThreatClass,
      [String[]]$FeedName,
      [String[]]$FeedType,
      [String[]]$AppCategory,
      [String[]]$ThreatProperty,
      [String[]]$ThreatIndicator,
      [ValidateSet("Log","Block","Default","Redirect")]
      [String[]]$PolicyAction,
      [String[]]$AppName,
      [String[]]$DNSView,
      [datetime]$Start = $(Get-Date).AddDays(-1),
      [datetime]$End = $(Get-Date),
      [String[]]$Fields,
      [int]$Limit = 100,
      [int]$Offset = 0
    )

    $StartEpoch = [math]::round($((Get-Date -Date ($Start) -UFormat %s)))
    $EndEpoch = [math]::round($((Get-Date -Date ($End) -UFormat %s)))

    $Filters = @()

    if ($StartEpoch) {
      $Filters += "t0=$StartEpoch"
    }
    if ($EndEpoch) {
        $Filters += "t1=$EndEpoch"
      }
    if ($Query) {
      $Filters += "qname=$Query"
    }
    if ($IP) {
      $Filters += "qip=$IP"
    }
    if ($Response) {
      $Filters += "rdata=$Response"
    }
    if ($Network) {
      $Filters += "network=$Network"
    }
    if ($Policy) {
      $Filters += "policy_name=$Policy"
    }
    if ($PolicyAction) {
      $Filters += "policy_action=$PolicyAction"
    }
    if ($ThreatLevel) {
      $Filters += "threat_level=$ThreatLevel"
    }
    if ($ThreatClass) {
      $Filters += "threat_class=$ThreatClass"
    }
    if ($ThreatProperty) {
      $Filters += "threat_property=$ThreatProperty"
    }
    if ($ThreatIndicator) {
      $Filters += "threat_indicator=$ThreatIndicator"
    }
    if ($FeedName) {
      $Filters += "feed_name=$FeedName"
    }
    if ($FeedType) {
      $Filters += "feed_type=$FeedType"
    }
    if ($AppCategory) {
      $Filters += "app_category=$AppCategory"
    }
    if ($AppName) {
      $Filters += "app_name=$AppName"
    }
    if ($Limit) {
      $Filters += "_limit=$Limit"
    }
    if ($Offset) {
      $Filters += "_offset=$Offset"
    }
    if ($DNSView) {
      $DNSViewReturned = Get-B1DNSView -Name $DNSView -Strict
      $DNSViewReturnedId = $($DNSViewReturned).id.Substring(9)
      $Filters += "dns_view=$DNSView,$DNSViewReturnedId"
    }
    if ($Fields) {
      $Filters += "_fields=$($Fields -join ",")"
    }
    $Filters += "_format=json"

    if ($Filters) {
        $Filter = ConvertTo-QueryString($Filters)
    }
    Write-DebugMsg -Filters $Filters
    if ($Filter) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/dnsdata/v2/dns_event$Filter" | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    } else {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/dnsdata/v2/dns_event" | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
}