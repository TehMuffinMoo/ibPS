---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DHCPOptionGroup

## SYNOPSIS
Retrieves a list of DHCP option groups from BloxOneDDI

## SYNTAX

```
Get-B1DHCPOptionGroup [[-Name] <String>] [[-Fields] <String[]>] [-Strict]
```

## DESCRIPTION
This function is used to query a list DHCP option groups from BloxOneDDI.

## EXAMPLES

### EXAMPLE 1
```
Get-B1DHCPOptionGroup -Name "Telephony Options"
```

## PARAMETERS

### -Name
The name of the DHCP group to filter by

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

### -Fields
Specify a list of fields to return.
The default is to return all fields.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Strict
Use strict filter matching.
By default, filters are searched using wildcards where possible.
Using strict matching will only return results matching exactly what is entered in the applicable parameters.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
