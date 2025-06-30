---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DNSUsage

## SYNOPSIS
Queries an IP Address against Universal DDI IPAM

## SYNTAX

```
Get-B1DNSUsage [[-Address] <String>] [[-Space] <String>] [-ParseDetails] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query an IP Address against the Universal DDI IPAM and return any records associated with that IP.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DNSUsage -Address "10.10.100.30" -Space "Global" -ParseDetails
```

## PARAMETERS

### -Address
Indicates whether to search by DHCP Range

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
Filter the results by IPAM Space

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParseDetails
Whether to enhance the data by resolving the Authoritative Zone, IPAM Space & DNS View names

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
