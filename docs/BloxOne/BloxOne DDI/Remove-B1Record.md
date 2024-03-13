---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1Record

## SYNOPSIS
Removes an existing DNS record in BloxOneDDI

## SYNTAX

### FQDN
```
Remove-B1Record -Type <String> -View <String> -rdata <String> -FQDN <String> [<CommonParameters>]
```

### Default
```
Remove-B1Record -Type <String> -Name <String> -Zone <String> -View <String> -rdata <String>
 [<CommonParameters>]
```

### With ID
```
Remove-B1Record -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove an existing DNS record in BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1Record -Type A -Name "myArecord" -Zone "corp.mydomain.com" -View "default"
```

## PARAMETERS

### -Type
The type of the record to remove

```yaml
Type: String
Parameter Sets: FQDN, Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the record to remove

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

### -Zone
The zone of the record to remove

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
The DNS View the record exists in

```yaml
Type: String
Parameter Sets: FQDN, Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rdata
The RDATA of the record to remove

```yaml
Type: String
Parameter Sets: FQDN, Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FQDN
The FQDN of the record to remove

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

### -id
The id of the record.
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
