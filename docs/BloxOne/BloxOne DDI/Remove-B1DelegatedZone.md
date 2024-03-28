---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1DelegatedZone

## SYNOPSIS
Removes a Delegated Zone from BloxOneDDI

## SYNTAX

### Default
```
Remove-B1DelegatedZone -FQDN <String> -View <Object> [<CommonParameters>]
```

### With ID
```
Remove-B1DelegatedZone -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a Delegated Zone from BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1DelegatedZone -FQDN "delegated.mycompany.corp" -View "default"
```

## PARAMETERS

### -FQDN
The FQDN of the zone to remove

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

### -View
The DNS View the zone is located in

```yaml
Type: Object
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the Delegated Zone.
Accepts pipeline input

```yaml
Type: String
Parameter Sets: With ID
Aliases:

Required: True
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
