function Get-B1HealthCheck {
    <#
    .SYNOPSIS
        Performs a health check on a BloxOneDDI Host

    .DESCRIPTION
        This function is used to perform a health check on a BloxOneDDI Host

    .PARAMETER B1Host
        The BloxOneDDI Host name/fqdn

    .PARAMETER Type
        The type of health check to perform

    .EXAMPLE
        PS> Get-B1HealthCheck -B1Host "B1DDI-01" -Type "ApplicationHealth"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Health
    #>
    param(
      [Alias('OnPremHost')]
      [Parameter(Mandatory=$true)]
      [String]$B1Host,
      [Parameter(Mandatory=$true)]
      [ValidateSet("ApplicationHealth")]
      [String]$Type
    )

    switch ($Type) {
      "ApplicationHealth" {
        $Hosts = Get-B1Host -Name $B1Host -Detailed
        $B1HealthStatus = @()
        foreach ($B1Host in $Hosts) {
            $B1HostHealthStatus = @{}
            $B1AppStatus = @()
            foreach ($B1App in $B1Host.services) {
                $B1AppData = @{
                    "Host" = $B1Host.display_name
                    "Application" = (Get-CompositeStateSpaces | Where-Object {$_.Service_Type -eq $B1App.service_type}).Application
                    "Friendly Name" = (Get-CompositeStateSpaces | Where-Object {$_.Service_Type -eq $B1App.service_type}).FriendlyName
                    "Status" = $B1App.status.status
                }
                $B1AppStatus += $B1AppData
            }
            foreach ($App in $B1AppStatus) {
              $B1HostHealthStatus += @{
                $($App.Application) = $($App.Status)
              }
            }
            $B1HostHealthStatus."Host" = $B1Host.display_name
            $B1HealthStatus += $B1HostHealthStatus
        }
        ($B1HealthStatus | ConvertTo-Json | ConvertFrom-Json) | Select-Object *
      }
    }
}