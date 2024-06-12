---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1SecurityPolicy

## SYNOPSIS
Retrieves a list of BloxOne Threat Defense Security Policies

## SYNTAX

### Default (Default)
```
Get-B1SecurityPolicy [-Name <String>] [-Limit <Int32>] [-Offset <Int32>] [-Fields <String[]>]
 [-tfilter <String>] [-Strict] [-CustomFilters <Object>] [<CommonParameters>]
```

### With ID
```
Get-B1SecurityPolicy [-id <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of BloxOne Threat Defense Security Policies

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1SecurityPolicy -Name "Remote Users"

access_codes          : {}
created_time          : 4/13/2023 12:03:40PM
default_action        : action_allow
default_redirect_name : 
description           : Remote Users Policy
dfp_services          : {6abcdefghijklmnopqrstuvwxyz123}
dfps                  : {654321}
ecs                   : False
id                    : 123456
is_default            : False
name                  : Remote-Users
net_address_dfps      : {}
network_lists         : {}
onprem_resolve        : False
precedence            : 63
roaming_device_groups : {}
rules                 : {@{action=action_redirect; data=Blacklist; redirect_name=; type=custom_list}, @{action=action_block; data=Malicious Domains; type=custom_list}, @{action=action_block; data=Newly Observed Domains; type=custom_list}, 
                        @{action=action_allow; data=Whitelist; type=custom_list}…}
safe_search           : False
scope_expr            : 
scope_tags            : {}
tags                  : 
updated_time          : 9/6/2023 10:22:29PM
user_groups           : {}
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
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
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
