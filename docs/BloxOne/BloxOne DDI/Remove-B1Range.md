---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version: https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
schema: 2.0.0
---

# Remove-B1Range

## SYNOPSIS
Removes a DHCP Range from BloxOneDDI

## SYNTAX

### Default
```
Remove-B1Range -StartAddress <String> -EndAddress <String> -Space <String> [<CommonParameters>]
```

### With ID
```
Remove-B1Range -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a DHCP Range from BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1Range -StartAddress "10.250.20.20" -EndAddress "10.250.20.100" -Space "Global"
```

## PARAMETERS

### -StartAddress
The start address of the DHCP Range

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

### -EndAddress
The end address of the DHCP Range

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

### -Space
Use this parameter to filter the list of Address Blocks by Space

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

### -id
The id of the range.
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
