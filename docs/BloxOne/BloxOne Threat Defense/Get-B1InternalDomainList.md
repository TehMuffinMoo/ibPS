---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1InternalDomainList

## SYNOPSIS
Retrieves information on Internal Domain objects for this account

## SYNTAX

### Default (Default)
```
Get-B1InternalDomainList [-Name <String>] [-Description <String>] [-IsDefault] [-Strict] [-Limit <Int32>]
 [-Offset <Int32>] [-tfilter <String>] [-Fields <String[]>] [-OrderBy <String>] [-OrderByTag <String>]
 [<CommonParameters>]
```

### With ID
```
Get-B1InternalDomainList [-OrderByTag <String>] [-id <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to retrieve information on Internal Domain objects for this account

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1InternalDomainList -IsDefault

created_time     : 4/22/2020 9:21:30PM
description      : Auto-generated
id               : 123456
internal_domains : {example, example.com, example.net, example.org…}
is_default       : True
name             : Default Bypass Domains/CIDRs
tags             : 
updated_time     : 1/20/2023 1:43:23PM
```

### EXAMPLE 2
```powershell
Get-B1InternalDomainList -Name 'Default'

created_time     : 4/22/2020 9:21:30PM
description      : Auto-generated
id               : 123456
internal_domains : {example, example.com, example.net, example.org…}
is_default       : True
name             : Default Bypass Domains/CIDRs
tags             : 
updated_time     : 1/20/2023 1:43:23PM
```

## PARAMETERS

### -Name
Filter results by Name

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
Filter results by Description

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

### -IsDefault
Filter results by the default domain list

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

### -Limit
Use this parameter to limit the quantity of results.
The default number of results is 1000.

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

### -tfilter
Use this parameter to filter the results returned by tag.

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

### -Fields
Specify a list of fields to return.
The default is to return all fields.

```yaml
Type: String[]
Parameter Sets: Default
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
Parameter Sets: (All)
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
