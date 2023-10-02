function Get-B1DNSEvent {
    <#
    .SYNOPSIS
        Queries the BloxOne Threat Defense DNS Events

    .DESCRIPTION
        This function is used to query the BloxOne Threat Defense DNS Events. This is the log which contains all security policy hits.

    .PARAMETER Query
        Use this parameter to filter the DNS Events by hostname or FQDN

    .PARAMETER Source
        Used to filter the DNS Events by IP Address

    .PARAMETER Policy
        Used to filter the DNS Events by Policy Name

    .PARAMETER Policy
        Used to filter the DNS Events by Threat Level

    .PARAMETER Response
        Use this parameter to filter the DNS Log by the response, i.e "NXDOMAIN"

    .PARAMETER Start
        A date parameter used as the starting date/time of the log search. By default, the search will start from 24hrs ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned from the Audit Log. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .Example
        Get-B1DNSEvent
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Logs
    #>
    param(
      [String]$Query,
      [String]$IP,
      [String[]]$Response,
      [ValidateSet("RPZ","Analytic","Category")]
      [String[]]$Source,
      [String[]]$Network,
      [String[]]$Policy,
      [Int[]]$ThreatLevel,
      [String[]]$ThreatClass,
      [String[]]$FeedName,
      [String[]]$FeedType,
      [String[]]$UserGroup,
      [String[]]$AppCategory,
      [String[]]$ThreatProperty,
      [String[]]$ThreatIndicator,
      [ValidateSet("Log","Block","Default","Redirect")]
      [String[]]$PolicyAction,
      [String[]]$EndpointGroup,
      [String[]]$AppName,
      [String[]]$DNSView,
      [datetime]$Start = $(Get-Date).AddDays(-1),
      [datetime]$End = $(Get-Date),
      [int]$Limit = 100,
      [int]$Offset = 0
    )

    $StartEpoch = $((Get-Date -Date ($Start) -UFormat %s))
    $EndEpoch = $((Get-Date -Date ($End) -UFormat %s))

    $Filters = @()

    if ($StartEpoch) {
      $Filters += "t0=$StartEpoch"
    }
    if ($EndEpoch) {
        $Filters += "t1=$EndEpoch"
      }
    if ($Query) {
      $Filters += "qname=$Name"
    }
    if ($IP) {
      $Filters += "qip=$IP"
    }
    if ($Source) {
      $Filters += "source=$Source"
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
    if ($UserGroup) {
      $Filters += "user_group=$UserGroup"
    }
    if ($AppCategory) {
      $Filters += "app_category=$AppCategory"
    }
    if ($AppName) {
      $Filters += "app_name=$AppName"
    }
    if ($DNSView) {
      $DNSViewReturned = Get-B1DNSView -Name $DNSView -Strict
      $DNSViewReturnedId = $($DNSViewReturned).id.Substring(9)
      $Filters += "dns_view=$DNSView,$DNSViewReturnedId"
    }
    $Filters += "_format=json"

    if ($Filters) {
        $Filter = Combine-Filters2($Filters)
    }
    if ($Filter) {
      Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/dnsdata/v2/dns_event$Filter&_offset=$Offset&_limit=$Limit" | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    } else {
      Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/dnsdata/v2/dns_event&_offset=$Offset&_limit=$Limit" | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
}