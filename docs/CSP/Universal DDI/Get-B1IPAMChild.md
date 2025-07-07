---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1IPAMChild

## SYNOPSIS
Retrieves a list of child objects from IPAM

## SYNTAX

```
Get-B1IPAMChild [[-Type] <String[]>] [[-Label] <String>] [[-Description] <String>] [[-Limit] <Int32>]
 [[-Offset] <Int32>] [-Strict] [[-Fields] <String[]>] [[-OrderBy] <String>] [[-OrderByTag] <String>]
 [[-tfilter] <String>] [-Recurse] [-NetworkTopology] [-CaseSensitive] [-Object] <Object[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of child objects from IPAM, relating to a specific parent.

This accepts pipeline input from Get-B1Space, Get-B1AddressBlock, Get-B1Subnet & Get-B1Range

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Space -Name "my-ipspace" | Get-B1IPAMChild
```

### EXAMPLE 2
```powershell
Get-B1AddressBlock -Subnet "10.10.10.0" -CIDR 24 -Space "my-ipspace" | Get-B1IPAMChild -Type 'ipam/subnet'
```

### EXAMPLE 3
```powershell
Get-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -Space "my-ipspace" | Get-B1IPAMChild -Type 'ipam/record'
```

## PARAMETERS

### -Type
Filter results by one or more object types, such as 'subnet', 'range' or 'address_block'

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Label
Filter results by the object label

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

### -Description
Filter results by the object description

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

### -Limit
Limits the number of results returned, the default is 100

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 100
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
Position: 5
Default value: 0
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

### -Fields
Specify a list of fields to return.
The default is to return all fields.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
Position: 7
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
Position: 8
Default value: None
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

### -Recurse
Setting the -Recurse parameter will make the function perform a recursive call and append all child networks to the '.Children' value in returned objects

This may take a long time on very large network structures.

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

### -NetworkTopology
This does the same as: Get-B1IPAMChild | Get-NetworkTopology

This uses the -Recurse parameter and so very large network structures may take a long time to generate.

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

### -CaseSensitive
Use Case Sensitive matching.
By default, case-insensitive matching both for -Strict matching and regex matching.

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

### -Object
The parent object to list child objects for

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 10
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
