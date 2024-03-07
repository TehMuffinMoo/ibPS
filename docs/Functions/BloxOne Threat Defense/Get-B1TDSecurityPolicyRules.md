---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDSecurityPolicyRules

## SYNOPSIS
Use this cmdlet to retrieve a list of security policy rules

## SYNTAX

```
Get-B1TDSecurityPolicyRules [[-PolicyID] <Int32>] [[-ListID] <Int32>] [[-CategoryFilterID] <Int32>]
```

## DESCRIPTION
Use this cmdlet to retrieve information on of security policy rules

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDSecurityPolicyRules | Select -First 10 | ft -AutoSize

action                    data                                                                list_id policy_id policy_name           redirect_name rule_tags            type
------                    ----                                                                ------- --------- -----------           ------------- ---------            ----
action_block              antimalware-ip                                                            0    123456 corporate-policy                                         @{tag_scope=; tags=} named_feed
action_block              ext-antimalware-ip                                                        0    123456 corporate-policy                                         @{tag_scope=; tags=} named_feed
action_block              Threat Insight - Data Exfiltration                                        0    123456 corporate-policy                                         @{tag_scope=; tags=} custom_list
action_log                Threat Insight - Notional Data Exfiltration                               0    123456 corporate-policy                                         @{tag_scope=; tags=} custom_list
action_block              Threat Insight - DNS Messenger                                            0    123456 corporate-policy                                         @{tag_scope=; tags=} custom_list
action_block              Threat Insight - Fast Flux                                                0    123456 corporate-policy                                         @{tag_scope=; tags=} custom_list
action_block              suspicious                                                                0    123456 corporate-policy                                         @{tag_scope=; tags=} named_feed
action_block              suspicious-lookalikes                                                     0    123456 corporate-policy                                         @{tag_scope=; tags=} named_feed
action_block              suspicious-noed                                                           0    123456 corporate-policy                                         @{tag_scope=; tags=} named_feed
...
```

## PARAMETERS

### -PolicyID
Filter results by policy_id

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Position: 2
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
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
