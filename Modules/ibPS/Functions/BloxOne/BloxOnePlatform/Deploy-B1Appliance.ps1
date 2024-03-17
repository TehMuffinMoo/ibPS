function Deploy-B1Appliance {
    <#
    .SYNOPSIS
        Deploys a BloxOneDDI Virtual Appliance to VMware or Hyper-V

    .DESCRIPTION
        This function is used to deploy a BloxOneDDI Virtual Appliance to a VMware host/cluster or Hyper-V

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
          -OVAPath and -DownloadLatestImage are mutually exclusive. -ImagesPath should be used for selecting the appropriate image cache location.

    .PARAMETER vCenter
        The Hostname, IP or FQDN of the vCenter you want to deploy to
          Only used when -Type is VMware

    .PARAMETER Cluster
        The name of the cluster in vCenter
          Only used when -Type is VMware

    .PARAMETER Datastore
        The name of the cluster in Datastore
          Only used when -Type is VMware

    .PARAMETER PortGroup
        The name of the port group to connect the VM's network adapters to
          Only used when -Type is VMware

    .PARAMETER PortGroupType
        The type of port group used for the virtual networks
          Only used when -Type is VMware

    .PARAMETER Creds
        The credentials used for connecting to vCenter.
          Only used when -Type is VMware

    .PARAMETER VHDPath
        The full path to the BloxOne VHD/VHDX file
          Only used when -Type is Hyper-V
          -VHDPath and -DownloadLatestImage are mutually exclusive. -ImagesPath should be used for selecting the appropriate image cache location.
          
    .PARAMETER HyperVServer
        The FQDN for the Hyper-V server where the BloxOne appliance will be deployed to
          Only used when -Type is Hyper-V

    .PARAMETER HyperVGeneration
        The generation of the Hyper-V VM to be created (1 or 2)
          Only used when -Type is Hyper-V

    .PARAMETER VMPath
        The VMPath parameter is used to define the base path for the VM to be created in. A folder will be created within this path with the VM name.
          Only used when -Type is Hyper-V

    .PARAMETER VirtualNetwork
        The VirtualNetwork parameter is used to define the name of the Virtual Network to connect the VM to.
          Only used when -Type is Hyper-V

    .PARAMETER VirtualNetworkVLAN
        The VirtualNetworkVLAN parameter is used to define the VLAN number to assign to the interface, if applicable.
          Only used when -Type is Hyper-V

    .PARAMETER CPU
        The CPU parameter is used to define the number of CPUs to assign to the VM. The default is 8.
          Only used when -Type is Hyper-V

    .PARAMETER Memory
        The Memory parameter is used to define the amount of memory to assign to the VM. The default is 16GB.
          Only used when -Type is Hyper-V

    .PARAMETER DownloadLatestImage
        Using this parameter will download the latest relevant image prior to deployment.

        -DownloadLatestImage, -OVAPath & -VHDPath are mutually exclusive.

        When -DownloadLatestImage is used in combination with -ImagesPath, the latest image will be downloaded to this location prior to deployment if it does not already exist. If used consistently, this will always deploy the latest image but only need to download it once; effectively caching.

    .PARAMETER ImagesPath
        Use this parameter to define the base path for images to be cached in when specifying the -DownloadLatestImage parameter.
        
        This cannot be used in conjunction with -OVAPath or -VHDPath

    .PARAMETER SkipCloudChecks
        Using this parameter will mean the deployment will not wait for the BloxOneDDI Host to become registered/available within the Cloud Services Portal

    .PARAMETER SkipPingChecks
        Using this parameter will skip ping checks during deployment, for cases where the deployment machine and host are separated by a device which blocks ICMP.

        NOTE: This will also skip checking of IP Addresses which are already in use.
    
    .PARAMETER SkipPowerOn
        Using this parameter will leave the VM in a powered off state once deployed

    .EXAMPLE
        PS> Deploy-B1Appliance -Type "VMware" `
                           -Name "bloxoneddihost1" `
                           -IP "10.10.100.10" `
                           -Netmask "255.255.255.0" `
                           -Gateway "10.10.100.1" `
                           -DNSServers "10.30.10.10,10.30.10.10" `
                           -NTPServers "time.mydomain.corp" `
                           -DNSSuffix "prod.mydomain.corp" `
                           -JoinToken "JoinTokenGoesHere" `
                           -ImagesPath .\Images `
                           -DownloadLatestImage `
                           -vCenter "vcenter.mydomain.corp" `
                           -Cluster "CLUSTER-001" `
                           -Datastore "DATASTORE-001" `
                           -PortGroup "PORTGROUP" `
                           -PortGroupType "VDS"
    
    .EXAMPLE
        PS> Deploy-B1Appliance -Type Hyper-V `
                           -Name "bloxoneddihost1" `
                           -IP 10.10.100.10 `
                           -Netmask 255.255.255.0 `
                           -Gateway 10.10.100.1 `
                           -DNSServers 10.10.100.1 `
                           -NTPServers ntp.ubuntu.com `
                           -DNSSuffix mydomain.corp `
                           -JoinToken "JoinTokenGoesHere" `
                           -VHDPath ".\BloxOne_OnPrem_VHDX_v3.8.1.vhdx" `
                           -HyperVServer "Host1.mycompany.corp" `
                           -HyperVGeneration 2 `
                           -VMPath "A:\VMs" `
                           -VirtualNetwork "Virtual Network 1" `
                           -VirtualNetworkVLAN 101

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        VMware

    .NOTES
        Credits: Ollie Sheridan - Assisted with development of the Hyper-V integration
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
      [Switch]$DownloadLatestImage,
      [String]$ImagesPath,
      [Switch]$SkipCloudChecks,
      [Switch]$SkipPingChecks,
      [Switch]$SkipPowerOn
    )

    DynamicParam {
        switch($Type) {
          "VMware" {
             $OVAPathAttribute = New-Object System.Management.Automation.ParameterAttribute
             $OVAPathAttribute.Position = 1
             $OVAPathAttribute.Mandatory = $false
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
                if ($($ParamItem.HelpMessageBaseName -eq "Creds")) {
                    $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [pscredential], $AttributeCollection)    
                } else {
                    $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [String], $AttributeCollection)
                }
                $paramDictionary.Add($($ParamItem.HelpMessageBaseName), $DefinedParam)
             }
             return $paramDictionary
           }
           "Hyper-V" {
                $VHDPathAttribute = New-Object System.Management.Automation.ParameterAttribute
                $VHDPathAttribute.Position = 1
                $VHDPathAttribute.Mandatory = $false
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

                $CPUAttribute = New-Object System.Management.Automation.ParameterAttribute
                $CPUAttribute.Position = 7
                $CPUAttribute.Mandatory = $false
                $CPUAttribute.HelpMessageBaseName = "CPU"
                $CPUAttribute.HelpMessage = "The CPU parameter is used to define the number of CPUs to assign to the VM. The default is 8."

                $MemoryAttribute = New-Object System.Management.Automation.ParameterAttribute
                $MemoryAttribute.Position = 8
                $MemoryAttribute.Mandatory = $false
                $MemoryAttribute.HelpMessageBaseName = "Memory"
                $MemoryAttribute.HelpMessage = "The Memory parameter is used to define the amount of memory to assign to the VM. The default is 16GB."

                $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

                foreach ($ParamItem in ($VHDPathAttribute,$HyperVServerAttribute,$HyperVGenerationAttribute,$VMPathAttribute,$VirtualNetworkAttribute,$VirtualNetworkVLANAttribute,$CPUAttribute,$MemoryAttribute)) {
                    $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                    $AttributeCollection.Add($ParamItem)
                    if ($($ParamItem.HelpMessageBaseName -eq "CPU" -or $($ParamItem.HelpMessageBaseName) -eq "Memory")) {
                        $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [int64], $AttributeCollection)    
                    } else {
                        $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [String], $AttributeCollection)
                    }
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

        if ($DownloadLatestImage) {
            Write-Host "-DownloadLatestImage is selected. The latest BloxOne image will be used." -ForegroundColor Cyan
            if ($PSBoundParameters['OVAPath'] -or $PSBoundParameters['VHDPath']) {
                Write-Error "-DownloadLatestImage cannot be used in conjunction with -OVAPath or -VHDPath"
            }
            if ($ImagesPath) {
                Write-Host "-ImagesPath is selected. Collecting existing cached images.." -ForegroundColor Cyan
                if (!(Test-Path $ImagesPath)) {
                    Write-Host "-ImagesPath: $($ImagesPath) does not exist. Attempting to create it.." -ForegroundColor Yellow
                    if ($ImagesDir = New-Item -Type Directory $ImagesPath) {
                        Write-Host "Successfully created $($ImagesPath)" -ForegroundColor Cyan
                        $CurrentImages = Get-ChildItem $ImagesPath
                    } else {
                        Write-Error "Error. Failed to create -ImagesPath: $($ImagesPath)"
                    }
                } else {
                    $CurrentImages = Get-ChildItem $ImagesPath
                }
            } else {
                Write-Host "-ImagesPath not set. Downloaded images will not be cached." -ForegroundColor Yellow
            }
            $Images = Get-B1Object -Product 'Bloxone Cloud' -App BootstrapApp -Endpoint /images
            switch ($Type) {
                "VMware" {
                    $Image = $Images | Where-Object {$_.desc -like "*OVA"}
                }
                "Hyper-V" {
                    switch($PSBoundParameters['HyperVGeneration']) {
                        1 {
                            $Image = $Images | Where-Object {$_.desc -like "*Azure/HyperV"}
                        }
                        2 {
                            $Image = $Images | Where-Object {$_.desc -like "*Hyper-V Gen 2"}
                        }
                    }
                }
            }
            if ($Image) {
                $($Image.link) -match "^.*\/(.*)$" | Out-Null
                if ($Matches) {
                    $ImageFileName = $Matches[1]
                    if ($ImagesPath) {
                        if (!(Test-Path "$($ImagesPath)\$($ImageFileName)")) {
                            Write-Host "Downloading latest image: $($ImageFileName).." -ForegroundColor Cyan
                            Invoke-WebRequest -Method GET -Uri $($Image.link) -OutFile "$($ImagesPath)\$($ImageFileName)"
                        } else {
                            Write-Host "Latest image already downloaded: $($ImageFileName)" -ForegroundColor Cyan
                        }
                        $ImageFile = "$($ImagesPath)\$($ImageFileName)"
                    } else {
                        if (!(Test-Path "$($ImageFileName)")) {
                            Write-Host "Downloading latest image: $($ImageFileName).." -ForegroundColor Cyan
                            Invoke-WebRequest -Method GET -Uri $($Image.link) -OutFile "$($ImageFileName)"
                        } else {
                            Write-Host "Latest image already downloaded: $($ImageFileName)" -ForegroundColor Cyan
                        }
                        $ImageFile = "$($ImageFileName)"
                    }
                } else {
                    Write-Error "Error. Failed to identify image name."
                }
            } else {
                Write-Error "Error. Failed to find image."
            }
        }

        switch($Type) {
            "VMware" {
                if (!($DownloadLatestImage)) {
                    if (!($PSBoundParameters['OVAPath'])) {
                        Write-Error "-OVAPath must be specified if -DownloadLatestImage is not used."
                    } else {
                        $ImageFile = $PSBoundParameters['OVAPath']
                    }
                }
                Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

                if (Connect-VIServer -Server $($PSBoundParameters['vCenter']) -Credential $($PSBoundParameters['Creds'])) {
                    Write-Host "Connected to vCenter $($PSBoundParameters['vCenter']) successfully." -ForegroundColor Green
                } else {
                    Write-Error "Failed to establish session with vCenter $($PSBoundParameters['vCenter'])."
                    break
                }
            
                $VMCluster = Get-Cluster $($PSBoundParameters['Cluster']) -ErrorAction SilentlyContinue
                $VMHost = $VMCluster | Get-VMHost -State "Connected" | Select-Object -First 1
                if (!($VMCluster)) {
                    Write-Error "Error. Failed to get VM Cluster, please check details and try again."
                    break
                }
                if (!($Datastore = Get-Datastore $($PSBoundParameters['Datastore']) -ErrorAction SilentlyContinue)) {
                    Write-Error "Error. Failed to get VM Datastore, please check details and try again."
                    break
                }
                switch($($PSBoundParameters['PortGroupType'])) {
                    "vDS" {
                        $NetworkMapping = Get-vDSwitch -VMHost $VMHost | Get-VDPortGroup $($PSBoundParameters['PortGroup'])
                        if (!($NetworkMapping)) {
                            Write-Error "Error. Failed to get vDS Port Group, please check details and try again."
                            break
                        } else {
                            $NetworkMapping = Get-vDSwitch -VMHost $VMHost | Get-VDPortGroup $($PSBoundParameters['PortGroup'])
                        }
                    }
                    "Standard" {
                        $NetworkMapping = Get-VirtualSwitch -VMHost $VMHost | Get-VirtualPortGroup -Name $($PSBoundParameters['PortGroup'])
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
                if (!(Test-Path $($ImageFile))) {
                    Write-Error "Error. OVA $($ImageFile) not found."
                    break
                } else {
                    $OVFConfig = Get-OvfConfiguration -Ovf $($ImageFile)
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
                        Write-Error "Error. Unable to retrieve OVF Configuration from $($ImageFile)."
                    }
            
                    Write-Host "Deploying BloxOne Appliance: $Name .." -ForegroundColor Cyan
                    $VM = Import-VApp -OvfConfiguration $OVFConfig -Source $($ImageFile) -Name $Name -VMHost $VMHost -Datastore $Datastore -Force
                
                    if ($VM) {
                        Write-Host "Successfully deployed BloxOne Appliance: $Name" -ForegroundColor Green
                        if ($ENV:IBPSDebug -eq "Enabled") {$VM | Format-Table -AutoSize}
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
                if (!($DownloadLatestImage)) {
                    if (!($PSBoundParameters['VHDPath'])) {
                        Write-Error "-VHDPath must be specified if -DownloadLatestImage is not used."
                    } else {
                        $ImageFile = $PSBoundParameters['VHDPath']
                    }
                }
                Write-Host "Generating customization metadata" -ForegroundColor Cyan
                $VMMetadata = New-B1Metadata -IP $IP -Netmask $Netmask -Gateway $Gateway -DNSServers $DNSServers -JoinToken $JoinToken -DNSSuffix $DNSSuffix
                if ($VMMetadata) {
                    Write-Host "Customization metadata generated successfully." -ForegroundColor Cyan
                } else {
                    Write-Error "Failed to generate customization metadata"
                }

                if (Test-Path 'work-dir') {
                    Remove-Item -Path "work-dir" -Recurse
                }
                New-Item -Type Directory -Name "work-dir" | Out-Null
                New-Item -Type Directory -Name "work-dir/cloud-init" | Out-Null
                New-Item -Path "work-dir/cloud-init/user-data" -Value $VMMetadata.userdata | Out-Null
                New-Item -Path "work-dir/cloud-init/network-config" -Value $VMMetadata.network | Out-Null
                New-Item -Path "work-dir/cloud-init/meta-data" -Value $VMMetadata.metadata | Out-Null

                Write-Host "Creating configuration metadata ISO" -ForegroundColor Cyan
                $MetadataISO = New-ISOFile -Source "work-dir/cloud-init/" -Destination "work-dir/metadata.iso" -VolumeName "CIDATA"

                if (!(Test-Path "work-dir/metadata.iso")) {
                    Write-Error "Error. Failed to create customization ISO."
                } else {
                    Write-Host "Successfully created customization ISO." -ForegroundColor Cyan
                }
    
                if (!($PSBoundParameters['Memory'])) {
                    [int64]$Memory = 16GB
                } else {
                    $Memory = $PSBoundParameters['Memory']
                }

                if (!($PSBoundParameters['CPU'])) {
                    [int64]$CPU = 8
                } else {
                    $CPU = $PSBoundParameters['CPU']
                }
                
                Write-Host "Deploying BloxOne Appliance: $Name .." -ForegroundColor Cyan
                $VM = New-VM -Name $Name  -NoVHD  -Generation $($PSBoundParameters['HyperVGeneration']) -MemoryStartupBytes $Memory -SwitchName $($PSBoundParameters['VirtualNetwork']) -ComputerName $($PSBoundParameters['HyperVServer']) -Path $($PSBoundParameters['VMPath'])

                if ($VM) {
                    Write-Host "Configuring VM Resources.." -ForegroundColor Cyan
                    Set-VM -Name $Name  -ProcessorCount $CPU -ComputerName $($PSBoundParameters['HyperVServer']) -CheckpointType Disabled
                    if ($($PSBoundParameters['VirtualNetworkVLAN'])) {
                        Write-Host "Configuring Virtual Network VLAN.." -ForegroundColor Cyan
                        Set-VMNetworkAdapterVlan -VMName $Name -ComputerName $($PSBoundParameters['HyperVServer']) -VlanId $($PSBoundParameters['VirtualNetworkVLAN']) -Access
                    }
                    
                    $OsDiskInfo = Get-Item $($ImageFile)
                    $RemoteBasePath = $($PSBoundParameters['VMPath']) -replace "`:","$"
                    if (!(Test-Path "\\$($PSBoundParameters['HyperVServer'])\$($RemoteBasePath)\$($Name)\Virtual Hard Disks")) {
                        Write-Host "Preparing VM folders.." -ForegroundColor Cyan
                        New-Item "\\$($PSBoundParameters['HyperVServer'])\$($RemoteBasePath)\$($Name)\Virtual Hard Disks" -ItemType Directory | Out-Null
                    }
                    switch ($($PSBoundParameters['HyperVGeneration'])) {
                        1 {
                            $VHDExtension = "vhd"
                        }
                        2 {
                            $VHDExtension = "vhdx"
                        }
                    }
                    if ([System.IO.Path]::GetExtension($($ImageFile)) -ne ".$($VHDExtension)") {
                        switch($PSBoundParameters['HyperVGeneration']) {
                            1 {
                                Write-Error "Error. You must use a .vhd file format for Generation 1 Hyper-V VMs."
                            }
                            2 {
                                Write-Error "Error. You must use a .vhdx file format for Generation 2 Hyper-V VMs."
                            }
                        }
                    }
                    Write-Host "Copying $($VHDExtension).." -ForegroundColor Cyan
                    Copy-Item -Path $OsDiskInfo -Destination "\\$($PSBoundParameters['HyperVServer'])\$($RemoteBasePath)\$($Name)\\Virtual Hard Disks\$($Name).$($VHDExtension)" | Out-Null
                    Write-Host "Copying Metadata ISO.." -ForegroundColor Cyan
                    Copy-Item -Path "work-dir/metadata.iso" -Destination "\\$($PSBoundParameters['HyperVServer'])\$($RemoteBasePath)\$($Name)\Virtual Hard Disks\$($Name)-metadata.iso" | Out-Null
                    
                    if (!(Get-VMHardDiskDrive -VMName $Name -ComputerName $($PSBoundParameters['HyperVServer']))) {
                        Write-Host "Attaching $($VHDExtension).." -ForegroundColor Cyan
                        Add-VMHardDiskDrive -VMName $Name -ComputerName $($PSBoundParameters['HyperVServer']) -Path "$($PSBoundParameters['VMPath'])\$($Name)\Virtual Hard Disks\$($Name).$($VHDExtension)"
                    }
                    
                    Write-Host "Attaching Metadata ISO.." -ForegroundColor Cyan
                    if (!(Get-VMDvdDrive -VMName $Name -ComputerName $($PSBoundParameters['HyperVServer']))) {
                        Add-VMDvdDrive -VMName $Name -ComputerName $($PSBoundParameters['HyperVServer'])  -Path "$($PSBoundParameters['VMPath'])\$($Name)\Virtual Hard Disks\$($Name)-metadata.iso"
                    } else {
                        Set-VMDvdDrive -VMName $Name -ComputerName $($PSBoundParameters['HyperVServer'])  -Path "$($PSBoundParameters['VMPath'])\$($Name)\Virtual Hard Disks\$($Name)-metadata.iso"
                    }
                    
                    Write-Host "Resizing $($VHDExtension).." -ForegroundColor Cyan
                    if (Get-VHD -Path "$($PSBoundParameters['VMPath'])\$($Name)\Virtual Hard Disks\$($Name).$($VHDExtension)" -ComputerName $($PSBoundParameters['HyperVServer'])) {
                        Resize-VHD -Path "$($PSBoundParameters['VMPath'])\$($Name)\Virtual Hard Disks\$($Name).$($VHDExtension)" -ComputerName $($PSBoundParameters['HyperVServer']) -SizeBytes 60GB
                    }

                    if ($PSBoundParameters['HyperVGeneration'] -eq 2) {
                        Write-Host "Configuring Secure Boot.." -ForegroundColor Cyan
                        Set-VMFirmware -VMName $Name -ComputerName $($PSBoundParameters['HyperVServer']) -EnableSecureBoot On -SecureBootTemplate MicrosoftUEFICertificateAuthority -BootOrder (Get-VMHardDiskDrive -ComputerName $($PSBoundParameters['HyperVServer']) -VMName $Name),(Get-VMDvdDrive -ComputerName $($PSBoundParameters['HyperVServer']) -VMName $Name)
                    }
                    
                    if (!($SkipPowerOn)) {
                        Write-Host "Powering on $Name.." -ForegroundColor Cyan
                        $VMStart = Start-VM -Name $Name -ComputerName $($PSBoundParameters['HyperVServer'])
                        $VMStartCount = 0
                        while ((Get-VM -Name $Name -ComputerName $($PSBoundParameters['HyperVServer'])).State -ne "Running") {
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
                            $Failed = $true
                            break
                        }
                    }
                }

                if ($Type -eq "Hyper-V") {
                    Set-VMDvdDrive -VMName $Name -ComputerName $($PSBoundParameters['HyperVServer']) -Path $null ## Cleanup metadata ISO
                }

                if (!$Failed) {
                    Write-Host "BloxOne Appliance is now available, check the CSP portal for registration of the device" -ForegroundColor Gray

                    if (!($SkipCloudChecks)) {
                        Get-B1Host -IP $IP | Format-Table display_name,ip_address,host_version -AutoSize
                    }
                    Write-Host "BloxOne Appliance deployed successfully." -ForegroundColor Green
                } else {
                    Write-Error "Failed to deploy BloxOne Appliance."
                }
            } else {
                Write-Host "BloxOne Appliance deployed successfully." -ForegroundColor Green
            }
        } else {
            Write-Error "Failed to deploy BloxOne Appliance."
            break
        }

        if (Test-Path 'work-dir') {
            Remove-Item -Path "work-dir" -Recurse
        } ## Cleanup work directory
    }
}