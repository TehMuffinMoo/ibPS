function Deploy-B1Appliance {
    <#
    .SYNOPSIS
        Deploys a BloxOneDDI Virtual Appliance to VMware

    .DESCRIPTION
        This function is used to deploy a BloxOneDDI Virtual Appliance to a VMware host or cluster

    .PARAMETER Name
        The name of the virtual machine

    .PARAMETER IP
        The IP Address for the primary network interface of the virtual machine

    .PARAMETER Netmask
        The Netmask for the primary network interface of the virtual machine

    .PARAMETER Gateway
        The Gateway for the primary network interface of the virtual machine

    .PARAMETER DNSServers
        One or more DNS Servers for the virtual machine

    .PARAMETER NTPServers
        One or more NTP Servers for the virtual machine

    .PARAMETER DNSSuffix
        The DNS Suffix for the virtual machine

    .PARAMETER JoinToken
        The Join Token for registration of the BloxOneDDI Host into the Cloud Services Portal

    .PARAMETER OVAPath
        The path to the BloxOneDDI OVA

    .PARAMETER vCenter
        The Hostname, IP or FQDN of the vCenter you want to deploy to

    .PARAMETER Cluster
        The name of the cluster in vCenter

    .PARAMETER Datastore
        The name of the cluster in Datastore

    .PARAMETER PortGroupType
        The type of port group used for the virtual networks

    .PARAMETER Creds
        The credentials used for connecting to vCenter.

    .PARAMETER SkipCloudChecks
        Using this parameter will mean the deployment will not wait for the BloxOneDDI Host to become registered/available within the Cloud Services Portal

    .PARAMETER SkipPingChecks
        Using this parameter will skip ping checks during deployment, for cases where the deployment machine and host are separated by a device which blocks ICMP.
        NOTE: This will also skip checking of IP Addresses which are already in use.
    
    .PARAMETER SkipPowerOn
        Using this parameter will leave the VM in a powered off state once deployed

    .Example
        Deploy-B1Appliance -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.100.10" -Netmask "255.255.255.0" -Gateway "10.10.100.1" -DNSServers "10.30.10.10,10.30.10.10" -NTPServers "time.mydomain.corp" -DNSSuffix "prod.mydomain.corp" -JoinToken "JoinTokenGoesHere" -OVAPath .\BloxOne_OnPrem_VMWare_v3.1.0-4.3.10.ova -vCenter "vcenter.mydomain.corp" -Cluster "CLUSTER-001" -Datastore "DATASTORE-001" -PortGroup "PORTGROUP" -PortGroupType "VDS"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        VMware
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [System.Object]$IP,
      [Parameter(Mandatory=$true)]
      [System.Object]$Netmask,
      [Parameter(Mandatory=$true)]
      [System.Object]$Gateway,
      [Parameter(Mandatory=$true)]
      [System.Object]$DNSServers,
      [Parameter(Mandatory=$true)]
      [System.Object]$NTPServers,
      [Parameter(Mandatory=$true)]
      [System.Object]$DNSSuffix,
      [Parameter(Mandatory=$true)]
      [System.Object]$JoinToken,
      [Parameter(Mandatory=$true)]
      [System.Object]$OVAPath,
      [Parameter(Mandatory=$true)]
      [System.Object]$vCenter,
      [Parameter(Mandatory=$false)]
      [System.Object]$Cluster,
      [Parameter(Mandatory=$true)]
      [System.Object]$Datastore,
      [Parameter(Mandatory=$true)]
      [System.Object]$PortGroup,
      [Parameter(Mandatory=$true)]
      [ValidateSet("vDS","Standard")]
      [String]$PortGroupType,
      [Parameter(Mandatory=$true)]
      $Creds,
      [Switch]$SkipCloudChecks,
      [Switch]$SkipPingChecks,
      [Switch]$SkipPowerOn
    )
	
	Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

    if (Connect-VIServer -Server $vCenter -Credential $Creds) {
        Write-Host "Connected to vCenter $vCenter successfully." -ForegroundColor Green
    } else {
        Write-Host "Failed to establish session with vCenter $vCenter." -ForegroundColor Red
        break
    }

    $VMCluster = Get-Cluster $Cluster -ErrorAction SilentlyContinue
	$VMHost = $VMCluster | Get-VMHost -State "Connected" | Select-Object -First 1
    if (!($VMCluster)) {
        Write-Host "Error. Failed to get VM Cluster, please check details and try again." -ForegroundColor Red
        break
    }
    if (!(Get-Datastore $Datastore -ErrorAction SilentlyContinue)) {
        Write-Host "Error. Failed to get VM Datastore, please check details and try again." -ForegroundColor Red
        break
    }
    switch ($PortGroupType) {
        "vDS" {
			$NetworkMapping = Get-vDSwitch -VMHost $VMHost | Get-VDPortGroup $PortGroup
            if (!($NetworkMapping)) {
                Write-Host "Error. Failed to get vDS Port Group, please check details and try again." -ForegroundColor Red
                break
            } else {
				$NetworkMapping = Get-vDSwitch -VMHost $VMHost | Get-VDPortGroup $PortGroup
			}
        }
        "Standard" {
			$NetworkMapping = Get-VirtualSwitch -VMHost $VMHost | Get-VirtualPortGroup -Name $PortGroup
            if (!($NetworkMapping)) {
                Write-Host "Error. Failed to get Virtual Port Group, please check details and try again." -ForegroundColor Red
                break
            } else {

			}
        }
        "Default" {
            Write-Host "Invalid Port Group Type specified. Must be either `"vDS`" or `"Standard`"" -ForegroundColor Red
            break
        }
    }
    if (!(Test-Path $OVAPath)) {
        Write-Host "Error. OVA $OVAPath not found." -ForegroundColor Red
        break
    } else {
        $OVFConfig = Get-OvfConfiguration -Ovf $OVAPath
    }

    if (Get-VM -Name $Name -ErrorAction SilentlyContinue) {
        Write-Host "VM Already exists. Skipping.." -ForegroundColor Yellow
    } else {
        if ($OVFConfig) {
            Write-Host "Generating OVFConfig file for BloxOne Appliance: $Name .." -ForegroundColor Cyan

            $OVFConfig.Common.address.Value = $IP
            $OVFConfig.Common.gateway.Value = $Gateway
            $OVFConfig.Common.netmask.Value = $Netmask
            $OVFConfig.Common.nameserver.Value = $DNSServers
            $OVFConfig.Common.ntp_servers.Value = $NTPServers
            $OVFConfig.Common.jointoken.Value = $JoinToken
            $OVFConfig.Common.search.Value = $DNSSuffix
            $OVFConfig.Common.v4_mode.Value = "static"
            $OVFConfig.NetworkMapping.lan.Value = $NetworkMapping
        
        } else {
            Write-Host "Error. Unable to retrieve OVF Configuration from $OVAPath." -ForegroundColor Red
        }

        if (!($SkipPingChecks)) {
          if ((Test-NetConnection $IP -WarningAction SilentlyContinue -ErrorAction SilentlyContinue).PingSucceeded) {
            Write-Host "Error. IP Address already in use." -ForegroundColor Red
            break
          }
        }

        Write-Host "Deploying BloxOne Appliance: $Name .." -ForegroundColor Cyan
        $Result = Import-VApp -OvfConfiguration $OVFConfig -Source $OVAPath -Name $Name -VMHost $VMHost -Datastore (Get-Datastore $Datastore) -ErrorAction SilentlyContinue
    
        if ($Result) {
            Write-Host "Successfully deployed BloxOne Appliance: $Name" -ForegroundColor Green
            if ($Debug) {$Result | ft -AutoSize}
            if (!($SkipPowerOn)) {
              Write-Host "Powering on $Name.." -ForegroundColor Cyan
              $VMStart = Start-VM -VM $Result
              $VMStartCount = 0
              while ((Get-VM -Name $Name).PowerState -ne "PoweredOn") {
                Write-Host "Waiting for VM to start. Elapsed Time: $VMStartCount`s" -ForegroundColor Gray
                Wait-Event -Timeout 10
                $VMStartCount = $VMStartCount + 10
                if ($VMStartCount -gt 120) {
                    Write-Host "Error. VM Failed to start." -ForegroundColor Red
                    break
                }
              }
            }

            if (!($SkipPingChecks)) {
              while (!(Test-NetConnection $IP -WarningAction SilentlyContinue -ErrorAction SilentlyContinue).PingSucceeded) {
                $PingStartCount = $PingStartCount + 10
                Write-Host "Waiting for network to become reachable. Elapsed Time: $PingStartCount`s" -ForegroundColor Gray
                Wait-Event -Timeout 10
                if ($PingStartCount -gt 120) {
                    Write-Host "Error. Network Failed to become reachable on $IP." -ForegroundColor Red
                    break
                }
              }
            }

            if (!($SkipCloudChecks)) {
              while (!(Get-B1Host -IP $IP)) {
                $CSPStartCount = $CSPStartCount + 10
                Write-Host "Waiting for BloxOne Appliance to become registered within BloxOne CSP. Elapsed Time: $CSPStartCount`s" -ForegroundColor Gray
                Wait-Event -Timeout 10
                if ($CSPStartCount -gt 120) {
                    Write-Host "Error. VM failed to register with the BloxOne CSP. Please check VM Console for details." -ForegroundColor Red
                    break
                }
              }
            }

            Write-Host "BloxOne Appliance is now available, check the CSP portal for registration of the device" -ForegroundColor Gray

            if (!($SkipCloudChecks)) {
                Get-B1Host -IP $IP | ft display_name,ip_address,host_version -AutoSize
            }
            
        } else {
            Write-Host "Failed to deploy BloxOne Appliance." -ForegroundColor Red
            break
        }

        Disconnect-VIServer * -Confirm:$false -Force
        Write-Host "Disconnected from vCenters." -ForegroundColor Gray
    }
}