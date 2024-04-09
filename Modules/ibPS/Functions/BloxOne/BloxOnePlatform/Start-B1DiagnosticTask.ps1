function Start-B1DiagnosticTask {
    <#
    .SYNOPSIS
        Initiates a BloxOneDDI Diagnostic Task

    .DESCRIPTION
        This function is used to initiate a BloxOneDDI Diagnostic Task

    .PARAMETER B1Host
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

    .PARAMETER id
        The id of the BloxOneDDI Host to run the diagnostic task on. Accepts pipeline input

    .EXAMPLE
        PS> Start-B1DiagnosticTask -DNSTest -FQDN "google.com"

    .EXAMPLE
        PS> Start-B1DiagnosticTask -DHCPConfiguration
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Tasks
    #>
  param(
    [Alias('OnPremHost')]
    [String]$B1Host,
    [parameter(ParameterSetName="traceroute",Mandatory=$true)]
    [Switch]$Traceroute,
    [parameter(ParameterSetName="dnstest")]
    [Switch]$DNSTest,
    [parameter(ParameterSetName="ntptest")]
    [Switch]$NTPTest,
    [parameter(ParameterSetName="dnsconf")]
    [Switch]$DNSConfiguration,
    [parameter(ParameterSetName="dhcpconf")]
    [Switch]$DHCPConfiguration,
    [parameter(ParameterSetName="traceroute",Mandatory=$true)]
    [String]$Target,
    [parameter(ParameterSetName="traceroute",Mandatory=$false)]
    [String]$Port,
    [parameter(ParameterSetName="dnstest",Mandatory=$true)]
    [String]$FQDN,
    [parameter(Mandatory=$false)]
    [Switch]$WaitForOutput = $true,
    [Parameter(
      ValueFromPipelineByPropertyName = $true
    )]
    [String]$id
  )

  process {
    if ($B1Host -and $id) {
      Write-Host "Error. -B1Host and -id are mutually exclusive. Please select only one parameter" -ForegroundColor Red
      break
    } elseif (!$B1Host -and !$id) {
      Write-Host "Error. You must specify either -B1Host or -id" -ForegroundColor Red
      break
    }
  
    if ($id) {
      $OPH = Get-B1Host -id $id
    } else {
      $OPH = Get-B1Host -Name $B1Host -Strict
    }
  
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
      $Result = Query-CSP -Method POST -Uri "$(Get-B1CSPUrl)/atlas-onprem-diagnostic-service/v1/task" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
      if ($Result) {
        if ($WaitForOutput) {
          while ((Get-B1DiagnosticTask -id $Result.id).status -eq "InProgress") {
            Write-Host "Waiting for task to complete on $($OPH.display_name).." -ForegroundColor Yellow
            Wait-Event -Timeout 5
          }
          if ($DNSConfiguration) {
            $Job = Get-B1DiagnosticTask -id $Result.id -Download
          } elseif ($DHCPConfiguration) {
            $Job = Get-B1DiagnosticTask -id $Result.id -Download | Select-Object -ExpandProperty Dhcp4 -ErrorAction SilentlyContinue
          } else {
            $Job = Get-B1DiagnosticTask -id $Result.id
          }
          if ($Job) {
            return $Job
          } else {
            Write-Host "Job failed on $($OPH.display_name)." -ForegroundColor Red
          }
        } else {
          return $Result
        }
      }
    }
  }
}