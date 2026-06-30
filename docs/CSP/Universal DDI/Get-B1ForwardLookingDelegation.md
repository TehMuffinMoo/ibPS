---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1ForwardLookingDelegation

## SYNOPSIS
Queries a list of Forward Looking Delegations from the Universal DDI IPAM

## SYNTAX

```
Get-B1ForwardLookingDelegation [[-Subnet] <String>] [[-CIDR] <Int32>] [[-Protocol] <String>] [[-Name] <String>]
 [[-Description] <String>] [-Strict] [[-Limit] <Int32>] [[-Offset] <Int32>] [[-tfilter] <String>]
 [[-Fields] <String[]>] [[-OrderBy] <String>] [[-OrderByTag] <String>] [[-CustomFilters] <Object>]
 [[-id] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of Forward Looking Delegations from the Universal DDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1ForwardLookingDelegation -Name "AZ_2_FLD" -Strict

id                : federation/forward_looking_delegation/c178b92f-63eb-4c87-943e-98befa1e1772
created_at        : 30/06/2026 16:16:26
updated_at        : 30/06/2026 16:16:26
name              : AZ_2_FLD
comment           : Azure Landing Zone #2 - Forward Looking Delegation
protocol          : ip4
address           : 10.20.0.0
cidr              : 16
tags              : 
federated_realms  : {federation/federated_realm/2bff55cf-9bb9-441f-bf06-df53e9358aa3}
federated_pool_id : 
network_compliant : True
```

## PARAMETERS

### -Subnet
{{ Fill Subnet Description }}

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
{{ Fill CIDR Description }}

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
{{ Fill Protocol Description }}

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
Use this parameter to filter the list of Forward Looking Delegations by name

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
Use this parameter to filter the list of Forward Looking Delegations by description

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
Position: 6
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
Position: 7
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
Position: 8
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
Position: 9
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
Position: 10
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
Position: 11
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
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
Use this parameter to query a particular forward looking delegation id

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
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
