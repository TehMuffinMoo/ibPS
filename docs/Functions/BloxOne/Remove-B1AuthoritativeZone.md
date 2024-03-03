---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1AuthoritativeZone

## SYNOPSIS
Removes a Authoritative Zone from BloxOneDDI

## SYNTAX

### noID
```
Remove-B1AuthoritativeZone -FQDN <String> -View <Object> [<CommonParameters>]
```

### ID
```
Remove-B1AuthoritativeZone -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a Authoritative Zone from BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```
Remove-B1AuthoritativeZone -FQDN "mysubzone.mycompany.corp" -View "default"
```

## PARAMETERS

### -FQDN
The FQDN of the zone to remove

```yaml
Type: String
Parameter Sets: noID
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
Parameter Sets: noID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the authoritative zone.
Accepts pipeline input

```yaml
Type: String
Parameter Sets: ID
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
