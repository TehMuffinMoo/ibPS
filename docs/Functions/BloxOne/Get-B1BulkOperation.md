---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1BulkOperation

## SYNOPSIS
Used to query BloxOne Bulk Operations

## SYNTAX

```
Get-B1BulkOperation [[-id] <String>] [[-Name] <String>] [-Strict]
```

## DESCRIPTION
This function is used to query BloxOne Bulk Operations

## EXAMPLES

### EXAMPLE 1
```
Get-B1BulkOperation -Name "Backup of all CSP data"
```

## PARAMETERS

### -id
Filter the results by bulk operation id

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

### -Name
Filter the results by bulk operation name

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
