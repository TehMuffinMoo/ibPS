function Get-B1TDSOCInsightAssets {
    <#
    .SYNOPSIS
        Queries a list of assets related to a specific SOC Insight

    .DESCRIPTION
        This function is used to query a list of assets related to a specific SOC Insight

    .PARAMETER IP
        Filter the asset results by source IP

    .PARAMETER MACAddress
        Filter the asset results by source MAC address

    .PARAMETER OSVersion
        Filter the asset results by the detected source OS Version

    .PARAMETER Start
        Filter the asset results by observed start time

    .PARAMETER End
        Filter the asset results by observed end time

    .PARAMETER User
        Filter the asset results by associated user

    .PARAMETER Limit
        Limit the number of results

    .PARAMETER insightId
        The insightId of the Insight to retrieve impacted assets for.  Accepts pipeline input (See examples)

    .EXAMPLE
        PS> Get-B1TDSOCInsight -Priority CRITICAL | Get-B1TDSOCInsightAssets

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense

    .FUNCTIONALITY
        SOC Insights
    #>
    param(
      [IPAddress]$IP,
      [String]$MACAddress,
      [String]$OSVersion,
      [DateTime]$Start,
      [DateTime]$End,
      [String]$User,
      [Int]$Limit,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        Mandatory=$true
      )]
      [String[]]$insightId
    )

    process {
      $QueryFilters = @()
      
      if ($IP) {
        $QueryFilters += "qip=$($IP.IPAddressToString)"
      }
      if ($MACAddress) {
        $QueryFilters += "cmac=$($MACAddress)"
      }
      if ($OSVersion) {
        $QueryFilters += "os_version=$($OSVersion)"
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
      if ($User) {
        $QueryFilters += "user=$($User)"
      }
      if ($Limit) {
        $QueryFilters += "limit=$($Limit)"
      }
      if ($QueryFilters) {
        $QueryFilter = ConvertTo-QueryString $QueryFilters
      }

      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/api/v1/insights/$insightId/assets$QueryFilter" -Method GET | Select-Object -ExpandProperty assets -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
  
      if ($Results) {
        return $Results
      }
    }
}