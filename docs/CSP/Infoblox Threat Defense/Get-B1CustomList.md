---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1CustomList

## SYNOPSIS
Retrieves a Custom List from Infoblox Threat Defense

## SYNTAX

### Default (Default)
```
Get-B1CustomList [-Name <String>] [-Description <String>] [-Type <String>] [-ReturnItems] [-Limit <Int32>]
 [-Offset <Int32>] [-Fields <String[]>] [-OrderBy <String>] [-OrderByTag <String>] [-Strict]
 [-CustomFilters <Object>] [<CommonParameters>]
```

### ID
```
Get-B1CustomList [-Fields <String[]>] -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to retrieve named lists from Infoblox Threat Defense.
These are referred to and displayed as Custom Lists within the CSP.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1CustomList -Type 'zero_day_dns' -ReturnItems

confidence_level : HIGH
created_time     : 4/29/2024 3:45:51 PM
description      : Auto-generated
id               : 797118
item_count       : 3
items            : {123moviess.mom, auto-bg.info, cap-caps.shop}
items_described  : {@{description=; item=123moviess.mom}, @{description=; item=auto-bg.info}, @{description=; item=cap-caps.shop}}
name             : Threat Insight - Zero Day DNS
policies         : {corporate-policy}
tags             :
threat_level     : HIGH
type             : zero_day_dns
updated_time     : 6/12/2024 12:05:44 PM
```

### EXAMPLE 2
```powershell
Get-B1CustomList -Limit 1 -ReturnItems

confidence_level : HIGH
created_time     : 4/13/2023 12:51:56PM
description      :
id               : 123456
item_count       : 14
items            : {somebaddomain.com,anotherbaddomain.com, andanother...}
items_described  : {@{description=Added from Dossier; item=somebaddomain.com},@{description=Added from Dossier; item=anotherbaddomain.com}}
name             : main_blacklist
policies         : {Main, Corporate}
tags             :
threat_level     : HIGH
type             : custom_list
updated_time     : 4/3/2024 9:49:28AM
```

### EXAMPLE 3
```powershell
Get-B1CustomList -id 123456

confidence_level : HIGH
created_time     : 4/13/2023 12:51:56PM
description      :
id               : 123456
item_count       : 14
items            : {somebaddomain.com,anotherbaddomain.com, andanother...}
items_described  : {@{description=Added from Dossier; item=somebaddomain.com},@{description=Added from Dossier; item=anotherbaddomain.com}}
name             : main_blacklist
policies         : {Main, Corporate}
tags             :
threat_level     : HIGH
type             : custom_list
updated_time     : 4/3/2024 9:49:28AM
```

## PARAMETERS

### -Name
Filter results by Name.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Filter results by Description.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Filter results by type.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnItems
Optionally return the list of domains contained within the Named List.
Only required when -id is not specified.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Use this parameter to limit the quantity of results.

```yaml
Type: Int32
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
Use this parameter to offset the results by the value entered for the purpose of pagination

```yaml
Type: Int32
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: 0
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
Parameter Sets: Default
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
Parameter Sets: Default
Aliases:

Required: False
Position: Named
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
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomFilters
Accepts either an Object, ArrayList or String containing one or more custom filters.
See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

```yaml
Type: Object
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
Filter the results by id

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
