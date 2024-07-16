function Deploy-B1Appliance {
    <#
    .SYNOPSIS
        Deploys a BloxOneDDI Virtual Appliance to VMware, Hyper-V or Azure.

    .DESCRIPTION
        This function is used to deploy a BloxOneDDI Virtual Appliance to a VMware host/cluster, Hyper-V or Azure.

    .PARAMETER Type
        The type of deployment to perform (VMware / Hyper-V)

    .PARAMETER Name
        The name of the virtual machine

    .PARAMETER IP
        The IP Address for the primary network interface of the virtual machine
          Only used when -Type is VMware or Hyper-V

    .PARAMETER Netmask
        The Netmask for the primary network interface of the virtual machine
          Only used when -Type is VMware or Hyper-V

    .PARAMETER Gateway
        The Gateway for the primary network interface of the virtual machine
          Only used when -Type is VMware or Hyper-V

    .PARAMETER DNSServers
        One or more DNS Servers for the virtual machine
          Only used when -Type is VMware or Hyper-V

    .PARAMETER NTPServers
        One or more NTP Servers for the virtual machine
          Only used when -Type is VMware or Hyper-V

    .PARAMETER DNSSuffix
        The DNS Suffix for the virtual machine
          Only used when -Type is VMware or Hyper-V

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

    .PARAMETER VMHost
        The name of the host in vCenter to deploy the VM to
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

    .PARAMETER AzTenant
        The AzTenant parameter is used to define the Azure Tenant ID to connect to during deployment.
          Only used when -Type is Azure

    .PARAMETER AzSubscription
        The AzSubscription parameter is used to define the Azure Subscription ID to connect to during deployment.
          Only used when -Type is Azure

    .PARAMETER AzLocation
        The AzLocation parameter is used to define the Azure Location to deploy the new VM to.
          Only used when -Type is Azure

    .PARAMETER AzResourceGroup
        The AzResourceGroup parameter is used to define the Azure Resource Group to deploy the new VM in.
          Only used when -Type is Azure

    .PARAMETER AzVirtualNetwork
        The AzVirtualNetwork parameter is used to define the Azure Virtual Network to deploy the new VM in.
          Only used when -Type is Azure

    .PARAMETER AzSubnet
        The AzSubnet parameter is used to define the Subnet in the selected Azure Virtual Network to deploy the new VM in.
          Only used when -Type is Azure

    .PARAMETER AzOffer
        The AzOffer parameter is used to define the Azure Marketplace Image Offer to deploy the new VM with.
          Only used when -Type is Azure

    .PARAMETER AzSku
        The AzSku parameter is used to define the Azure Marketplace Image SKU to deploy the new VM with.
          Only used when -Type is Azure

    .PARAMETER AzSize
        The AzSize parameter is used to define the Azure VM Size to use when deploying the new VM.
          Only used when -Type is Azure

    .PARAMETER AzAcceptTerms
        The AzAcceptTerms parameter is used to accept the marketplace terms required when deploying a BloxOne DDI Host.
          Only used when -Type is Azure

    .PARAMETER AzBootDiagnostics
        The AzBootDiagnostics parameter is used to enable Boot Diagnostics for the VM during build. This features requires a storage account be specified using -AzStorageAccount.
          Only used when -Type is Azure

    .PARAMETER AzStorageAccount
        The AzStorageAccount is used to define the name of the storage account to use for Boot Diagnostics. This must be in the same Azure Resource Group and is only available when -AzBootDiagnostics is specified.
          Only used when -Type is Azure and when -AzBootDiagnostics is specified.

    .PARAMETER DownloadLatestImage
        Using this parameter will download the latest relevant image prior to deployment.

        -DownloadLatestImage, -OVAPath & -VHDPath are mutually exclusive.

        When -DownloadLatestImage is used in combination with -ImagesPath, the latest image will be downloaded to this location prior to deployment if it does not already exist. If used consistently, this will always deploy the latest image but only need to download it once; effectively caching.

    .PARAMETER ImagesPath
        Use this parameter to define the base path for images to be cached in when specifying the -DownloadLatestImage parameter.

        This cannot be used in conjunction with -OVAPath or -VHDPath

    .PARAMETER CloudCheckTimeout
        The duration of time allowed for the B1 Host to register with the Cloud Services Portal before timing out. This defaults to 300s (5 Minutes)

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
                            -DNSServers "10.30.10.10","10.30.20.10" `
                            -NTPServers "time.mydomain.corp","time2.mydomain.corp" `
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

    .EXAMPLE
        PS> Deploy-B1Appliance -Type "Azure" `
                           -Name "bloxoneddihost1" `
                           -JoinToken "JoinTokenGoesHere" `
                           -AzTenant 'g54gdeg5-gdf4-4434-dff4-7fdeswgf54ff' `
                           -AzSubscription '1234d123-abc1-4f33-r43f-5gredgrgdsdv4' `
                           -AzLocation 'UK South' `
                           -AzOffer 'infoblox-bloxone-34' `
                           -AzSku 'infoblox-bloxone' `
                           -AzResourceGroup 'rg-infoblox' `
                           -AzVirtualNetwork 'infoblox_vnet' `
                           -AzSubnet 'infoblox_snet' `
                           -AzSize 'Standard_F8s_v2' `
                           -AzBootDiagnostics `
                           -AzStorageAccount 'ibbootdiags' `
                           -AzAcceptTerms

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        VMware

    .FUNCTIONALITY
        Hyper-V

    .FUNCTIONALITY
        Azure

    .NOTES
        Credits: Ollie Sheridan - Assisted with development of the Hyper-V integration
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification='Required to generate random dummy Azure SSH Credentials.')]
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("VMware","Hyper-V","Azure")]
      [String]$Type,
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$JoinToken,
      [Parameter(Mandatory=$false)]
      [Int]$CloudCheckTimeout = 300,
      [Parameter(Mandatory=$false)]
      [Switch]$SkipCloudChecks,
      [Parameter(Mandatory=$false)]
      [Switch]$SkipPingChecks
    )

    DynamicParam {
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        ## Define Common Parameters
        if ($Type -in @('VMware','Hyper-V')) {
            $IPAttribute = New-Object System.Management.Automation.ParameterAttribute
            $IPAttribute.Position = 1
            $IPAttribute.Mandatory = $true
            $IPAttribute.HelpMessageBaseName = "IP"
            $IPAttribute.HelpMessage = "The IP Address for the primary network interface of the virtual machine being deployed. Only used when -Type is VMware or Hyper-V."

            $NetmaskAttribute = New-Object System.Management.Automation.ParameterAttribute
            $NetmaskAttribute.Position = 2
            $NetmaskAttribute.Mandatory = $true
            $NetmaskAttribute.HelpMessageBaseName = "Netmask"
            $NetmaskAttribute.HelpMessage = "The Subnet Mask for the primary network interface of the virtual machine being deployed. Only used when -Type is VMware or Hyper-V."

            $GatewayAttribute = New-Object System.Management.Automation.ParameterAttribute
            $GatewayAttribute.Position = 3
            $GatewayAttribute.Mandatory = $true
            $GatewayAttribute.HelpMessageBaseName = "Gateway"
            $GatewayAttribute.HelpMessage = "The Gateway IP Address for the primary network interface of the virtual machine being deployed. Only used when -Type is VMware or Hyper-V."

            $DNSServersAttribute = New-Object System.Management.Automation.ParameterAttribute
            $DNSServersAttribute.Position = 4
            $DNSServersAttribute.Mandatory = $true
            $DNSServersAttribute.HelpMessageBaseName = "DNSServers"
            $DNSServersAttribute.HelpMessage = "A list of DNS Servers for the primary network interface of the virtual machine being deployed. Only used when -Type is VMware or Hyper-V."

            $NTPServersAttribute = New-Object System.Management.Automation.ParameterAttribute
            $NTPServersAttribute.Position = 5
            $NTPServersAttribute.Mandatory = $true
            $NTPServersAttribute.HelpMessageBaseName = "NTPServers"
            $NTPServersAttribute.HelpMessage = "A list of NTP Servers for the virtual machine being deployed. Only used when -Type is VMware or Hyper-V."

            $DNSSuffixAttribute = New-Object System.Management.Automation.ParameterAttribute
            $DNSSuffixAttribute.Position = 6
            $DNSSuffixAttribute.Mandatory = $true
            $DNSSuffixAttribute.HelpMessageBaseName = "DNSSuffix"
            $DNSSuffixAttribute.HelpMessage = "The DNS Suffix for the primary network interface of the virtual machine being deployed. Only used when -Type is VMware or Hyper-V."

            $DownloadLatestImageAttribute = New-Object System.Management.Automation.ParameterAttribute
            $DownloadLatestImageAttribute.Position = 7
            $DownloadLatestImageAttribute.Mandatory = $false
            $DownloadLatestImageAttribute.HelpMessageBaseName = "DownloadLatestImage"
            $DownloadLatestImageAttribute.HelpMessage = "Using -DownloadLatestImage will download the latest BloxOne image prior to deployment. Only used when -Type is VMware or Hyper-V."

            $ImagesPathAttribute = New-Object System.Management.Automation.ParameterAttribute
            $ImagesPathAttribute.Position = 8
            $ImagesPathAttribute.Mandatory = $false
            $ImagesPathAttribute.HelpMessageBaseName = "ImagesPath"
            $ImagesPathAttribute.HelpMessage = "Specify a path for cached BloxOne images to be stored when combined with -DownloadLatestImage. Only used when -Type is VMware or Hyper-V."

            $SkipPowerOnAttribute = New-Object System.Management.Automation.ParameterAttribute
            $SkipPowerOnAttribute.Position = 9
            $SkipPowerOnAttribute.Mandatory = $false
            $SkipPowerOnAttribute.HelpMessageBaseName = "SkipPowerOn"
            $SkipPowerOnAttribute.HelpMessage = "Using this parameter will leave the VM in a powered off state once deployed. Only used when -Type is VMware or Hyper-V."

            foreach ($ParamItem in ($IPAttribute,$NetmaskAttribute,$GatewayAttribute,$DNSServersAttribute,$NTPServersAttribute,$DNSSuffixAttribute,$DownloadLatestImageAttribute,$ImagesPathAttribute,$SkipPowerOnAttribute)) {
                $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $AttributeCollection.Add($ParamItem)
                Switch($ParamItem.HelpMessageBaseName) {
                    {$_ -in @('DownloadLatestImage','SkipPowerOn')} {
                        $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [Switch], $AttributeCollection)
                    }
                    {$_ -in @('IP','Gateway')} {
                        $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [IPAddress], $AttributeCollection)
                    }
                    'NTPServers' {
                        $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [String[]], $AttributeCollection)
                    }
                    'DNSServers' {
                        $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [IPAddress[]], $AttributeCollection)
                    }
                    Default {
                        $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [String], $AttributeCollection)
                    }
                }
                $paramDictionary.Add($($ParamItem.HelpMessageBaseName), $DefinedParam)
             }
        }
        ## Define Deployment Specific Parameters
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

             $VMHostAttribute = New-Object System.Management.Automation.ParameterAttribute
             $VMHostAttribute.Position = 4
             $VMHostAttribute.Mandatory = $false
             $VMHostAttribute.HelpMessageBaseName = "VMHost"
             $VMHostAttribute.HelpMessage = "The VMHost parameter is used to define the Host the VM should be created on."

             $DatastoreAttribute = New-Object System.Management.Automation.ParameterAttribute
             $DatastoreAttribute.Position = 5
             $DatastoreAttribute.Mandatory = $true
             $DatastoreAttribute.HelpMessageBaseName = "Datastore"
             $DatastoreAttribute.HelpMessage = "The Datastore parameter is used to define the name of the datastore to create the VM in."

             $PortGroupAttribute = New-Object System.Management.Automation.ParameterAttribute
             $PortGroupAttribute.Position = 6
             $PortGroupAttribute.Mandatory = $true
             $PortGroupAttribute.HelpMessageBaseName = "PortGroup"
             $PortGroupAttribute.HelpMessage = "The PortGroup parameter is used to define the name of the port group to attach to the VM Network Interface(s)."

             $PortGroupTypeAttribute = New-Object System.Management.Automation.ParameterAttribute
             $PortGroupTypeAttribute.Position = 7
             $PortGroupTypeAttribute.Mandatory = $true
             $PortGroupTypeAttribute.HelpMessageBaseName = "PortGroupType"
             $PortGroupTypeAttribute.HelpMessage = "The PortGroupType parameter is used to define the type of port group to use. (vDS / Standard)"
             $PortGroupTypeValidation = [System.Management.Automation.ValidateSetAttribute]::new("vDS","Standard")

             $CredsAttribute = New-Object System.Management.Automation.ParameterAttribute
             $CredsAttribute.Position = 8
             $CredsAttribute.Mandatory = $true
             $CredsAttribute.HelpMessageBaseName = "Creds"
             $CredsAttribute.HelpMessage = "The Creds parameter is used to define the vCenter Credentials."

             foreach ($ParamItem in ($OVAPathAttribute,$vCenterAttribute,$ClusterAttribute,$VMHostAttribute,$DatastoreAttribute,$PortGroupAttribute,$PortGroupTypeAttribute,$CredsAttribute)) {
                $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $AttributeCollection.Add($ParamItem)
                if ($($ParamItem.HelpMessageBaseName -eq "Creds")) {
                    $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [pscredential], $AttributeCollection)
                } else {
                    $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [String], $AttributeCollection)
                }
                $paramDictionary.Add($($ParamItem.HelpMessageBaseName), $DefinedParam)
             }
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
           }
           "Azure" {
                $AzTenantAttribute = New-Object System.Management.Automation.ParameterAttribute
                $AzTenantAttribute.Position = 1
                $AzTenantAttribute.Mandatory = $true
                $AzTenantAttribute.HelpMessageBaseName = "AzTenant"
                $AzTenantAttribute.HelpMessage = "The AzTenant parameter is used to define the Azure Tenant ID to connect to during deployment."

                $AzSubscriptionAttribute = New-Object System.Management.Automation.ParameterAttribute
                $AzSubscriptionAttribute.Position = 2
                $AzSubscriptionAttribute.Mandatory = $true
                $AzSubscriptionAttribute.HelpMessageBaseName = "AzSubscription"
                $AzSubscriptionAttribute.HelpMessage = "The AzSubscription parameter is used to define the Azure Subscription ID to connect to during deployment."

                $AzLocationAttribute = New-Object System.Management.Automation.ParameterAttribute
                $AzLocationAttribute.Position = 3
                $AzLocationAttribute.Mandatory = $true
                $AzLocationAttribute.HelpMessageBaseName = "AzLocation"
                $AzLocationAttribute.HelpMessage = "The AzLocation parameter is used to define the Azure Location to deploy the new VM to."

                $AzResourceGroupAttribute = New-Object System.Management.Automation.ParameterAttribute
                $AzResourceGroupAttribute.Position = 4
                $AzResourceGroupAttribute.Mandatory = $true
                $AzResourceGroupAttribute.HelpMessageBaseName = "AzResourceGroup"
                $AzResourceGroupAttribute.HelpMessage = "The AzResourceGroup parameter is used to define the Azure Resource Group to deploy the new VM in."

                $AzVirtualNetworkAttribute = New-Object System.Management.Automation.ParameterAttribute
                $AzVirtualNetworkAttribute.Position = 5
                $AzVirtualNetworkAttribute.Mandatory = $true
                $AzVirtualNetworkAttribute.HelpMessageBaseName = "AzVirtualNetwork"
                $AzVirtualNetworkAttribute.HelpMessage = "The AzVirtualNetwork parameter is used to define the Azure Virtual Network to deploy the new VM in."

                $AzSubnetAttribute = New-Object System.Management.Automation.ParameterAttribute
                $AzSubnetAttribute.Position = 5
                $AzSubnetAttribute.Mandatory = $true
                $AzSubnetAttribute.HelpMessageBaseName = "AzSubnet"
                $AzSubnetAttribute.HelpMessage = "The AzSubnet parameter is used to define the Subnet in the selected Azure Virtual Network to deploy the new VM in."

                $AzOfferAttribute = New-Object System.Management.Automation.ParameterAttribute
                $AzOfferAttribute.Position = 6
                $AzOfferAttribute.Mandatory = $true
                $AzOfferAttribute.HelpMessageBaseName = "AzOffer"
                $AzOfferAttribute.HelpMessage = "The AzOffer parameter is used to define the Azure Marketplace Image Offer to deploy the new VM with."

                $AzSkuAttribute = New-Object System.Management.Automation.ParameterAttribute
                $AzSkuAttribute.Position = 7
                $AzSkuAttribute.Mandatory = $true
                $AzSkuAttribute.HelpMessageBaseName = "AzSku"
                $AzSkuAttribute.HelpMessage = "The AzSku parameter is used to define the Azure Marketplace Image SKU to deploy the new VM with."

                $AzSizeAttribute = New-Object System.Management.Automation.ParameterAttribute
                $AzSizeAttribute.Position = 8
                $AzSizeAttribute.Mandatory = $true
                $AzSizeAttribute.HelpMessageBaseName = "AzSize"
                $AzSizeAttribute.HelpMessage = "The AzSize parameter is used to define the Azure VM Size to use when deploying the new VM."

                $AzAcceptTermsAttribute = New-Object System.Management.Automation.ParameterAttribute
                $AzAcceptTermsAttribute.Position = 9
                $AzAcceptTermsAttribute.Mandatory = $false
                $AzAcceptTermsAttribute.HelpMessageBaseName = "AzAcceptTerms"
                $AzAcceptTermsAttribute.HelpMessage = "The AzAcceptTerms parameter is used to accept the marketplace terms required when deploying a BloxOne DDI Host."

                $AzBootDiagnosticsAttribute = New-Object System.Management.Automation.ParameterAttribute
                $AzBootDiagnosticsAttribute.Position = 10
                $AzBootDiagnosticsAttribute.Mandatory = $false
                $AzBootDiagnosticsAttribute.HelpMessageBaseName = "AzBootDiagnostics"
                $AzBootDiagnosticsAttribute.HelpMessage = "The AzBootDiagnostics parameter is used to enable Boot Diagnostics for the VM during build. This features requires a storage account be specified using -AzStorageAccount."

                $AzStorageAccountAttribute = New-Object System.Management.Automation.ParameterAttribute
                $AzStorageAccountAttribute.Position = 11
                $AzStorageAccountAttribute.Mandatory = $false
                $AzStorageAccountAttribute.HelpMessageBaseName = "AzStorageAccount"
                $AzStorageAccountAttribute.HelpMessage = "The AzStorageAccount is used to define the name of the storage account to use for Boot Diagnostics. This is only used when -AzBootDiagnostics is specified."

                foreach ($ParamItem in ($AzTenantAttribute,$AzSubscriptionAttribute,$AzLocationAttribute,$AzOfferAttribute,$AzSkuAttribute,$AzResourceGroupAttribute,$AzVirtualNetworkAttribute,$AzSubnetAttribute,$AzSizeAttribute,$AzAcceptTermsAttribute,$AzBootDiagnosticsAttribute,$AzStorageAccountAttribute)) {
                    $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                    $AttributeCollection.Add($ParamItem)
                    Switch($ParamItem.HelpMessageBaseName) {
                        {$_ -in @('AzAcceptTerms','AzBootDiagnostics')} {
                            $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [switch], $AttributeCollection)
                        }
                        Default {
                            $DefinedParam = New-Object System.Management.Automation.RuntimeDefinedParameter($($ParamItem.HelpMessageBaseName), [String], $AttributeCollection)
                        }
                    }
                    $paramDictionary.Add($($ParamItem.HelpMessageBaseName), $DefinedParam)
                }
            }
        }
        return $paramDictionary
   }

    process {

        $CurrentOS = Detect-OS

        switch ($Type) {
            "VMware" {
                if (!(Get-Module -ListAvailable -Name VMware.PowerCLI -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)) {
                    Write-Error "You must have the VMware PowerCLI Module installed to deploy to vCenter / ESXi."
                    return $null
                }
            }
            "Hyper-V" {
                if (($CurrentOS) -eq "Windows") {
                    if ((Get-WindowsFeature -Name "Hyper-V-PowerShell").'InstallState' -ne "Installed") {
                        Write-Error "You must have the Hyper-V PowerShell Module installed to deploy to Hyper-V."
                        return $null
                    }
                } else {
                    Write-Error "You must be running ibPS on Windows to deploy to Hyper-V"
                    return $null
                }
            }
            "Azure" {
                $MissingPackages = @()
                #,'Az.Resources'
                @('Az.Accounts','Az.Compute','Az.Network','Az.MarketplaceOrdering') | ForEach-Object {
                    if (!(Get-Module -ListAvailable -Name $_)) {
                        $MissingPackages += $_
                    }
                }
                if ($MissingPackages) {
                    Write-Error 'You must have the following PowerShell Modules installed to deploy to Azure.'
                    $($MissingPackages -split ',')
                    Write-Error "You can install them using this command: Install-Module -Name $($MissingPackages -join ',')"
                    return $null
                }
                $SkipPingChecks = $true
            }
        }

        if (!($SkipPingChecks)) {
            if ($CurrentOS -eq "Windows") {
                if ((Test-NetConnection $($PSBoundParameters.IP.IPAddressToString) -WarningAction SilentlyContinue -ErrorAction SilentlyContinue).PingSucceeded) {
                    Write-Error "Error. IP Address already in use."
                    return $null
                }
            } else {
                if ((Test-Connection -IPv4 $($PSBoundParameters.IP.IPAddressToString) -Count 1 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue).Status -eq "Success") {
                    Write-Error "Error. IP Address already in use."
                    return $null
                }
            }
        }

        if ($Type -in @('VMware','Hyper-V')) {
            if ($PSBoundParameters.DownloadLatestImage) {
                Write-Host "-DownloadLatestImage is selected. The latest BloxOne image will be used." -ForegroundColor Cyan
                if ($PSBoundParameters['OVAPath'] -or $PSBoundParameters['VHDPath']) {
                    Write-Error "-DownloadLatestImage cannot be used in conjunction with -OVAPath or -VHDPath"
                    return $null
                }
                if ($PSBoundParameters.ImagesPath) {
                    Write-Host "-ImagesPath is selected. Collecting existing cached images.." -ForegroundColor Cyan
                    if (!(Test-Path $PSBoundParameters.ImagesPath)) {
                        Write-Host "-ImagesPath: $($PSBoundParameters.ImagesPath) does not exist. Attempting to create it.." -ForegroundColor Yellow
                        if ($ImagesDir = New-Item -Type Directory $PSBoundParameters.ImagesPath) {
                            Write-Host "Successfully created $($PSBoundParameters.ImagesPath)" -ForegroundColor Cyan
                            $CurrentImages = Get-ChildItem $PSBoundParameters.ImagesPath
                        } else {
                            Write-Error "Error. Failed to create -ImagesPath: $($PSBoundParameters.ImagesPath)"
                            return $null
                        }
                    } else {
                        $CurrentImages = Get-ChildItem $PSBoundParameters.ImagesPath
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
                        if ($PSBoundParameters.ImagesPath) {
                            $ImageFilePath = Join-Path $($PSBoundParameters.ImagesPath) $($ImageFileName)
                            if (!(Test-Path "$($ImageFilePath)")) {
                                Write-Host "Downloading latest image: $($ImageFileName).." -ForegroundColor Cyan
                                Invoke-WebRequest -Method GET -Uri $($Image.link) -OutFile "$($ImageFilePath)"
                            } else {
                                Write-Host "Latest image already downloaded: $($ImageFileName)" -ForegroundColor Cyan
                            }
                            $ImageFile = "$($ImageFilePath)"
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
                        return $null
                    }
                } else {
                    Write-Error "Error. Failed to find image."
                    return $null
                }
            }
        }

        switch($Type) {
            "VMware" {
                if (!($PSBoundParameters.DownloadLatestImage)) {
                    if (!($PSBoundParameters['OVAPath'])) {
                        Write-Error "-OVAPath must be specified if -DownloadLatestImage is not used."
                    } else {
                        $ImageFile = $PSBoundParameters['OVAPath']
                    }
                }
                Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false

                if ($VMwareConnect = Connect-VIServer -Server $($PSBoundParameters['vCenter']) -Credential $($PSBoundParameters['Creds'])) {
                    Write-Host "Connected to vCenter $($PSBoundParameters['vCenter']) successfully." -ForegroundColor Green
                } else {
                    Write-Error "Failed to establish session with vCenter $($PSBoundParameters['vCenter'])."
                    return $null
                }

                if ($PSBoundParameters['Cluster']) {
                    $VMCluster = Get-Cluster $($PSBoundParameters['Cluster']) -ErrorAction SilentlyContinue
                    if (!($VMCluster)) {
                        Write-Error "Error. Failed to get VM Cluster, please check details and try again."
                        return $null
                    } else {
                        if ($PSBoundParameters['VMHost']) {
                            $VMHostObj = $VMCluster | Get-VMHost -Name $PSBoundParameters['VMHost'] -State "Connected"
                            if (!$VMHostObj) {
                                Write-Error "Error. Failed to find Host: $($PSBoundParameters['VMHost']) on Cluster: $($Cluster)"
                                return $null
                            }
                        } else {
                            $VMHostObj = $VMCluster | Get-VMHost -State "Connected" | Select-Object -First 1
                        }
                    }
                } elseif ($PSBoundParameters['VMHost']) {
                    $VMHostObj = Get-VMHost -Name $PSBoundParameters['VMHost'] -State "Connected"
                    if (!$VMHostObj) {
                        Write-Error "Error. Failed to find Host: $($PSBoundParameters['VMHost']) on Cluster: $($Cluster)"
                        return $null
                    }
                } else {
                    Write-Error 'Error. You must specify either -Cluster or -VMHost.'
                    return $null
                }

                if (!($Datastore = Get-Datastore $($PSBoundParameters['Datastore']) -ErrorAction SilentlyContinue)) {
                    Write-Error "Error. Failed to get VM Datastore, please check details and try again."
                    return $null
                }
                switch($($PSBoundParameters['PortGroupType'])) {
                    "vDS" {
                        $NetworkMapping = Get-vDSwitch -VMHost $VMHostObj | Get-VDPortGroup $($PSBoundParameters['PortGroup'])
                        if (!($NetworkMapping)) {
                            Write-Error "Error. Failed to get vDS Port Group, please check details and try again."
                            return $null
                        } else {
                            $NetworkMapping = Get-vDSwitch -VMHost $VMHostObj | Get-VDPortGroup $($PSBoundParameters['PortGroup'])
                        }
                    }
                    "Standard" {
                        $NetworkMapping = Get-VirtualSwitch -VMHost $VMHostObj | Get-VirtualPortGroup -Name $($PSBoundParameters['PortGroup'])
                        if (!($NetworkMapping)) {
                            Write-Error "Error. Failed to get Virtual Port Group, please check details and try again."
                            return $null
                        } else {

                        }
                    }
                    "Default" {
                        Write-Error "Invalid Port Group Type specified. Must be either `"vDS`" or `"Standard`""
                        return $null
                    }
                }
                if (!(Test-Path $($ImageFile))) {
                    Write-Error "Error. OVA $($ImageFile) not found."
                    return $null
                } else {
                    $OVFConfig = Get-OvfConfiguration -Ovf $($ImageFile)
                }

                if (Get-VM -Name $Name -ErrorAction SilentlyContinue) {
                    Write-Host "VM Already exists. Skipping.." -ForegroundColor Yellow
                } else {
                    if ($OVFConfig) {
                        Write-Host "Generating OVFConfig file for BloxOne Appliance: $Name .." -ForegroundColor Cyan

                        $OVFConfig.Common.address.Value = $PSBoundParameters.IP.IPAddressToString
                        $OVFConfig.Common.gateway.Value = $PSBoundParameters.Gateway.IPAddressToString
                        $OVFConfig.Common.netmask.Value = $PSBoundParameters.Netmask
                        $OVFConfig.Common.nameserver.Value = $PSBoundParameters.DNSServers.IPAddressToString -join ','
                        $OVFConfig.Common.ntp_servers.Value = $PSBoundParameters.NTPServers -join ','
                        $OVFConfig.Common.jointoken.Value = $JoinToken
                        $OVFConfig.Common.search.Value = $PSBoundParameters.DNSSuffix
                        $OVFConfig.Common.v4_mode.Value = "static"
                        $OVFConfig.NetworkMapping.lan.Value = $NetworkMapping

                    } else {
                        Write-Error "Error. Unable to retrieve OVF Configuration from $($ImageFile)."
                        return $null
                    }

                    Write-Host "Deploying BloxOne Appliance: $Name .." -ForegroundColor Cyan
                    $VM = Import-VApp -OvfConfiguration $OVFConfig -Source $($ImageFile) -Name $Name -VMHost $VMHostObj -Datastore $Datastore -Force

                    if ($VM) {
                        Write-Host "Successfully deployed BloxOne Appliance: $Name" -ForegroundColor Green
                        if ($ENV:IBPSDebug -eq "Enabled") {$VM | Format-Table -AutoSize}
                        if (!($PSBoundParameters.SkipPowerOn)) {
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
                if (!($PSBoundParameters.DownloadLatestImage)) {
                    if (!($PSBoundParameters['VHDPath'])) {
                        Write-Error "-VHDPath must be specified if -DownloadLatestImage is not used."
                        return $null
                    } else {
                        $ImageFile = $PSBoundParameters['VHDPath']
                    }
                }
                Write-Host "Generating customization metadata" -ForegroundColor Cyan
                $VMMetadata = New-B1Metadata -IP $($PSBoundParameters.IP.IPAddressToString) -Netmask $PSBoundParameters.Netmask -Gateway $($PSBoundParameters.Gateway.IPAddressToString) -DNSServers $($PSBoundParameters.DNSServers.IPAddressToString -join ',') -JoinToken $JoinToken -DNSSuffix $PSBoundParameters.DNSSuffix
                if ($VMMetadata) {
                    Write-Host "Customization metadata generated successfully." -ForegroundColor Cyan
                } else {
                    Write-Error "Failed to generate customization metadata"
                    return $null
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
                    return $null
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
                                return $null
                            }
                            2 {
                                Write-Error "Error. You must use a .vhdx file format for Generation 2 Hyper-V VMs."
                                return $null
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

                    if (!($PSBoundParameters.SkipPowerOn)) {
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
            "Azure" {
                $AzContext = Get-AzContext
                if (!($AzContext)) {
                    try {
                        $AzConnect = Connect-AzAccount -Tenant $($PSBoundParameters.AzTenant) -Subscription $($PSBoundParameters.AzSubscription)
                        Write-Host "Connected to Azure. (Tenant: $($PSBoundParameters.AzTenant)) (Subscription: $($PSBoundParameters.AzSubscription))" -ForegroundColor Cyan
                    } catch {
                        return $_.Exception.Message
                    }
                } elseif (($AzContext.Tenant -ne $($PSBoundParameters.AzTenant)) -or ($AzContext.Subscription -ne $($PSBoundParameters.AzSubscription))) {
                    try {
                        $AzContext = Set-AzContext -Tenant $($PSBoundParameters.AzTenant) -Subscription $($PSBoundParameters.AzSubscription)
                    } catch {
                        return $_.Exception.Message
                    }
                }
                $AzureOffer = Get-AzVMImageOffer -PublisherName 'infoblox' -Location $($PSBoundParameters.AzLocation) | Where-Object {$_.Offer -eq $PSBoundParameters.AzOffer}
                if ($AzureOffer) {
                    $AzureSku = Get-AzVMImageSku -Location $($PSBoundParameters.AzLocation) -PublisherName 'infoblox' -Offer $AzureOffer.Offer | Where-Object {$_.Skus -eq $PSBoundParameters.AzSku}
                    if ($AzureSku) {
                        $AzureImage = Get-AzVMImage -Location $($PSBoundParameters.AzLocation) -PublisherName 'infoblox' -Offer $AzureOffer.Offer -Sku $($AzureSku.Skus)
                        if ($AzureImage) {
                            $AzureImageURN = "infoblox:$($PSBoundParameters.AzOffer):$($PSBoundParameters.AzSku):$($AzureImage.Version)"

                            ## Check if marketplace terms have been accepted.
                            $MarketplaceTerms = Get-AzMarketplaceTerms -Name $($AzureSku.Skus) -Product $($AzureOffer.Offer) -Publisher 'infoblox' -EA SilentlyContinue -WA SilentlyContinue
                            if (!($MarketplaceTerms.Accepted)) {
                                if ($PSBoundParameters.AzAcceptTerms) {
                                    $MarketplaceTermsAcceptance = Set-AzMarketplaceTerms -Name $($AzureSku.Skus) -Product $($AzureOffer.Offer) -Publisher 'infoblox' -Accept
                                    if (!($MarketplaceTermsAcceptance.Accepted)) {
                                        Write-Error 'Failed to accept the Marketplace Terms.'
                                        return $null
                                    }
                                } else {
                                    Write-Error 'The Azure Marketplace Terms for BloxOne Deployment is not accepted. To accept these terms, use the -AzAcceptTerms switch.'
                                    return $null
                                }
                            }

                            # Initialize VM Config
                            $VMConfig = New-AzVMConfig -VMName $($PSBoundParameters.Name) -VMSize $($PSBoundParameters.AzSize) -SecurityType Standard
                            # Update VM Config with VM Plan
                            $VMConfig = $VMConfig | Set-AzVMPlan -Name $($AzureSku.Skus) -Product $($AzureOffer.Offer) -Publisher 'infoblox'
                            # Update VM Config with Diagnostic Info
                            if ($PSBoundParameters.AzBootDiagnostics) {
                                if ($PSBoundParameters.AzStorageAccount) {
                                    $VMConfig = $VMConfig | Set-AzVMBootDiagnostic -Enable -ResourceGroupName $($PSBoundParameters.AzResourceGroup) -StorageAccountName $($PSBoundParameters.AzStorageAccount)
                                } else {
                                    Write-Error "Error. -AzStorageAccount must be specified when using -AzBootDiagnostics"
                                    return $null
                                }
                            } else {
                                $VMConfig = $VMConfig | Set-AzVMBootDiagnostic -Disable
                            }
                            # Update VM Config with VM Source Image
                            $VMConfig = $VMConfig | Set-AzVMSourceImage -PublisherName 'infoblox' -Offer $($PSBoundParameters.AzOffer) -Skus $($AzureSku.Skus) -Version $($AzureImage.Version)
                            # Update VM Config with OS Information & Custom Data
                            $UserData = New-B1Metadata -JoinToken $($PSBoundParameters.JoinToken) | Select-Object -ExpandProperty userdata
                            # Define Random Credential, this is only used as a placeholder and not actually configured on the deployed VM.
                            $AzVMUser = "AzDeploy";
                            $AzVMPassword = (-join ((32..90) + (97..122) | Get-Random -Count 20 | ForEach-Object {[char]$_})) | ConvertTo-SecureString -AsPlainText -Force;
                            $AzVMCredential = New-Object System.Management.Automation.PSCredential ($AzVMUser, $AzVMPassword);
                            $VMConfig = $VMConfig | Set-AzVMOperatingSystem -Linux -CustomData $UserData -Credential $AzVMCredential -ComputerName $($PSBoundParameters.Name)
                            # Update VM Config with Azure Virtual Network / Subnet
                            $AzureVirtualNetwork = Get-AzVirtualNetwork -Name $($PSBoundParameters.AzVirtualNetwork) -ResourceGroupName $($PSBoundParameters.AzResourceGroup)
                            if ($AzureVirtualNetwork) {
                                $AzureSubnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $AzureVirtualNetwork -Name $($PSBoundParameters.AzSubnet)
                                if ($AzureSubnet) {
                                    # Create a virtual network interface
                                    try {
                                        Write-Host "Creating Virtual Network Interface: $($PSBoundParameters.Name)-nic.." -ForegroundColor Cyan
                                        $AzureNetworkInterface = New-AzNetworkInterface -Name "$($PSBoundParameters.Name)-nic" -ResourceGroupName $($PSBoundParameters.AzResourceGroup) -Location $($PSBoundParameters.AzLocation) -SubnetId $AzureSubnet.Id -EnableAcceleratedNetworking;
                                    } catch {
                                        return $_.Exception.Message
                                    }
                                    $VMConfig = $VMConfig | Add-AzVMNetworkInterface -Id $AzureNetworkInterface.Id

                                    ## Deploy VM
                                    try {
                                        Write-Host "Creating Virtual Machine: $($PSBoundParameters.Name).." -ForegroundColor Cyan
                                        $VM = New-AzVM -VM $VMConfig -ResourceGroupName $($PSBoundParameters.AzResourceGroup) -Location $($PSBoundParameters.AzLocation)
                                        $VMInfo = Get-AzVM -Name $($PSBoundParameters.Name) -ResourceGroupName $($PSBoundParameters.AzResourceGroup)
                                    } catch {
                                        return $_.Exception.Message
                                    }
                                } else {
                                    Write-Error "Unable to find Azure Subnet with name: $($PSBoundParameters.AzVirtualNetwork)"
                                    return $null
                                }
                            } else {
                                Write-Error "Unable to find Azure Virtual Network with name: $($PSBoundParameters.AzVirtualNetwork)"
                                return $null
                            }
                        } else {
                            Write-Error "Unable to find Azure Image."
                            return @{
                                "Location" = $($PSBoundParameters.AzLocation)
                                "PublisherName" = 'infoblox'
                                "Offer" = $AzureOffer.Offer
                                "Sku" = $AzureSku.Skus
                            }
                        }
                    } else {
                        Write-Error "Unable to find Azure SKU with name: $($PSBoundParameters.AzSku)"
                        return $null
                    }
                } else {
                    Write-Error "Unable to find Azure Offer with name: $($PSBoundParameters.AzOffer)"
                    return $null
                }
            }
        }

        if ($VM) {
            if (!($PSBoundParameters.SkipPowerOn)) {
                if (!($SkipPingChecks)) {
                    $PingStartCount = 0
                    while (!$PingSuccess) {
                        Write-Host -NoNewLine "`rWaiting for network to become reachable. Elapsed Time: $PingStartCount`s" -ForegroundColor Gray
                        $PingStartCount = $PingStartCount + 10
                        if ($CurrentOS -eq "Windows") {
                            $PingSuccess = (Test-NetConnection $($PSBoundParameters.IP.IPAddressToString) -WarningAction SilentlyContinue -ErrorAction SilentlyContinue).PingSucceeded
                        } else {
                            $PingSuccess = (Test-Connection $($PSBoundParameters.IP.IPAddressToString) -Count 1 -WarningAction SilentlyContinue -ErrorAction SilentlyContinue) | Where-Object {$_.Status -eq 'Success'}
                        }
                        Wait-Event -Timeout 10
                        if ($PingStartCount -gt 120) {
                            Write-Error "Error. Network Failed to become reachable on $($PSBoundParameters.IP.IPAddressToString)."
                            break
                        }
                    }
                    Write-Host ""
                }

                if (!($SkipCloudChecks)) {
                    Switch($Type) {
                        {$_ -in @('VMware','Hyper-V')} {
                            $B1HostProps = @{
                                'IP' = $($PSBoundParameters.IP.IPAddressToString)
                            }
                        }
                        'Azure' {
                            $AzurePrivateIP = (Get-AzNetworkInterface -ResourceId ($VMInfo).NetworkProfile.NetworkInterfaces.Id).IpConfigurations.PrivateIpAddress
                            $B1HostProps = @{
                                'IP' = $AzurePrivateIP
                            }
                        }
                    }
                    while (!(Get-B1Host @B1HostProps)) {
                        $CSPStartCount = $CSPStartCount + 10
                        Write-Host -NoNewLine "`rWaiting for BloxOne Appliance to become registered within BloxOne CSP. Elapsed Time: $CSPStartCount`s" -ForegroundColor Gray
                        Wait-Event -Timeout 10
                        if ($CSPStartCount -gt $CloudCheckTimeout) {
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
                    Write-Host ""
                    Write-Host "BloxOne Appliance is now available, check the CSP portal for registration of the device" -ForegroundColor Green
                    if (!($SkipCloudChecks)) {
                        Get-B1Host @B1HostProps | Format-Table display_name,ip_address,host_version -AutoSize
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