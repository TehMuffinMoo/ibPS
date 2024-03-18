---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version: https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
schema: 2.0.0
---

# Grant-B1DNSConfigProfile

## SYNOPSIS
Applies a DNS Config Profile to one or most BloxOneDDI Hosts

## SYNTAX

```
Grant-B1DNSConfigProfile [-Name] <String> [-Hosts] <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to apply a DNS Config Profile to one or most BloxOneDDI Hosts

## EXAMPLES

### EXAMPLE 1
```powershell
Grant-B1DNSConfigProfile -Name "Data Centre" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
```

## PARAMETERS

### -Name
The name of the new DNS Config Profile

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

### -Hosts
A list of BloxOneDDI Hosts to apply the DNS Config Profile to

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
