---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1SecurityPolicyRules

## SYNOPSIS
Use this cmdlet to retrieve a list of security policy rules

## SYNTAX

### Default
```
Get-B1SecurityPolicyRules [-PolicyID <Int32>] [-ListID <Int32>] [-CategoryFilterID <Int32>] [-Limit <Int32>]
 [-Offset <Int32>] [-Fields <String[]>] [-CustomFilters <Object>] [<CommonParameters>]
```

### Pipeline
```
Get-B1SecurityPolicyRules [-ListID <Int32>] [-CategoryFilterID <Int32>] [-Limit <Int32>] [-Offset <Int32>]
 [-Fields <String[]>] [-CustomFilters <Object>] -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
Use this cmdlet to retrieve information on of security policy rules

## EXAMPLES

### EXAMPLE 1
```powershell
PS> Get-B1SecurityPolicy -Name 'Default Global Policy' | Get-B1SecurityPolicyRules | ft -AutoSize

action       data                                                                list_id policy_id policy_name           redirect_name rule_tags            type
------       ----                                                                ------- --------- -----------           ------------- ---------            ----
action_allow Default Allow                                                        553567     56924 Default Global Policy               @{tag_scope=; tags=} custom_list
action_block Default Block                                                        756742     56924 Default Global Policy               @{tag_scope=; tags=} custom_list
action_block CrowdStrike and Cyber threat coalition and Fortinet and Palo Alto 1  423566     56924 Default Global Policy               @{tag_scope=; tags=} custom_list
action_allow Default-whitelist                                                    423567     56924 Default Global Policy               @{tag_scope=; tags=} custom_list
action_block CrowdStrike and Cyber threat coalition and Fortinet 1                522345     56924 Default Global Policy               @{tag_scope=; tags=} custom_list
action_block CrowdStrike and Cyber threat coalition 1                             253356     56924 Default Global Policy               @{tag_scope=; tags=} custom_list
...
```

### EXAMPLE 2
```powershell
Get-B1SecurityPolicyRules | Select -First 10 | ft -AutoSize

action                    data                                                                list_id policy_id policy_name           redirect_name rule_tags            type
------                    ----                                                                ------- --------- -----------           ------------- ---------            ----
action_block              antimalware-ip                                                            0    123456 corporate-policy                                         @{tag_scope=; tags=} named_feed
action_block              ext-antimalware-ip                                                        0    123456 corporate-policy                                         @{tag_scope=; tags=} named_feed
action_block              Threat Insight - Data Exfiltration                                        0    453532 iot-policy                                               @{tag_scope=; tags=} custom_list
action_log                Threat Insight - Notional Data Exfiltration                               0    453532 iot-policy                                               @{tag_scope=; tags=} custom_list
action_block              Threat Insight - DNS Messenger                                            0    453532 iot-policy                                               @{tag_scope=; tags=} custom_list
...
```

## PARAMETERS

### -PolicyID
Filter results by policy_id

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

### -ListID
Filter results by list_id

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

### -CategoryFilterID
Filter results by category_filter_id

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

### -Limit
Use this parameter to limit the quantity of results.
The default number of results is 100.

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

### -CustomFilters
Accepts either an Object, ArrayList or String containing one or more custom filters.
See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

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

### -Object
Optionally pass in a security policy object via pipeline to list rules for.

```yaml
Type: Object
Parameter Sets: Pipeline
Aliases:

Required: True
Position: Named
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
