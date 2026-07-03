---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1ReservedBlock

## SYNOPSIS
Queries a list of Reserved Blocks from the Universal DDI IPAM

## SYNTAX

```
Get-B1ReservedBlock [[-Subnet] <String>] [[-CIDR] <Int32>] [[-Protocol] <String>] [[-Name] <String>]
 [[-Description] <String>] [[-Realm] <String>] [-Strict] [[-Limit] <Int32>] [[-Offset] <Int32>]
 [[-tfilter] <String>] [[-Fields] <String[]>] [[-OrderBy] <String>] [[-OrderByTag] <String>]
 [[-CustomFilters] <Object>] [[-id] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of Reserved Blocks from the Universal DDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1ReservedBlock -Subnet '10.10.10.0/24'

address           : 10.10.10.0
cidr              : 24
comment           : Reserved for future use in the Data Center
created_at        : 22/10/2024 06:29:18
federated_pool_id :
federated_realm   : federation/federated_realm/a0ebec5f-ea98-41c1-8033-47b05d1f04fc
id                : federation/reserved_block/ff23ff93-2188-406f-9b1f-79153cf3b07b
metadata          :
name              : reserved-for-dc
network_compliant : True
parent            : federation/federated_block/bdb62c57-0c19-4cef-88c9-464e816bebc0
protocol          : ip4
region            :
tags              :
updated_at        : 26/04/2025 01:50:58
```

## PARAMETERS

### -Subnet
Use this parameter to filter the list of Reserved Blocks by network address

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
Use this parameter to filter the list of Reserved Blocks by CIDR suffix

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
Use this parameter to filter the list of Reserved Blocks by protocol

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
Use this parameter to filter the list of Reserved Blocks by name

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
Use this parameter to filter the list of Reserved Blocks by description

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
Use this parameter to filter the list of Reserved Blocks by federated realm

# .PARAMETER UtilizationLow
#     Use this parameter to filter the list of Reserved Blocks with a utilization above the low utilization threshold

# .PARAMETER UtilizationHigh
#     Use this parameter to filter the list of Reserved Blocks with a utilization below the high utilization threshold

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
Use this parameter to query a particular reserved block id

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
