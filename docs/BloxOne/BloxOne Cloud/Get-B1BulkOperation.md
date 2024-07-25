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
Get-B1BulkOperation [[-id] <String>] [[-Name] <String>] [[-Type] <String>] [[-Status] <String>] [-Strict]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to query BloxOne Bulk Operations

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1BulkOperation -Name "My Import Job"
```

### EXAMPLE 2
```powershell
Get-B1BulkOperation -Type 'export'
```

### EXAMPLE 3
```powershell
Get-B1BulkOperation -Type 'import'
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

### -Type
Filter the results by the operation type, such as 'export' or 'import'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Filter the results by the operation status, such as 'completed' or 'failed'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
