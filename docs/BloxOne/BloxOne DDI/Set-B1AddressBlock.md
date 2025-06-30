---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1AddressBlock

## SYNOPSIS
Updates an existing address block in Universal DDI IPAM

## SYNTAX

### Subnet
```
Set-B1AddressBlock -Subnet <String> -CIDR <Int32> -Space <String> [-NewName <String>] [-DHCPOptions <Object>]
 [-Description <String>] [-DHCPLeaseSeconds <Int32>] [-DDNSDomain <String>] [-Compartment <String>]
 [-Tags <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Set-B1AddressBlock -Space <String> -Name <String> [-NewName <String>] [-DHCPOptions <Object>]
 [-Description <String>] [-DHCPLeaseSeconds <Int32>] [-DDNSDomain <String>] [-Compartment <String>]
 [-Tags <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Object
```
Set-B1AddressBlock [-NewName <String>] [-DHCPOptions <Object>] [-Description <String>]
 [-DHCPLeaseSeconds <Int32>] [-DDNSDomain <String>] [-Compartment <String>] [-Tags <Object>] -Object <Object>
 [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing address block in Universal DDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
## Example usage when combined with Get-B1DHCPOptionCode
$DHCPOptions = @()
$DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}
$DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "domain-name-servers").id;"option_value"="10.10.10.10,10.10.10.11";}

PS> Get-B1AddressBlock -Subnet "10.10.100.0" -Space "Global" | Set-B1AddressBlock -Description "Comment for description" -DHCPOptions $DHCPOptions
```

### EXAMPLE 2
```powershell
Set-B1AddressBlock -Subnet "10.10.100.0" -NewName "Updated name" -Space "Global" -Description "Comment for description" -DHCPOptions $DHCPOptions
```

## PARAMETERS

### -Subnet
The network address of the address block you want to update

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
The CIDR suffix of the address block you want to update

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
The IPAM space where the address block is located

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
The name of the Address Block.
If more than one Address Block object within the selected space has the same name, this will error and you will need to use Pipe as shown in the first example.

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
Use -NewName to update the name of the address block

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
A list of DHCP Options you want to update the address block with.
This will overwrite existing options.

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
The new description for the address block

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
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DDNSDomain
The new DDNS Domain for the address block

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

### -Compartment
The name of the compartment to assign to this address block

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
A list of tags to update on the address block.
This will replace existing tags, so would normally be a combined list of existing and new tags

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
The Address Block Object to update.
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
