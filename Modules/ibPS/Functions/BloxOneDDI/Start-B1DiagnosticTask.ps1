function Start-B1DiagnosticTask {
    <#
    .SYNOPSIS
        Initiates a BloxOneDDI Diagnostic Task

    .DESCRIPTION
        This function is used to initiate a BloxOneDDI Diagnostic Task

    .PARAMETER OnPremHost
        The name/fqdn of the BloxOneDDI Host to run the task against

    .PARAMETER Traceroute
        This switch indicates you want to use the traceroute test

    .PARAMETER Target
        This is used as the target for the traceroute test

    .PARAMETER Port
        This is used as the port for the traceroute test

    .PARAMETER DNSTest
        This switch indicates you want to use the dns test

    .PARAMETER FQDN
        This is used as the fqdn for the dns test

    .PARAMETER NTPTest
        This switch indicates you want to use the ntp test

    .PARAMETER DNSConfiguration
        This switch indicates you want to return the DNS Configuration file

    .PARAMETER DHCPConfiguration
        This switch indicates you want to return the DHCP Configuration file

    .PARAMETER WaitForOutput
        Indicates whether the function should wait for results to be returned from the diagnostic task, or start it in the background only. This defaults to $true

    .Example
        Start-B1DiagnosticTask -DNSTest -FQDN "google.com"

    .Example
        Start-B1DiagnosticTask -DHCPConfiguration
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Tasks
    #>
  param(
    [parameter(Mandatory=$true)]
               [String]$OnPremHost,
    [parameter(ParameterSetName="traceroute",
               Mandatory=$true)]
               [Switch]$Traceroute,
    [parameter(ParameterSetName="traceroute",
               Mandatory=$true)]
               [String]$Target,
    [parameter(ParameterSetName="traceroute",
               Mandatory=$false)]
               [String]$Port,
    [parameter(ParameterSetName="dnstest",
               Mandatory=$true)]
               [Switch]$DNSTest,
    [parameter(ParameterSetName="dnstest",
               Mandatory=$true)]
               [String]$FQDN,
    [parameter(ParameterSetName="ntptest",
               Mandatory=$true)]
               [Switch]$NTPTest,
    [parameter(ParameterSetName="dnsconf",
               Mandatory=$true)]
               [Switch]$DNSConfiguration,
    [parameter(ParameterSetName="dhcpconf",
               Mandatory=$true)]
               [Switch]$DHCPConfiguration,
    [parameter(Mandatory=$false)]
               [Switch]$WaitForOutput = $true
  )

  $OPH = Get-B1Host -Name $OnPremHost

  if ($OPH.ophid) {
    if ($Traceroute) {
      $splat = @{
        "ophid" = $OPH.ophid
        "cmd" = @{
          "name" = "traceroute"
          "args" = @{
            "target" = $Target
            "port" = $Port
          }
        }
      }
    }

    if ($DNSTest) {
      $splat = @{
        "ophid" = $OPH.ophid
        "cmd" = @{
          "name" = "dns_test"
          "args" = @{
            "domain_name" = $FQDN
          }
        }
      }
    }

    if ($NTPTest) {
      $splat = @{
        "ophid" = $OPH.ophid
        "cmd" = @{
          "name" = "ntp_test"
        }
      }
    }


    if ($DNSConfiguration) {
      $splat = @{
        "ophid" = $OPH.ophid
        "cmd" = @{
          "name" = "dns_conf"
        }
      }
    }

    if ($DHCPConfiguration) {
      $splat = @{
        "ophid" = $OPH.ophid
        "cmd" = @{
          "name" = "dhcp_conf"
        }
      }
    }

    $splat = $splat | ConvertTo-Json
    if ($Debug) {$splat}
    $Result = Query-CSP -Method POST -Uri "https://csp.infoblox.com/atlas-onprem-diagnostic-service/v1/task" -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue
    if ($Result) {
      if ($WaitForOutput) {
        while ((Get-B1DiagnosticTask -id $Result.id).status -eq "InProgress") {
          Write-Host "Waiting for task to complete on $OnPremHost.." -ForegroundColor Yellow
          Wait-Event -Timeout 5
        }
        if ($DNSConfiguration) {
          $Job = Get-B1DiagnosticTask -id $Result.id -Download
        } elseif ($DHCPConfiguration) {
          $Job = Get-B1DiagnosticTask -id $Result.id -Download | select -ExpandProperty Dhcp4 -ErrorAction SilentlyContinue
        } else {
          $Job = Get-B1DiagnosticTask -id $Result.id
        }
        if ($Job) {
          return $Job
        } else {
          Write-Host "Job failed on $OnPremHost." -ForegroundColor Red
        }
      } else {
        return $Result
      }
    }
  }
}