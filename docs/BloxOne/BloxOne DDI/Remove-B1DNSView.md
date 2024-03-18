---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version: https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
schema: 2.0.0
---

# Remove-B1DNSView

## SYNOPSIS
Removes a DNS View from BloxOneDDI

## SYNTAX

### Default
```
Remove-B1DNSView -Name <String> [<CommonParameters>]
```

### With ID
```
Remove-B1DNSView -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a DNS View from BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1DNSView -Name "My DNS View"
```

### EXAMPLE 2
```powershell
Get-B1DNSView -Name "My DNS View" | Remove-B1DNSView
```

## PARAMETERS

### -Name
The name of the DNS View to remove

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
The id of the DNS View.
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
