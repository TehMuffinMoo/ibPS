function Set-B1NTPServiceConfiguration {
    <#
    .SYNOPSIS
        Updates the NTP configuration for a particular service

    .DESCRIPTION
        This function is used to update the NTP configuration for a particular service

    .PARAMETER Name
        The name of the BloxOneDDI service to check the NTP configuration for

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER UseGlobalNTPConfig
        Use this parameter to apply the NTP Configuration from the Global NTP Configuration

    .Example
        Set-B1NTPServiceConfiguration -Name "mybloxonehost.corp.domain.com" -Strict -UseGlobalNTPConfig
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Service
    #>
  param (
    [Parameter(Mandatory=$true)]
    [String]$Name,
    [Parameter(Mandatory=$false)]
    [Switch]$Strict,
    [Switch]$UseGlobalNTPConfig = $true
  )

  $MatchType = Match-Type $Strict
  $B1Service = Get-B1Service -Name $Name -Strict:$Strict
  if ($B1Service) {
    if ($B1Service.count -gt 1) {
      Write-Host "Too many services returned. Please check the -name parameter, or use -Strict for strict parameter checking." -ForegroundColor Red
      $B1Service | Format-Table -AutoSize
    } else {
      if ($UseGlobalNTPConfig) {
        $GlobalNTPConfig = Get-B1GlobalNTPConfig
        $ServiceId = $($B1Service.id).replace("infra/service/","")
        $ConfigSplat = @{
          "ntp_config" = $GlobalNTPConfig.ntp_config
        } | ConvertTo-Json -Depth 5 -Compress
        $NewConfigResult = Query-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ntp/v1/service/config/$ServiceId" -Data $ConfigSplat | Select-Object -ExpandProperty ntp_service -ErrorAction SilentlyContinue
        if ($NewConfigResult.id) {
          Write-Host "Global NTP configuration applied successfully on $($B1Service.name)" -ForegroundColor Green
        } else {
          Write-Host "Failed to apply NTP Configuration on $($B1Service.name)" -ForegroundColor Red
        }
      }
    }
  }
}