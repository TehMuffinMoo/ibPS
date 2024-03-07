---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1Subnet

## SYNOPSIS
Updates an existing subnet in BloxOneDDI IPAM

## SYNTAX

### Default
```
Set-B1Subnet -Subnet <String> -CIDR <Int32> -Space <String> [-Name <String>] [-HAGroup <String>]
 [-DHCPOptions <Object>] [-Description <String>] [-DHCPLeaseSeconds <String>] [-DDNSDomain <String>]
 [-Tags <Object>] [<CommonParameters>]
```

### With ID
```
Set-B1Subnet [-Name <String>] [-HAGroup <String>] [-DHCPOptions <Object>] [-Description <String>]
 [-DHCPLeaseSeconds <String>] [-DDNSDomain <String>] [-Tags <Object>] [-id <String[]>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing subnet in BloxOneDDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -Name "MySubnet" -Space "Global" -Description "Comment for description"
```

### EXAMPLE 2
```powershell
## Example usage when combined with Get-B1DHCPOptionCode
$DHCPOptions = @()
$DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

PS> Set-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -Name "MySubnet" -Space "Global" -Description "Comment for description" -DHCPOptions $DHCPOptions
```

### EXAMPLE 3
```powershell
## Example updating the HA Group and DDNSDomain properties of a subnet

PS> Set-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -Space "Global" -DDNSDomain "myddns.domain.corp" -HAGroup "MyDHCPHAGroup"
```

## PARAMETERS

### -Subnet
The network address of the subnet you want to update

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CIDR
The CIDR suffix of the subnet you want to update

```yaml
Type: Int32
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
The IPAM space where the subnet is located

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name to update the subnet to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HAGroup
The name of the HA group to apply to this subnet

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DHCPOptions
A list of DHCP Options you want to apply to the existing subnet.
This will overwrite existing DHCP options for this subnet.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description to update the subnet to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DHCPLeaseSeconds
The default DHCP Lease duration in seconds

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DDNSDomain
The DDNS Domain to update the subnet to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Any tags you want to apply to the subnet

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the subnet to update.
Accepts pipeline input

```yaml
Type: String[]
Parameter Sets: With ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
