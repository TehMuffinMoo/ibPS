function Get-B1TDSOCInsightIndicators {
    <#
    .SYNOPSIS
        Queries a list of indicators related to a specific SOC Insight

    .DESCRIPTION
        This function is used to query a list of indicators related to a specific SOC Insight

    .PARAMETER Start
        Filter indicators which were added after the -Start date

    .PARAMETER End
        Filter indicators which were added before the -End date

    .PARAMETER insightId
        The insightId of the Insight to retrieve impacted indicators for.  Accepts pipeline input (See examples)

    .EXAMPLE
        PS> Get-B1TDSOCInsight -Priority CRITICAL | Get-B1TDSOCInsightIndicators | ft -AutoSize

        confidenceLevel deviceName           macAddress        source           osVersion    action         policy                   deviceIp       query                                                                                                   queryType
        --------------- ----------           ----------        ------           ---------    ------         ------                   --------       -----                                                                                                   ---------
        High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 shrijyotishgurukulam.com                                                                                A
        High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   80.187.83.226  shrijyotishgurukulam.com                                                                                A
        High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   80.187.83.226  shrijyotishgurukulam.com                                                                                A
        High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 652.0b47e9309fb5620e056948650f7555d2603ab1f3b003fa2c07ed52.dxkeu0.scrn.586a62459e.veryfastsecureweb.com SRV
        High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 638.e23d3d370f0dfd11bed838eaa21a7f40dff881736ea3d693cd1d23.dxkeu0.scrn.586a62459e.youfastsecureweb.com  A
        High            CORP-C123F987AB      ab:cd:ef:12:34:56 BloxOne Endpoint macOS 14.2.1 Block          Global_Security_Policy   212.204.104.50 640.ca7a785bcb1c518c35a3d4b6111111111111111111111111111111.dxkeu0.scrn.586a62459e.veryfastsecureweb.com CNAME
        ...

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense

    .FUNCTIONALITY
        SOC Insights
    #>
    param(
      [String]$Confidence,
      [String]$Indicator,
      [ValidateSet('Blocked','Not Blocked')]
      [String]$Action,
      [String]$Actor,
      [String]$Limit,
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
      
      if ($Confidence) {
        $QueryFilters += "confidence=$($ConfidenceLevel)"
      }
      if ($Indicator) {
        $QueryFilters += "indicator=$($Indicator)"
      }
      if ($Action) {
        $QueryFilters += "action=$($Action)"
      }
      if ($Actor) {
        $QueryFilters += "actor=$($Actor)"
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
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/v1/insights/$insightId/indicators$QueryFilter" -Method GET | Select-Object -ExpandProperty indicators -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
  
      if ($Results) {
        return $Results
      }
    }
}