---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Deploy-B1Appliance

## SYNOPSIS
Deploys a BloxOneDDI Virtual Appliance to VMware or Hyper-V

## SYNTAX

### VMware
```
Deploy-B1Appliance [-Type] <String> [-Name] <String> [-IP] <Object> [-Netmask] <Object> [-Gateway] <Object>
 [-DNSServers] <Object> [-NTPServers] <Object> [-DNSSuffix] <Object> [-JoinToken] <Object>
 [-DownloadLatestImage] [[-ImagesPath] <String>] [-SkipCloudChecks] [-SkipPingChecks] [-SkipPowerOn]
 [-OVAPath] <String> [-vCenter] <String> [-Cluster] <String> [-Datastore] <String> [-PortGroup] <String>
 [-PortGroupType] <String> [-Creds] <PSCredential>
 [<CommonParameters>]
```

### Hyper-V
```
Deploy-B1Appliance [-Type] <String> [-Name] <String> [-IP] <Object> [-Netmask] <Object> [-Gateway] <Object>
 [-DNSServers] <Object> [-NTPServers] <Object> [-DNSSuffix] <Object> [-JoinToken] <Object>
 [-DownloadLatestImage] [[-ImagesPath] <String>] [-SkipCloudChecks] [-SkipPingChecks] [-SkipPowerOn]
 [-VHDPath] <String> [-HyperVServer] <String> [-HyperVGeneration] <Int> [-VMPath] <String> [-VirtualNetwork]<String>
 [-VirtualNetworkVLAN] <Int> [-CPU] <Int> [-Memory] <String>
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to deploy a BloxOneDDI Virtual Appliance to a VMware host/cluster or Hyper-V

## EXAMPLES

### EXAMPLE 1
```powershell
Deploy-B1Appliance -Type "VMware" `
                   -Name "bloxoneddihost1" -IP "10.10.100.10" `
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
```

### EXAMPLE 2
```powershell
Deploy-B1Appliance -Type Hyper-V `
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
```

## PARAMETERS

### -Type
The type of deployment to perform (VMware / Hyper-V)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the virtual machine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IP
The IP Address for the primary network interface of the virtual machine

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Netmask
The Netmask for the primary network interface of the virtual machine

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Gateway
The Gateway for the primary network interface of the virtual machine

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSServers
One or more DNS Servers for the virtual machine

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: 52.119.40.100
Accept pipeline input: False
Accept wildcard characters: False
```

### -NTPServers
One or more NTP Servers for the virtual machine

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSSuffix
The DNS Suffix for the virtual machine

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JoinToken
The Join Token for registration of the BloxOneDDI Host into the Cloud Services Portal

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DownloadLatestImage
Using this parameter will download the latest relevant image prior to deployment.

-DownloadLatestImage, -OVAPath & -VHDPath are mutually exclusive.

When -DownloadLatestImage is used in combination with -ImagesPath, the latest image will be downloaded to this location prior to deployment if it does not already exist.
If used consistently, this will always deploy the latest image but only need to download it once; effectively caching.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImagesPath
Use this parameter to define the base path for images to be cached in when specifying the -DownloadLatestImage parameter.

This cannot be used in conjunction with -OVAPath or -VHDPath

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCloudChecks
Using this parameter will mean the deployment will not wait for the BloxOneDDI Host to become registered/available within the Cloud Services Portal

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipPingChecks
Using this parameter will skip ping checks during deployment, for cases where the deployment machine and host are separated by a device which blocks ICMP.

NOTE: This will also skip checking of IP Addresses which are already in use.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipPowerOn
Using this parameter will leave the VM in a powered off state once deployed

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## DYNAMIC PARAMETERS

### VMware
!!! warning "Important Information"
    **These parameters are only available when `-Type` is VMware**

#### -OVAPath
The path to the BloxOneDDI OVA

`-OVAPath` and `-DownloadLatestImage` are mutually exclusive.

`-ImagesPath` should be used for selecting the appropriate image cache location.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -vCenter
The IP, Hostname or FQDN of the vCenter you want to deploy to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Cluster
The name of the VMware cluster in vCenter to deploy to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Datastore
The name of the VMware datastore to deploy to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -PortGroup
The name of the port group to connect the VM's network adapters to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -PortGroupType
The type of port group you are using. This can be `Standard` or `vDS`

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Creds
The credentials used to connect to vCenter. If not specified, you will be prompted to enter the credentials.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```


### Hyper-V
!!! warning "Important Information"
    **These parameters are only available when `-Type` is Hyper-V**

#### -VHDPath
The full path to the BloxOne VHD/VHDX file.

`-VHDPath` and `-DownloadLatestImage` are mutually exclusive.

`-ImagesPath` should be used for selecting the appropriate image cache location.

#### -HyperVServer
The IP, Hostname or FQDN of the Hyper-V Server for the new VM to be deployed to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -HyperVGeneration
The generation of the Hyper-V VM to create. (Generation 1 or 2)

```yaml
Type: Int
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -VMPath
The full path where the VM should be stored. I.e `A:\VMs\`

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -VirtualNetwork
The name of the Virtual Network defined in Hyper-V to connect the VM to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -VirtualNetworkVLAN
The name of the VLAN number to assosciate the new VM with.

This is optional and to be used only if attaching the VM to a trunked port.

```yaml
Type: Int
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -CPU
The CPU parameter is used to define the amount of CPUs to assign to the VM. The default is 8.

```yaml
Type: Int
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Memory
The Memory parameter is used to define the amount of Memory to assign to the VM. The default is 16GB

The `GB` suffix is required when using this parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS
BloxOne Host build attributes

## OUTPUTS
BloxOne DDI Host Object

## NOTES
Credits: Ollie Sheridan - Assisted with development of the Hyper-V integration

## RELATED LINKS
