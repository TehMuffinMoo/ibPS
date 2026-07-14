---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1Subnet

## SYNOPSIS
Updates an existing subnet in Universal DDI IPAM

## SYNTAX

### Subnet
```
Set-B1Subnet -Subnet <String> -CIDR <Int32> -Space <String> [-NewName <String>] [-HAGroup <String>]
 [-DHCPOptions <Object>] [-Description <String>] [-DHCPLeaseSeconds <String>] [-DDNSDomain <String>]
 [-Tags <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Set-B1Subnet -Space <String> -Name <String> [-NewName <String>] [-HAGroup <String>] [-DHCPOptions <Object>]
 [-Description <String>] [-DHCPLeaseSeconds <String>] [-DDNSDomain <String>] [-Tags <Object>] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Object
```
Set-B1Subnet [-NewName <String>] [-HAGroup <String>] [-DHCPOptions <Object>] [-Description <String>]
 [-DHCPLeaseSeconds <String>] [-DDNSDomain <String>] [-Tags <Object>] -Object <Object> [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing subnet in Universal DDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -NewName "MySubnet" -Space "Global" -Description "Comment for description"
```

### EXAMPLE 2
```powershell
## Example usage when combined with Get-B1DHCPOptionCode
$DHCPOptions = @()
$DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

PS> Get-B1Subnet -Subnet "10.10.10.0" -CIDR 24 | Set-B1Subnet -NewName "MySubnet" -Space "Global" -Description "Comment for description" -DHCPOptions $DHCPOptions
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
Parameter Sets: Subnet
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
Parameter Sets: Subnet
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
Parameter Sets: Subnet, Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the subnet.
If more than one subnet object within the selected space has the same name, this will error and you will need to use Pipe as shown in the first example.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Use -NewName to update the name of the subnet

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

### -Object
The Subnet Object to update.
Accepts pipeline input

```yaml
Type: Object
Parameter Sets: Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Force
Perform the operation without prompting for confirmation.
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
