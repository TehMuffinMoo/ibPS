---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1Address

## SYNOPSIS
Queries a list of address objects from the BloxOneDDI IPAM

## SYNTAX

### None (Default)
```
Get-B1Address [-Reserved] [-Compartment <String>] [-Limit <Int32>] [-Offset <Int32>] [-tfilter <String>]
 [-Fields <String[]>] [-OrderBy <String>] [-OrderByTag <String>] [-CustomFilters <Object>] [<CommonParameters>]
```

### With Address
```
Get-B1Address [-Address <String>] [-State <String>] [-Reserved] [-Compartment <String>] [-Limit <Int32>]
 [-Offset <Int32>] [-tfilter <String>] [-Fields <String[]>] [-OrderBy <String>] [-OrderByTag <String>]
 [-CustomFilters <Object>] [<CommonParameters>]
```

### With ID
```
Get-B1Address [-Reserved] [-Compartment <String>] [-Limit <Int32>] [-Offset <Int32>] [-tfilter <String>]
 [-Fields <String[]>] [-OrderBy <String>] [-OrderByTag <String>] [-CustomFilters <Object>] [-id <String>]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of address objects from the BloxOneDDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Address -Address "10.0.0.1" -Reserved -Fixed
```

## PARAMETERS

### -Address
Use this parameter to filter by IP Address

```yaml
Type: String
Parameter Sets: With Address
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Use this parameter to filter by State

```yaml
Type: String
Parameter Sets: With Address
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reserved
Use this parameter to filter the list of addresses to those which have a usage of Reserved

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

### -Compartment
Filter the results by Compartment Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomFilters
Accepts either an Object, ArrayList or String containing one or more custom filters.
See here for usage: See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
Return results based on the address id

```yaml
Type: String
Parameter Sets: With ID
Aliases:

Required: False
Position: Named
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
