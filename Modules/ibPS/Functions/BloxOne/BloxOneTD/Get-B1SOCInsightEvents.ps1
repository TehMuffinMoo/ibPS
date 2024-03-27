function Get-B1SOCInsightEvents {
    <#
    .SYNOPSIS
        Queries a list of events related to a specific SOC Insight

    .DESCRIPTION
        This function is used to query a list of events related to a specific SOC Insight

    .PARAMETER Start
        Filter events which were added after the -Start date

    .PARAMETER End
        Filter events which were added before the -End date

    .PARAMETER ThreatLevel
        Filter events by Threat Level

    .PARAMETER ConfidenceLevel
        Filter events by Confidence Level

    .PARAMETER Query
        Filter events by DNS Query

    .PARAMETER QueryType
        Filter events by DNS Query Type

    .PARAMETER Source
        Filter events by Network Source (i.e BloxOne Endpoint or specific DNS Forwarding Proxies)

    .PARAMETER IP
        Filter events by the Source IP

    .PARAMETER Indicator
        Filter events by the indicator

    .PARAMETER Limit
        Set the limit for the quantity of event results (defaults to 100)

    .PARAMETER insightId
        The insightId of the Insight to retrieve impacted events for.  Accepts pipeline input (See examples)

    .EXAMPLE
        PS> Get-B1SOCInsight -Priority CRITICAL | Get-B1SOCInsightEvents | ft -AutoSize

        confidenceLevel deviceName           macAddress        source           osVersion    action         policy                   deviceIp       query                                                                                                   queryType
        --------------- ----------           ----------        ------           ---------    ------         ------                   --------       -----                                                                                                   ---------
        High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 gdgdxsrgbxdfbgcxv.com                                                                                   A
        High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   80.153.81.224  fsfsef4wetrfeswg.com                                                                                    A
        High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   80.153.81.224  fsfsef4wetrfeswg.com                                                                                    A
        High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 vvv.fsgfsdxvxgddbn.vxgvr.xvfd.xvdxsv.dodgywebsite.com                                                   SRV
        High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 vvv.fsgfsdxvxgddbn.vxgvr.xvfd.xvdxsv.dodgywebsite.com                                                   A
        High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 vvv.fsgfsdxvxgddbn.vxgvr.xvfd.xvdxsv.dodgywebsite.com                                                   CNAME
        ...

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense

    .FUNCTIONALITY
        SOC Insights
    #>
    param(
      [String]$ThreatLevel,
      [String]$ConfidenceLevel,
      [String]$Query,
      [String]$QueryType,
      [String]$Source,
      [String]$IP,
      [String]$Indicator,
      [String]$Limit = 100,
      [DateTime]$Start = (Get-Date).AddDays(-1),
      [DateTime]$End = (Get-Date),
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        Mandatory=$true
      )]
      [String[]]$insightId
    )

    process {
      $QueryFilters = @()
      
      if ($ThreatLevel) {
        $QueryFilters += "threat_level=$($ThreatLevel)"
      }
      if ($ConfidenceLevel) {
        $QueryFilters += "confidence_level=$($ConfidenceLevel)"
      }
      if ($Query) {
        $QueryFilter += "query=$($Query)"
      }
      if ($QueryType) {
        $QueryFilter += "query_type=$($QueryType)"
      }
      if ($Source) {
        $QueryFilter += "source=$($Source)"
      }
      if ($IP) {
        $QueryFilter += "device_ip=$($IP)"
      }
      if ($Indicator) {
        $QueryFilter += "indicator=$($Indicator)"
      }
      if ($Start) {
        $Start = $Start.ToUniversalTime()
        $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ss.000")
        $QueryFilters += "from=$($StartTime)"
      }
      if ($End) {
        $End = $End.ToUniversalTime()
        $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ss.000")
        $QueryFilters += "to=$($EndTime)"
      }
      if ($Limit) {
        $QueryFilters += "limit=$($Limit)"
      }
      if ($QueryFilters) {
        $QueryFilter = ConvertTo-QueryString $QueryFilters
      }
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/v1/insights/$insightId/events$QueryFilter" -Method GET | Select-Object -ExpandProperty events -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
  
      if ($Results) {
        return $Results
      }
    }
}