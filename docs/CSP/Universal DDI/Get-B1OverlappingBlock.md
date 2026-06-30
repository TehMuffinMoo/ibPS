---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1OverlappingBlock

## SYNOPSIS
Queries a list of Overlapping Blocks from the Universal DDI IPAM

## SYNTAX

```
Get-B1OverlappingBlock [[-Subnet] <String>] [[-CIDR] <Int32>] [[-Protocol] <String>] [[-Name] <String>]
 [[-Description] <String>] [[-Realm] <String>] [-Strict] [[-Limit] <Int32>] [[-Offset] <Int32>]
 [[-tfilter] <String>] [[-Fields] <String[]>] [[-OrderBy] <String>] [[-OrderByTag] <String>]
 [[-CustomFilters] <Object>] [[-id] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of Overlapping Blocks from the Universal DDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1OverlappingBlock -Name "block-1" -Strict

address           : 10.0.0.0
cidr              : 24
comment           : 
created_at        : 13/11/2024 09:56:16
federated_pool_id : 
federated_realm   : federation/federated_realm/1aad3bfc-be41-4415-ba6d-57bde9e957a0
id                : federation/overlapping_block/17ca1e03-1a15-4732-acd3-9bc8b7de3a03
name              : block-1
network_compliant : True
parent            : 
protocol          : ip4
tags              : 
updated_at        : 26/04/2025 01:50:58
```

## PARAMETERS

### -Subnet
Use this parameter to filter the list of Overlapping Blocks by network address

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

### -CIDR
Use this parameter to filter the list of Overlapping Blocks by CIDR suffix

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Protocol
Use this parameter to filter the list of Overlapping Blocks by protocol

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

### -Name
Use this parameter to filter the list of Overlapping Blocks by name

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

### -Description
Use this parameter to filter the list of Overlapping Blocks by description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Realm
Use this parameter to filter the list of Overlapping Blocks by federated realm

# .PARAMETER UtilizationLow
#     Use this parameter to filter the list of Overlapping Blocks with a utilization above the low utilization threshold

# .PARAMETER UtilizationHigh
#     Use this parameter to filter the list of Overlapping Blocks with a utilization below the high utilization threshold

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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

### -Limit
Use this parameter to limit the quantity of results.
The default number of results is 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
Use this parameter to offset the results by the value entered for the purpose of pagination

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -tfilter
Use this parameter to filter the results returned by tag.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
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
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderBy
Optionally return the list ordered by a particular value.
If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy.
Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderByTag
Optionally return the list ordered by a particular tag value.
Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomFilters
Accepts either an Object, ArrayList or String containing one or more custom filters.
See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
Use this parameter to query a particular overlapping block id

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
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
