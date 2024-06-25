---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1SecurityPolicy

## SYNOPSIS
Updates an existing Security Policy in BloxOne Threat Defense

## SYNTAX

### Default
```
Set-B1SecurityPolicy -Name <String> [-NewName <String>] [-Description <String>] [-Precedence <Int32>]
 [-GeoLocation <String>] [-SafeSearch <String>] [-DoHPerPolicy <String>] [-BlockDNSRebinding <String>]
 [-LocalOnPremResolution <String>] [-DFPs <String[]>] [-ExternalNetworks <String[]>] [-IPAMNetworks <Object>]
 [-Rules <Object>] [-Tags <Object>] [<CommonParameters>]
```

### Pipeline
```
Set-B1SecurityPolicy [-NewName <String>] [-Description <String>] [-Precedence <Int32>] [-GeoLocation <String>]
 [-SafeSearch <String>] [-DoHPerPolicy <String>] [-BlockDNSRebinding <String>]
 [-LocalOnPremResolution <String>] [-DFPs <String[]>] [-ExternalNetworks <String[]>] [-IPAMNetworks <Object>]
 [-Rules <Object>] [-Tags <Object>] -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing Security Policy in BloxOne Threat Defense.

## EXAMPLES

### EXAMPLE 1
```powershell
## Example of copying rules from one Security Policy to another.

$PolicyRules = (Get-B1SecurityPolicy -Name 'Main Policy').rules
Get-B1SecurityPolicy -Name 'Child Policy' | Set-B1SecurityPolicy -Rules $PolicyRules
```

### EXAMPLE 2
```powershell
Get-B1SecurityPolicy -Name 'My Policy' | Set-B1SecurityPolicy -Precedence 5 -LocalOnPremResolution Enabled

access_codes            : {}
block_dns_rebind_attack : True
created_time            : 6/3/2024 10:24:47 AM
default_action          : action_allow
default_redirect_name   : 
description             : My Policy
dfp_services            : {cv4g9f4jg98jg854jt5g,v4m38jg983egjh9cff}
dfps                    : {123456,654321}
doh_enabled             : True
doh_fqdn                : dfsdgghhdh-btrb-4bbb-bffb-cmjumbfgfnhm9.doh.threatdefense.infoblox.com
ecs                     : True
id                      : 123456
is_default              : False
name                    : My Policy
net_address_dfps        : {@{addr_net=10.10.0.0/16; dfp_ids=System.Object[]; dfp_service_ids=System.Object[]; end=10.10.255.255; external_scope_id=vsdvreg-bdrv-regb-g455-g5h5dhy54g5h; host_id=; ip_space_id=cdafsffc-fgfg-1fff-gh6v-j7iiku8idssdswzx; scope_type=SUBNET; start=10.10.0.0},
                          @{addr_net=10.15.0.0/16; dfp_ids=System.Object[]; dfp_service_ids=System.Object[]; end=10.15.255.255; external_scope_id=gr8g5455-g45t-rg5r-g4g4-g4g4tdrehg; host_id=; ip_space_id=cdafsffc-fgfg-1fff-gh6v-j7iiku8idssdswzx; scope_type=SUBNET; start=10.15.0.0}}
network_lists           : {789456}
onprem_resolve          : True
precedence              : 5
roaming_device_groups   : {}
rules                   : {@{action=action_allow; data=All-Categories; type=category_filter}, @{action=action_block; data=Threat Insight - Zero Day DNS; description=Auto-generated; type=custom_list}, @{action=action_block; data=antimalware; description=Suspicious/malicious as destinations: 
                        Enables protection against known malicious hostname threats that can take action on or control of your systems, such as Malware Command & Control, Malware Download, and active Phishing sites.; type=named_feed}}
safe_search             : False
scope_expr              : 
scope_tags              : {}
tags                    : 
updated_time            : 6/3/2024 10:24:47 AM
user_groups             : {}
```

## PARAMETERS

### -Name
The name of the new Security Policy.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
The new name to set the Security Policy to.

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

### -Description
The new description for the Security Policy

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

### -Precedence
The new precedence for the new Security Policy.

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

### -GeoLocation
Enable or Disable the Geolocation option.

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

### -SafeSearch
Enable or Disable the Safe Search option.

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

### -DoHPerPolicy
Enable or Disable the DoH Per Policy option.

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

### -BlockDNSRebinding
Enable or Disable the Block DNS Rebinding Attacks option.

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

### -LocalOnPremResolution
Enable or Disable the Local On-Prem Resolution option.

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

### -DFPs
A list of DNS Forwarding Proxy names to apply to the network scope.
You can get a list of DFPs using Get-B1Service -Type DFP.

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

### -ExternalNetworks
A list of External Network names to apply to the network scope.
You can get a list of External Networks using Get-B1NetworkList.

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

### -IPAMNetworks
A list of Address Blocks / Subnets / Ranges to apply to the network scope.
You can build this list of networks using New-B1SecurityPolicyIPAMNetwork, see the examples.

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

### -Rules
A list of Policy Rules to apply to the new Security Policy.
You can build this list of rules using New-B1SecurityPolicyRule, see the examples.

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

### -Tags
A list of tags to apply to the Security Policy

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
The Security Policy Object(s) to update.
Accepts pipeline input.

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
