---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDSecurityPolicy

## SYNOPSIS
Retrieves a list of BloxOne Threat Defense Security Policies

## SYNTAX

### notid (Default)
```
Get-B1TDSecurityPolicy [-Name <String>] [-Strict] [<CommonParameters>]
```

### With ID
```
Get-B1TDSecurityPolicy [-id <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of BloxOne Threat Defense Security Policies

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDSecurityPolicy -Name "Remote Users"

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
Parameter Sets: notid
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
Parameter Sets: notid
Aliases:

Required: False
Position: Named
Default value: False
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
