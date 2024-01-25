function Deploy-B1Appliance {
    <#
    .SYNOPSIS
        Deploys a BloxOneDDI Virtual Appliance to VMware

    .DESCRIPTION
        This function is used to deploy a BloxOneDDI Virtual Appliance to a VMware host or cluster

    .PARAMETER Type
        The type of deployment to perform (VMware / Hyper-V)

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
          Only used when -Type is VMware

    .PARAMETER vCenter
        The Hostname, IP or FQDN of the vCenter you want to deploy to
          Only used when -Type is VMware

    .PARAMETER Cluster
        The name of the cluster in vCenter
          Only used when -Type is VMware

    .PARAMETER Datastore
        The name of the cluster in Datastore
          Only used when -Type is VMware

    .PARAMETER PortGroupType
        The type of port group used for the virtual networks
          Only used when -Type is VMware

    .PARAMETER Creds
        The credentials used for connecting to vCenter.
          Only used when -Type is VMware

    .PARAMETER SkipCloudChecks
        Using this parameter will mean the deployment will not wait for the BloxOneDDI Host to become registered/available within the Cloud Services Portal

    .PARAMETER SkipPingChecks
        Using this parameter will skip ping checks during deployment, for cases where the deployment machine and host are separated by a device which blocks ICMP.
        NOTE: This will also skip checking of IP Addresses which are already in use.
    
    .PARAMETER SkipPowerOn
        Using this parameter will leave the VM in a powered off state once deployed

    .Example
        Deploy-B1Appliance -Type "VMware" -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.100.10" -Netmask "255.255.255.0" -Gateway "10.10.100.1" -DNSServers "10.30.10.10,10.30.10.10" -NTPServers "time.mydomain.corp" -DNSSuffix "prod.mydomain.corp" -JoinToken "JoinTokenGoesHere" -OVAPath .\BloxOne_OnPrem_VMWare_v3.1.0-4.3.10.ova -vCenter "vcenter.mydomain.corp" -Cluster "CLUSTER-001" -Datastore "DATASTORE-001" -PortGroup "PORTGROUP" -PortGroupType "VDS"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        VMware
    #>
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("VMware","Hyper-V")]
      [String]$Type,
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [System.Object]$IP,
      [Parameter(Mandatory=$true)]
      [System.Object]$Netmask,
      [Parameter(Mandatory=$true)]
      [System.Object]$Gateway,
      [Parameter(Mandatory=$true)]
      [System.Object]$DNSServers = "52.119.40.100",
      [Parameter(Mandatory=$true)]
      [System.Object]$NTPServers,
      [Parameter(Mandatory=$true)]
      [System.Object]$DNSSuffix,
      [Parameter(Mandatory=$true)]
      [System.Object]$JoinToken,
      [Switch]$SkipCloudChecks,
      [Switch]$SkipPingChecks,
      [Switch]$SkipPowerOn
    )

    DynamicParam {
        switch($Type) {
          "VMware" {
             $OVAPathAttribute = New-Object System.Management.Automation.ParameterAttribute
             $OVAPathAttribute.Position = 1
             $OVAPathAttribute.Mandatory = $true
             $OVAPathAttribute.HelpMessageBaseName = "OVAPath"
             $OVAPathAttribute.HelpMessage = "The OVAPath parameter is used to define the full path of the .ova image to deploy."

             $vCenterAttribute = New-Object System.Management.Automation.ParameterAttribute
             $vCenterAttribute.Position = 2
             $vCenterAttribute.Mandatory = $true
             $vCenterAttribute.HelpMessageBaseName = "vCenter"
             $vCenterAttribute.HelpMessage = "The vCenter parameter is used to define the vCenter where the VM will be created."
             
             $ClusterAttribute = New-Object System.Management.Automation.ParameterAttribute
             $ClusterAttribute.Position = 3
             $ClusterAttribute.Mandatory = $false
             $ClusterAttribute.HelpMessageBaseName = "Cluster"
             $ClusterAttribute.HelpMessage = "The Cluster parameter is used to define the Cluster the VM should be created in."

             $DatastoreAttribute = New-Object System.Management.Automation.ParameterAttribute
             $DatastoreAttribute.Position = 4
             $DatastoreAttribute.Mandatory = $true
             $DatastoreAttribute.HelpMessageBaseName = "Datastore"
             $DatastoreAttribute.HelpMessage = "The Datastore parameter is used to define the name of the datastore to create the VM in."

             $PortGroupAttribute = New-Object System.Management.Automation.ParameterAttribute
             $PortGroupAttribute.Position = 5
             $PortGroupAttribute.Mandatory = $true
             $PortGroupAttribute.HelpMessageBaseName = "PortGroup"
             $PortGroupAttribute.HelpMessage = "The PortGroup parameter is used to define the name of the port group to attach to the VM Network Interface(s)."

             $PortGroupTypeAttribute = New-Object System.Management.Automation.ParameterAttribute
             $PortGroupTypeAttribute.Position = 6
             $PortGroupTypeAttribute.Mandatory = $true
             $PortGroupTypeAttribute.HelpMessageBaseName = "PortGroupType"
             $PortGroupTypeAttribute.HelpMessage = "The PortGroupType parameter is used to define the type of port group to use. (vDS / Standard)"
             $PortGroupTypeValidation = [System.Management.Automation.ValidateSetAttribute]::new("vDS","Standard")

             $CredsAttribute = New-Object System.Management.Automation.ParameterAttribute
             $CredsAttribute.Position = 7
             $CredsAttribute.Mandatory = $true
             $CredsAttribute.HelpMessageBaseName = "Creds"
             $CredsAttribute.HelpMessage = "The Creds parameter is used to define the vCenter Credentials."

             $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

             foreach ($ParamItem in ($OVAPathAttribute,$vCenterAttribute,$ClusterAttribute,$DatastoreAttribute,$PortGroupAttribute,$PortGroupTypeAttribute,$CredsAttribute)) {
                $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $AttributeCollection.Add($ParamItem)
                $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [String], $AttributeCollection)
                $paramDictionary.Add($($ParamItem.HelpMessageBaseName), $DefinedParam)
             }
             return $paramDictionary
           }
           "Hyper-V" {
                $VHDPathAttribute = New-Object System.Management.Automation.ParameterAttribute
                $VHDPathAttribute.Position = 1
                $VHDPathAttribute.Mandatory = $true
                $VHDPathAttribute.HelpMessageBaseName = "VHDPath"
                $VHDPathAttribute.HelpMessage = "The VHDPath parameter is used to define the full path of the .vhd/.vhdx image to deploy."

                $HyperVServerAttribute = New-Object System.Management.Automation.ParameterAttribute
                $HyperVServerAttribute.Position = 2
                $HyperVServerAttribute.Mandatory = $true
                $HyperVServerAttribute.HelpMessageBaseName = "HyperVServer"
                $HyperVServerAttribute.HelpMessage = "The HyperVServer parameter is used to define the FQDN of the Hyper-V Server to deploy the VM on."

                $HyperVGenerationAttribute = New-Object System.Management.Automation.ParameterAttribute
                $HyperVGenerationAttribute.Position = 3
                $HyperVGenerationAttribute.Mandatory = $true
                $HyperVGenerationAttribute.HelpMessageBaseName = "HyperVGeneration"
                $HyperVGenerationAttribute.HelpMessage = "The HyperVGeneration parameter is used to define the Hyper-V generation of the VM to deploy (1 or 2)."

                $VMPathAttribute = New-Object System.Management.Automation.ParameterAttribute
                $VMPathAttribute.Position = 4
                $VMPathAttribute.Mandatory = $true
                $VMPathAttribute.HelpMessageBaseName = "VMPath"
                $VMPathAttribute.HelpMessage = "The VMPath parameter is used to define the base path for the VM to be created in. A folder will be created within this path with the VM name."

                $VirtualNetworkAttribute = New-Object System.Management.Automation.ParameterAttribute
                $VirtualNetworkAttribute.Position = 5
                $VirtualNetworkAttribute.Mandatory = $true
                $VirtualNetworkAttribute.HelpMessageBaseName = "VirtualNetwork"
                $VirtualNetworkAttribute.HelpMessage = "The VirtualNetwork parameter is used to define the Virtual Network to connect the VM to."

                $VirtualNetworkVLANAttribute = New-Object System.Management.Automation.ParameterAttribute
                $VirtualNetworkVLANAttribute.Position = 6
                $VirtualNetworkVLANAttribute.Mandatory = $false
                $VirtualNetworkVLANAttribute.HelpMessageBaseName = "VirtualNetworkVLAN"
                $VirtualNetworkVLANAttribute.HelpMessage = "The VirtualNetworkVLAN parameter is used to define the name of the Virtual Network VLAN to connect the VM to (if applicable)."

                $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

                foreach ($ParamItem in ($VHDPathAttribute,$HyperVServerAttribute,$HyperVGenerationAttribute,$VMPathAttribute,$VirtualNetworkAttribute,$VirtualNetworkVLANAttribute)) {
                    $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                    $AttributeCollection.Add($ParamItem)
                    $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [String], $AttributeCollection)
                    $paramDictionary.Add($($ParamItem.HelpMessageBaseName), $DefinedParam)
                 }
                 return $paramDictionary
           }
       }
   }

    process {
        if (!($SkipPingChecks)) {
            if ((Test-NetConnection $IP -WarningAction SilentlyContinue -ErrorAction SilentlyContinue).PingSucceeded) {
                Write-Error "Error. IP Address already in use."
                break
            }
        }

        switch($Type) {
            "VMware" {
                Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

                if (Connect-VIServer -Server $vCenter -Credential $Creds) {
                    Write-Host "Connected to vCenter $vCenter successfully." -ForegroundColor Green
                } else {
                    Write-Error "Failed to establish session with vCenter $vCenter."
                    break
                }
            
                $VMCluster = Get-Cluster $Cluster -ErrorAction SilentlyContinue
                $VMHost = $VMCluster | Get-VMHost -State "Connected" | Select-Object -First 1
                if (!($VMCluster)) {
                    Write-Error "Error. Failed to get VM Cluster, please check details and try again."
                    break
                }
                if (!(Get-Datastore $Datastore -ErrorAction SilentlyContinue)) {
                    Write-Error "Error. Failed to get VM Datastore, please check details and try again."
                    break
                }
                switch($PortGroupType) {
                    "vDS" {
                        $NetworkMapping = Get-vDSwitch -VMHost $VMHost | Get-VDPortGroup $PortGroup
                        if (!($NetworkMapping)) {
                            Write-Error "Error. Failed to get vDS Port Group, please check details and try again."
                            break
                        } else {
                            $NetworkMapping = Get-vDSwitch -VMHost $VMHost | Get-VDPortGroup $PortGroup
                        }
                    }
                    "Standard" {
                        $NetworkMapping = Get-VirtualSwitch -VMHost $VMHost | Get-VirtualPortGroup -Name $PortGroup
                        if (!($NetworkMapping)) {
                            Write-Error "Error. Failed to get Virtual Port Group, please check details and try again."
                            break
                        } else {
            
                        }
                    }
                    "Default" {
                        Write-Error "Invalid Port Group Type specified. Must be either `"vDS`" or `"Standard`""
                        break
                    }
                }
                if (!(Test-Path $OVAPath)) {
                    Write-Error "Error. OVA $OVAPath not found."
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
                        Write-Error "Error. Unable to retrieve OVF Configuration from $OVAPath."
                    }
            
                    Write-Host "Deploying BloxOne Appliance: $Name .." -ForegroundColor Cyan
                    $VM = Import-VApp -OvfConfiguration $OVFConfig -Source $OVAPath -Name $Name -VMHost $VMHost -Datastore (Get-Datastore $Datastore) -ErrorAction SilentlyContinue
                
                    if ($VM) {
                        Write-Host "Successfully deployed BloxOne Appliance: $Name" -ForegroundColor Green
                        if ($Debug) {$VM | Format-Table -AutoSize}
                        if (!($SkipPowerOn)) {
                        Write-Host "Powering on $Name.." -ForegroundColor Cyan
                        $VMStart = Start-VM -VM $VM
                        $VMStartCount = 0
                            while ((Get-VM -Name $Name).PowerState -ne "PoweredOn") {
                                Write-Host "Waiting for VM to start. Elapsed Time: $VMStartCount`s" -ForegroundColor Gray
                                Wait-Event -Timeout 10
                                $VMStartCount = $VMStartCount + 10
                                if ($VMStartCount -gt 120) {
                                    Write-Error "Error. VM Failed to start."
                                    break
                                }
                            }
                        }
                    }
                    Disconnect-VIServer * -Confirm:$false -Force
                    Write-Host "Disconnected from vCenters." -ForegroundColor Gray
                }
            }
            "Hyper-V" {
                $VMMetadata = New-B1Metadata -IP $IP -Netmask $Netmask -Gateway $Gateway -DNSServers $DNSServers -JoinToken $JoinToken

                if (Test-Path cloud-init) {
                    Remove-Item -Path "cloud-init" -Recurse
                }
                New-Item -Type Directory -Name "cloud-init" | Out-Null
                New-Item -Path "cloud-init/user-data" -Value $VMMetadata.userdata | Out-Null
                New-Item -Path "cloud-init/network-config" -Value $VMMetadata.network | Out-Null
                New-Item -Path "cloud-init/metadata" -Value $VMMetadata.metadata | Out-Null

                Write-Host "Creating configuration metadata ISO" -ForegroundColor Cyan
                New-ISOFile -Source "cloud-init/" -Destination "cloud-init/metadata.iso" -VolumeName "CIDATA"

                Get-ChildItem -Path "cloud-init/" | Where-Object {$_.Name -ne "metadata.iso"} | Remove-Item

                if (!(Test-Path "cloud-init/metadata.iso")) {
                    Write-Error "Error. Failed to create customization ISO."
                } else {
                    Write-Host "Successfully created customization ISO." -ForegroundColor Cyan
                }
    
                $VM = New-VM -Name $VMName  -NoVHD  -Generation 2 -MemoryStartupBytes "16GB"  -SwitchName $VirtualNetwork -ComputerName $HyperVServer -Path $VMPath

                if ($VM) {
                    Set-VM -Name $VMName  -ProcessorCount 8 -ComputerName $HyperVServer -CheckpointType Disabled
                    if ($VirtualNetworkVLAN) {
                        Set-VMNetworkAdapterVlan -VMName $VMName -ComputerName $HyperVServer -VlanId $VirtualNetworkVLAN -Access
                    }
                    
                    $OsDiskInfo = Get-Item $VHDPath
                    $RemoteBasePath = $VMPath -replace "`:","$"
                    if (!(Test-Path "\\$($HyperVServer)\$($RemoteBasePath)\$($VMName)\Virtual Hard Disks")) {
                        New-Item "\\\$($HyperVServer)\$($RemoteBasePath)\Virtual Hard Disks" -ItemType Directory
                    }
                    switch ($HyperVGeneration) {
                        1 {
                            $VHDExtension = "vhd"
                        }
                        2 {
                            $VHDExtension = "vhdx"
                            Set-VMFirmware -VMName $VMName -ComputerName $HyperVServer -EnableSecureBoot On MicrosoftUEFICertificateAuthority -BootOrder (Get-VMHardDiskDrive -ComputerName $HyperVServer -VMName $VMName),(Get-VMDvdDrive -ComputerName $HyperVServer -VMName $VMName)
                        }
                    }
                    Copy-Item -Path $OsDiskInfo -Destination "\\$($HyperVServer)\$($RemoteBasePath)\Virtual Hard Disks\$($VMName).$($VHDExtension)"
                    Copy-Item -Path $MetaData -Destination "\\$($HyperVServer)\$($RemoteBasePath)\Virtual Hard Disks\$($VMName)-metadata.iso"
                    
                    if (!(Get-VMHardDiskDrive -VMName $VMName -ComputerName $HyperVServer)) {
                        Add-VMHardDiskDrive -VMName $VMName -ComputerName $HyperVServer -Path "$($VMPath)\$($VMName)\Virtual Hard Disks\$($VMName).$($VHDExtension)"
                    }
                    
                    if (!(Get-VMDvdDrive -VMName $VMName -ComputerName $HyperVServer)) {
                        Add-VMDvdDrive -VMName $VMName -ComputerName $HyperVServer  -Path "$($VMPath)\$($VMName)\Virtual Hard Disks\$($VMName)-metadata.iso"
                    } else {
                        Set-VMDvdDrive -VMName $VMName -ComputerName $HyperVServer  -Path "$($VMPath)\$($VMName)\Virtual Hard Disks\$($VMName)-metadata.iso"
                    }
                    
                    if (Get-VHD -Path "$($VMPath)\$($VMName)\Virtual Hard Disks\$($VMName).$($VHDExtension)" -ComputerName $HyperVServer) {
                        Resize-VHD -Path "$($VMPath)\$($VMName)\Virtual Hard Disks\$($VMName).$($VHDExtension)" -ComputerName $HyperVServer -SizeBytes 60GB
                    }
                    
                    if (!($SkipPowerOn)) {
                        Write-Host "Powering on $Name.." -ForegroundColor Cyan
                        $VMStart = Start-VM -Name $VMName -ComputerName $HyperVServer 
                        $VMStartCount = 0
                        while ((Get-VM -Name $Name -ComputerName $HyperVServer).State -ne "Running") {
                            Write-Host "Waiting for VM to start. Elapsed Time: $VMStartCount`s" -ForegroundColor Gray
                            Wait-Event -Timeout 10
                            $VMStartCount = $VMStartCount + 10
                            if ($VMStartCount -gt 120) {
                                Write-Error "Error. VM Failed to start."
                                break
                            }
                        }
                    }
                  
                }
            }
        }

        if ($VM) {
            if (!($SkipPowerOn)) {
                if (!($SkipPingChecks)) {
                    while (!(Test-NetConnection $IP -WarningAction SilentlyContinue -ErrorAction SilentlyContinue).PingSucceeded) {
                        $PingStartCount = $PingStartCount + 10
                        Write-Host "Waiting for network to become reachable. Elapsed Time: $PingStartCount`s" -ForegroundColor Gray
                        Wait-Event -Timeout 10
                        if ($PingStartCount -gt 120) {
                            Write-Error "Error. Network Failed to become reachable on $IP."
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
                            Write-Error "Error. VM failed to register with the BloxOne CSP. Please check VM Console for details."
                            break
                        }
                    }
                }

                Write-Host "BloxOne Appliance is now available, check the CSP portal for registration of the device" -ForegroundColor Gray

                if (!($SkipCloudChecks)) {
                    Get-B1Host -IP $IP | Format-Table display_name,ip_address,host_version -AutoSize
                }
            } else {
                Write-Host "BloxOne Appliance deployed successfully." -ForegroundColor Green
            }
        } else {
            Write-Error "Failed to deploy BloxOne Appliance."
            break
        }
    }
}