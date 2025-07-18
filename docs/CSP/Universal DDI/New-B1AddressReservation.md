---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1AddressReservation

## SYNOPSIS
Creates a new address reservation in Universal DDI IPAM

## SYNTAX

```
New-B1AddressReservation [-Address] <String> [[-Name] <String>] [[-Description] <String>] [-Space] <String>
 [[-Tags] <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new address reservation in Universal DDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1AddressReservation -Address "10.0.0.1" -Name "MyReservedHost" -Description "My Reserved Host" -Space "Global"
```

## PARAMETERS

### -Address
The IP address for the new reservation

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
The name for the new reservation

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

### -Description
The description of the new reservation

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
The IPAM space for the new reservation to be placed in

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Any tags you want to apply to the address reservation

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
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
