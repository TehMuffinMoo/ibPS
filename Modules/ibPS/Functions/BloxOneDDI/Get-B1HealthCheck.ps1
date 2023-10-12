function Get-B1HealthCheck {
    <#
    .SYNOPSIS
        Performs a health check on a BloxOneDDI Host

    .DESCRIPTION
        This function is used to perform a health check on a BloxOneDDI Host

    .PARAMETER OnPremHost
        The BloxOneDDI Host name/fqdn

    .PARAMETER Type
        The type of health check to perform

    .Example
        Get-B1NTPGlobalConfig
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Health
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$OnPremHost,
      [Parameter(Mandatory=$true)]
      [ValidateSet("ApplicationHealth")]
      [String]$Type
    )

    switch ($Type) {
      "ApplicationHealth" {
        $Hosts = Get-B1Host -Name $OnPremHost -Detailed
        $B1HealthStatus = @()
        foreach ($B1Host in $Hosts) {
            $B1HostHealthStatus = @{}
            $B1AppStatus = @()
            foreach ($B1App in $B1Host.services) {
                $B1AppData = @{
                    "Host" = $B1Host.display_name
                    "Application" = ($CompositeStateSpaces | Where-Object {$_.Service_Type -eq $B1App.service_type}).Application
                    "Friendly Name" = ($CompositeStateSpaces | Where-Object {$_.Service_Type -eq $B1App.service_type}).FriendlyName
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