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

    .PARAMETER Object
        The BloxOneDDI Host Object(s) to run the diagnostic task on. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Start-B1DiagnosticTask -DNSTest -FQDN "google.com"

    .EXAMPLE
        PS> Start-B1DiagnosticTask -DHCPConfiguration

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Tasks
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'Medium'
    )]
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
      [Parameter(ValueFromPipeline = $true)]
      [System.Object]$Object,
      [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "infra/host") {
                $Object = Get-B1Host -id $($Object.id) -Detailed
                if (-not $Object) {
                  Write-Error "Error. Unsupported pipeline object. This function only supports 'infra/host' objects as input"
                  return $null
                }
                $HostID = $Object.id
            } else {
              $HostID = $SplitID[2]
            }
        } else {
            $Object = Get-B1Host -Name $B1Host -Strict -Detailed
            if (!($Object)) {
                Write-Error "Unable to find BloxOne Host: $($B1Host)"
                return $null
            }
            $HostID = $Object.id
        }

        if ($Traceroute) {
            $splat = @{
                "ophid" = $Object.ophid
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
                "ophid" = $Object.ophid
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
                "ophid" = $Object.ophid
                "cmd" = @{
                    "name" = "ntp_test"
                }
            }
        }


        if ($DNSConfiguration) {
            $splat = @{
                "ophid" = $Object.ophid
                "cmd" = @{
                    "name" = "dns_conf"
                }
            }
        }

        if ($DHCPConfiguration) {
            $splat = @{
                "ophid" = $Object.ophid
                "cmd" = @{
                    "name" = "dhcp_conf"
                }
            }
        }

        $JSON = $splat | ConvertTo-Json
        if($PSCmdlet.ShouldProcess("Start BloxOne Diagnostic Task: $($Object.display_name)","Start BloxOne Diagnostic Task on: $($Object.display_name)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/atlas-onprem-diagnostic-service/v1/task" -Data $JSON | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
            if ($Result) {
                if ($WaitForOutput) {
                while ((Get-B1DiagnosticTask -id $Result.id).status -eq "InProgress") {
                    Write-Host "Waiting for task to complete on $($Object.display_name).." -ForegroundColor Yellow
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
                    Write-Host "Job failed on $($Object.display_name)." -ForegroundColor Red
                }
                } else {
                return $Result
                }
            }
        }
    }
}