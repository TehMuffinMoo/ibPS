---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1FixedAddress

## SYNOPSIS
Removes a fixed address from BloxOneDDI IPAM

## SYNTAX

### noID
```
Remove-B1FixedAddress -IP <String> -Space <String> [<CommonParameters>]
```

### ID
```
Remove-B1FixedAddress -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a fixed address from BloxOneDDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1FixedAddress -IP 10.10.10.200 -Space Global
```

### EXAMPLE 2
```powershell
Get-B1FixedAddress -IP 10.10.10.200 | Remove-B1FixedAddress
```

## PARAMETERS

### -IP
The IP of the fixed address

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

### -Space
Use this parameter to filter the list of fixed addresses by Space

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

### -id
The id of the fixed address.
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
