---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DNSACL

## SYNOPSIS
Retrieves a list of BloxOneDDI DNS Access Control Lists

## SYNTAX

```
Get-B1DNSACL [[-Name] <String>] [-Strict]
```

## DESCRIPTION
This function is used to query a list of BloxOneDDI DNS Access Control Lists

## EXAMPLES

### EXAMPLE 1
```
Get-B1DNSACL -Name "Servers_ACL"
```

## PARAMETERS

### -Name
The name of the DNS Access Control List to filter by

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
