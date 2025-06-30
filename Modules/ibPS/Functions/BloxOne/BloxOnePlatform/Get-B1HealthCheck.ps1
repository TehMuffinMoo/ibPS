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

        B1Host    : B1DDI-01
        DNS       : started
        Discovery : started
        CDC       : started
        AnyCast   : started
        DHCP      : started

    .EXAMPLE
        PS> Get-B1HealthCheck -B1Host "B1DDI" -Type "ApplicationHealth" | ft

        B1Host    Discovery AnyCast DHCP    CDC     DNS
        ------    --------- ------- ----    ---     ---
        B1DDI-01  started   started started started started
        B1DDI-01            started                 started

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Health
    #>
    [CmdletBinding()]
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
        foreach ($B1HostObj in $Hosts) {
            $B1HostHealthStatus = @{}
            $B1AppStatus = @()
            foreach ($B1App in $B1HostObj.services) {
                $B1AppData = @{
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
            $B1HostHealthStatus."B1Host" = $B1HostObj.display_name
            $B1HealthStatus += $B1HostHealthStatus
        }
        $B1HealthStatus | ConvertFrom-HashTable | Select-Object B1Host,* -EA SilentlyContinue
      }
    }
}