﻿function Set-B1NTPServiceConfiguration {
    <#
    .SYNOPSIS
        This function is used to update an NTP Service with the Global NTP Configuration

    .DESCRIPTION
        This function is used to update an NTP Service with the Global NTP Configuration

    .PARAMETER Name
        The name of the NTP service to update the NTP configuration on

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1NTPServiceConfiguration -Name "ntp_myhost.corp.domain.com" -Strict

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Service
    #>
  [CmdletBinding(
    SupportsShouldProcess,
    ConfirmImpact = 'Medium'
  )]
  param (
    [Parameter(Mandatory=$true)]
    [String]$Name,
    [Parameter(Mandatory=$false)]
    [Switch]$Strict,
    [Switch]$Force
  )
  $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
  $B1Service = Get-B1Service -Name $Name -Strict:$Strict
  if ($B1Service) {
    if ($B1Service.count -gt 1) {
      Write-Host "Too many services returned. Please check the -name parameter, or use -Strict for strict parameter checking." -ForegroundColor Red
      $B1Service | Format-Table -AutoSize
    } else {
      $GlobalNTPConfig = Get-B1GlobalNTPConfig
      $ServiceId = $($B1Service.id).replace("infra/service/","")
      $JSON = @{
        "ntp_config" = $GlobalNTPConfig.ntp_config
      } | ConvertTo-Json -Depth 5 -Compress

      if($PSCmdlet.ShouldProcess("Update NTP Service Configuration:`n$(JSONPretty($JSON))","Update NTP Service Configuration on: $($Name)",$MyInvocation.MyCommand)){
        $NewConfigResult = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ntp/v1/service/config/$ServiceId" -Data $JSON | Select-Object -ExpandProperty ntp_service -ErrorAction SilentlyContinue
        if ($NewConfigResult.id) {
          Write-Host "Global NTP configuration applied successfully on $($B1Service.name)" -ForegroundColor Green
        } else {
          Write-Host "Failed to apply NTP Configuration on $($B1Service.name)" -ForegroundColor Red
        }
      }
    }
  }
}