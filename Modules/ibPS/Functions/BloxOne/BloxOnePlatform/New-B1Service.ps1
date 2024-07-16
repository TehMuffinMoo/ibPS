function New-B1Service {
    <#
    .SYNOPSIS
        Creates a new BloxOneDDI Service

    .DESCRIPTION
        This function is used to create a new BloxOneDDI Service

    .PARAMETER Name
        The name of the new BloxOneDDI Service

    .PARAMETER Type
        The type of service to deploy

    .PARAMETER Description
        The description of the new BloxOneDDI Service

    .PARAMETER B1Host
        The name of the BloxOne DDI Host to create the service on

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .EXAMPLE
        ## Create a DNS Service
        PS> New-B1Service -Type dns -Name "dns_bloxoneddihost1.mydomain.corp" -B1Host "bloxoneddihost1.mydomain.corp"

    .EXAMPLE
        ## Create a DHCP Service
        PS> New-B1Service -Type dhcp -Name "dhcp_bloxoneddihost1.mydomain.corp" -B1Host "bloxoneddihost1.mydomain.corp"

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
    [String]$Type,
    [Alias('OnPremHost')]
    [Parameter(Mandatory=$true)]
    [String]$B1Host,
    [Parameter(Mandatory=$false)]
    [String]$Description = "",
    [Parameter(Mandatory=$false)]
    [Switch]$Strict
  )
  $B1HostInfo = Get-B1Host -Name $B1Host -Detailed
  if ($B1HostInfo) {
    if ($B1HostInfo.count -gt 1) {
      Write-Host "Too many hosts returned. Please check the -name parameter, or use -Strict for strict parameter checking." -ForegroundColor Red
      $B1HostInfo | Format-Table -AutoSize
    } else {
      if (Get-B1Service -Name $Name -Strict) {
        Write-Host "Service $Name already exists" -ForegroundColor Yellow
      } else {
        $splat = @{
          "name" = $Name
          "description" = $Description
          "service_type" = $Type
          "desired_state" = "start"
          "pool_id" = $($B1HostInfo.pool.pool_id)
          "tags" = @{}
          "interface_labels" = @()
          "destinations" = @()
          "source_interfaces" = @()
        } | ConvertTo-Json -Depth 3
        $NewServiceResult = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/infra/v1/services" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        if ($NewServiceResult.id) {
          Write-Host "$($Type.ToUpper()) service created successfully on $($B1HostInfo.display_name)" -ForegroundColor Green
          if ($Type -eq "ntp") {
            Set-B1NTPServiceConfiguration -Name $Name -UseGlobalNTPConfig
          }
        } else {
          Write-Host "Failed to create $($Type.ToUpper()) service on $($B1HostInfo.display_name)" -ForegroundColor Red
        }
      }
    }
  }
}
