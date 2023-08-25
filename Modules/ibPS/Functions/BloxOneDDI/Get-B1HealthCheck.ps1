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
            $B1AppStatus = @()
            foreach ($B1App in $B1Host.services) {
                $B1AppData = @{
                    "Host" = $B1Host.display_name
                    "Application" = ($CompositeStateSpaces | where {$_.Service_Type -eq $B1App.service_type}).Application
                    "Friendly Name" = ($CompositeStateSpaces | where {$_.Service_Type -eq $B1App.service_type}).FriendlyName
                    "Status" = $B1App.status.status
                }
                $B1AppStatus += $B1AppData
            }
            $B1HealthStatus += @{
                "Host" = $B1Host.display_name
                "DNS" = $($Status = ($B1AppStatus | where {$_.Application -eq "DNS"}).Status;if ((!$Status)) {"Not Installed"} else {$Status})
                "DFP" = $($Status = ($B1AppStatus | where {$_.Application -eq "DFP"}).Status;if ((!$Status)) {"Not Installed"} else {$Status})
                "DHCP" = $($Status = ($B1AppStatus | where {$_.Application -eq "DHCP"}).Status;if ((!$Status)) {"Not Installed"} else {$Status})
                "NTP" = $($Status = ($B1AppStatus | where {$_.Application -eq "NTP"}).Status;if ((!$Status)) {"Not Installed"} else {$Status})
                "DC" = $($Status = ($B1AppStatus | where {$_.Application -eq "DC"}).Status;if ((!$Status)) {"Not Installed"} else {$Status})
            }
        }
        ($B1HealthStatus | ConvertTo-Json | ConvertFrom-Json) | select Host,DNS,DHCP,NTP,DFP,DC
      }
    }
}