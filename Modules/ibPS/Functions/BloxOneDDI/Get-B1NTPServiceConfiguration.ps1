﻿function Get-B1NTPServiceConfiguration {
    <#
    .SYNOPSIS
        Retrieves the NTP configuration for a particular service

    .DESCRIPTION
        This function is used to retrieve the NTP configuration for a particular service

    .PARAMETER Name
        The name of the BloxOneDDI service to check the NTP configuration for

    .PARAMETER ServiceId
        The Service ID of the NTP service to check

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1NTPServiceConfiguration -Name "mybloxonehost.corp.domain.com" -Strict
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Service
    #>
  param (
    [Parameter(Mandatory=$false)]
    [String]$Name,
    [Parameter(Mandatory=$false)]
    [String]$ServiceId,
    [Parameter(Mandatory=$false)]
    [Switch]$Strict
  )

  $MatchType = Match-Type $Strict
  if (!($ServiceId) -and $Name) {
    $B1Service = Get-B1Service -Name $Name -Strict:$Strict | where {$_.service_type -eq "ntp"}
    $ServiceId = $B1Service.id.replace("infra/service/","")
  }
  if ($B1Service) {
    if ($B1Service.count -gt 1) {
      Write-Host "Too many services returned. Please check the -name parameter, or use -Strict for strict parameter checking." -ForegroundColor Red
    } else {
      $Result = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/ntp/v1/service/config/$ServiceId" | select -ExpandProperty ntp_service -ErrorAction SilentlyContinue
      if ($Result) {
        $Result
      } else {
        Write-Host "Error. Failed to retrieve NTP Configuration for $Name" -ForegroundColor Red
      }
    }
  }
}