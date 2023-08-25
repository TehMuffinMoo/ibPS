function New-B1Service {
    <#
    .SYNOPSIS
        Creates a new BloxOneDDI Service

    .DESCRIPTION
        This function is used to create a new BloxOneDDI Service

    .PARAMETER Name
        The name of the new BloxOneDDI Service

    .PARAMETER Description
        The description of the new BloxOneDDI Service

    .PARAMETER OnPremHost
        The name of the OnPremHost to create the service on

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER NTP
        This parameter specifies whether to deploy the NTP Service

    .PARAMETER DNS
        This parameter specifies whether to deploy the DNS Service

    .PARAMETER DHCP
        This parameter specifies whether to deploy the DHCP Service

    .Example
        New-B1Service -Name "dns_bloxoneddihost1.mydomain.corp" -Host "bloxoneddihost1.mydomain.corp" -NTP -DNS -DHCP
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Service
    #>
  [CmdletBinding(DefaultParameterSetName="default")]
  param (
    [Parameter(Mandatory=$true)]
    [String]$Name,
    [Parameter(Mandatory=$true)]
    [String]$OnPremHost,
    [Parameter(Mandatory=$false)]
    [String]$Description = "",
    [Parameter(Mandatory=$false)]
    [Switch]$Strict,
    [Parameter(ParameterSetName="NTP")]
    [Switch]$NTP,
    [Parameter(ParameterSetName="DNS")]
    [Switch]$DNS,
    [Parameter(ParameterSetName="DHCP")]
    [Switch]$DHCP
  )
  $MatchType = Match-Type $Strict
  $B1Host = Get-B1Host -Name $OnPremHost -Detailed
  if ($B1Host) {
    if ($B1Host.count -gt 1) {
      Write-Host "Too many hosts returned. Please check the -name parameter, or use -Strict for strict parameter checking." -ForegroundColor Red
      $B1Host | ft -AutoSize
    } else {
      if ($NTP) {
        if (Get-B1Service -Name $Name -Strict) {
          Write-Host "Service $Name already exists" -ForegroundColor Yellow
        } else {
          $splat = @{
            "name" = $Name
            "description" = $Description
            "service_type" = "ntp"
            "desired_state" = "start"
            "pool_id" = $($B1Host.pool.pool_id)
            "tags" = @{}
            "interface_labels" = @()
            "destinations" = @()
            "source_interfaces" = @()
          } | ConvertTo-Json -Depth 3
          $NewServiceResult = Query-CSP -Method POST -Uri "https://csp.infoblox.com/api/infra/v1/services" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
          if ($NewServiceResult.id) {
            Write-Host "NTP service created successfully on $OnPremHost" -ForegroundColor Green
            Set-B1NTPServiceConfiguration -Name $Name -UseGlobalNTPConfig
          } else {
            Write-Host "Failed to create NTP service on $OnPremHost" -ForegroundColor Red
          }
        }
      }

      if ($DNS) {
        if (Get-B1Service -Name $Name -Strict) {
          Write-Host "Service $Name already exists" -ForegroundColor Red
        } else {
          $splat = @{
            "name" = $Name
            "description" = $Description
            "service_type" = "dns"
            "desired_state" = "start"
            "pool_id" = $($B1Host.pool.pool_id)
            "tags" = @{}
            "interface_labels" = @()
            "destinations" = @()
            "source_interfaces" = @()
          } | ConvertTo-Json -Depth 3
          $NewServiceResult = Query-CSP -Method POST -Uri "https://csp.infoblox.com/api/infra/v1/services" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
          if ($NewServiceResult.id) {
            Write-Host "DNS service created successfully on $OnPremHost" -ForegroundColor Green
          } else {
            Write-Host "Failed to create DNS service $OnPremHost" -ForegroundColor Green
          }
        }
      }

      if ($DHCP) {
        if (Get-B1Service -Name $Name -Strict) {
          Write-Host "Service $Name already exists" -ForegroundColor Red
        } else {
          $splat = @{
            "name" = $Name
            "description" = $Description
            "service_type" = "dhcp"
            "desired_state" = "start"
            "pool_id" = $($B1Host.pool.pool_id)
            "tags" = @{}
            "interface_labels" = @()
            "destinations" = @()
            "source_interfaces" = @()
          } | ConvertTo-Json -Depth 3
          $NewServiceResult = Query-CSP -Method POST -Uri "https://csp.infoblox.com/api/infra/v1/services" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
          if ($NewServiceResult.id) {
            Write-Host "DHCP service created successfully on $OnPremHost" -ForegroundColor Green
          } else {
            Write-Host "Failed to create DHCP service $OnPremHost" -ForegroundColor Green
          }
        }
      }
    }
  }
}