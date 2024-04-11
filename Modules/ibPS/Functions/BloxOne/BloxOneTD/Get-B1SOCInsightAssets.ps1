function Get-B1SOCInsightAssets {
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
        PS> Get-B1SOCInsight -Priority CRITICAL | Get-B1SOCInsightAssets | Sort-Object threatIndicatorDistinctCount -Descending | ft -AutoSize

        cid                                                               cmac              count qip             location                   osVersion      threatLevelMax threatIndicatorDistinctCount timeMax              timeMin
        ---                                                               ----              ----- ---             --------                   ---------      -------------- ---------------------------- -------              -------
        cscuygwfybfsebfy4b4hf34h798fsbew:vlmfg90hgr54gmdg0g4rgdn9gh5ryg8l ab:cd:ef:12:34:56  4845 81.42.14.78     Alcalá de Henares,Spain    macOS 14.2.1   3              9                            3/1/2024 9:00:00AM   2/29/2024 7:00:00PM
        fsdfnje98jnsdxng984tjngmdhj6m6uj:vlmfg90hgr54gmdg0g4rgdn9gh5ryg8l 12:34:56:ab:cd:ef  2028 43.54.25.86     Marcq-en-Baroeul,France    macOS 14.2.1   2              8                            3/26/2024 11:00:00AM 3/26/2024 8:00:00AM
        fsdfnje98jnsdxng984tjngmdhj6m6uj:vlmfg90hgr54gmdg0g4rgdn9gh5ryg8l 12:34:56:ab:cd:ef  1097 43.54.25.86     Houilles,France            macOS 14.2.1   2              5                            3/25/2024 9:00:00PM  3/22/2024 8:00:00AM
        jmjkumfdadguyg76fvgdglniuhvoxdbd:vlmfg90hgr54gmdg0g4rgdn9gh5ryg8l ab:12:cd:34:ef:56  1300 120.134.53.53   Prague,Czechia             macOS 14.3.1   3              4                            2/26/2024 9:00:00AM  2/26/2024 8:00:00AM
        ...

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
      Write-DebugMsg -Filters $QueryFilters
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/v1/insights/$insightId/assets$QueryFilter" -Method GET | Select-Object -ExpandProperty assets -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
  
      if ($Results) {
        return $Results
      }
    }
}