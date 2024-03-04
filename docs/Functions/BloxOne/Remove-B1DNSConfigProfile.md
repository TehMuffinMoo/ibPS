---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1DNSConfigProfile

## SYNOPSIS
Removes a DNS Config Profile

## SYNTAX

### notid (Default)
```
Remove-B1DNSConfigProfile [-Name <String>] [<CommonParameters>]
```

### ID
```
Remove-B1DNSConfigProfile -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a DNS Config Profile

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1DNSConfigProfile -Name "My Config Profile"
```

### EXAMPLE 2
```powershell
Get-B1DNSConfigProfile -Name "My Config Profile" | Remove-B1DNSConfigProfile
```

## PARAMETERS

### -Name
The name of the DNS Config Profile to remove

```yaml
Type: String
Parameter Sets: notid
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the DNS Config Profile to remove.
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
