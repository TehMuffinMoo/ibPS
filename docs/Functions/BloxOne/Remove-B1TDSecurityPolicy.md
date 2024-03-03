---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1TDSecurityPolicy

## SYNOPSIS
Removes a BloxOne Threat Defense Security Policy

## SYNTAX

### NoID (Default)
```
Remove-B1TDSecurityPolicy [-Name <String>] [<CommonParameters>]
```

### ID
```
Remove-B1TDSecurityPolicy -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a BloxOne Threat Defense Security Policy

## EXAMPLES

### EXAMPLE 1
```
Remove-B1TDSecurityPolicy -Name "Remote Users"
```

### EXAMPLE 2
```
Get-B1TDSecurityPolicy -Name "Remote Users" | Remove-B1TDSecurityPolicy
```

## PARAMETERS

### -Name
The name of the BloxOne Threat Defense Security Policy to delete.

```yaml
Type: String
Parameter Sets: NoID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the BloxOne Threat Defense Security Policy.
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
