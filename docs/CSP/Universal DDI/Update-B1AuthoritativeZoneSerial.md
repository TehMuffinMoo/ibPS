---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Update-B1AuthoritativeZoneSerial

## SYNOPSIS
Increments the serial number of an existing Authoritative Zone in Universal DDI

## SYNTAX

### FQDN
```
Update-B1AuthoritativeZoneSerial -FQDN <String> -View <String> [-Serial <String>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Object
```
Update-B1AuthoritativeZoneSerial [-Serial <String>] -Object <Object> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to increment an Authoritative Zone SOA Serial Number in Universal DDI

## EXAMPLES

### EXAMPLE 1
```powershell
Update-B1AuthoritativeZoneSerial -FQDN "mysubzone.mycompany.corp" -View "default"
```

## PARAMETERS

### -FQDN
The FQDN of the zone to update

```yaml
Type: String
Parameter Sets: FQDN
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -View
The DNS View the zone is located in

```yaml
Type: String
Parameter Sets: FQDN
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Serial
The new serial number to set for the Authoritative Zone.
If not specified, the serial will be incremented by 1,000

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

### -Object
The Authoritative Zone Object to update.
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
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to High.

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
