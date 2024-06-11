---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1Space

## SYNOPSIS
Creates a new BloxOneDDI IPAM/DHCP Space

## SYNTAX

```
New-B1Space [-Name] <String> [[-Description] <String>] [[-DHCPOptions] <Object>] [[-DDNSDomain] <String>]
 [[-Compartment] <String>] [[-Tags] <Object>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new BloxOneDDI IPAM/DHCP Space

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1Space -Name "Global"
```

## PARAMETERS

### -Name
The name of the IP Space

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

### -Description
The description of the IP Space you are creating

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DHCPOptions
A list of DHCP Options you want to apply to the new IP Space.
These will be inherited by any child Address Blocks, Subnets & Ranges.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DDNSDomain
The DDNS Domain to apply to the new IP Space.
This will be inherited by any child Address Blocks, Subnets & Ranges.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Compartment
The name of the compartment to assign to this space

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Any tags you want to apply to the new IP Space

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
