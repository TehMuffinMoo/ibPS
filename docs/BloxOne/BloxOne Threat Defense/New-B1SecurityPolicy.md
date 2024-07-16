---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1SecurityPolicy

## SYNOPSIS
Creates a new Security Policy in BloxOne Threat Defense

## SYNTAX

```
New-B1SecurityPolicy [-Name] <String> [[-Description] <String>] [[-Precedence] <Int32>]
 [[-GeoLocation] <String>] [[-SafeSearch] <String>] [[-DoHPerPolicy] <String>] [[-BlockDNSRebinding] <String>]
 [[-LocalOnPremResolution] <String>] [[-DFPs] <String[]>] [[-ExternalNetworks] <String[]>]
 [[-IPAMNetworks] <Object>] [[-Rules] <Object>] [[-Tags] <Object>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new Security Policy in BloxOne Threat Defense.

## EXAMPLES

### EXAMPLE 1
```powershell
$PolicyRules = @()
$PolicyRules += New-B1SecurityPolicyRule -Action Allow -Type Category -Object All-Categories
$PolicyRules += New-B1SecurityPolicyRule -Action Block -Type Feed -Object antimalware
$PolicyRules += New-B1SecurityPolicyRule -Action Block -Type Custom -Object 'Threat Insight - Zero Day DNS'

$IPAMNetworks = @()
$IPAMNetworks += Get-B1Subnet 10.10.0.0/16 -Space 'My IP Space' | New-B1SecurityPolicyIPAMNetwork
$IPAMNetworks += Get-B1Subnet 10.15.0.0/16 -Space 'My IP Space' | New-B1SecurityPolicyIPAMNetwork

New-B1SecurityPolicy -Name 'My Policy' -Description 'My Policy' `
                     -DoHPerPolicy Enabled -GeoLocation Enabled `
                     -BlockDNSRebinding Enabled -DFPs 'B1-DFP-01','B1-DFP-02' `
                     -ExternalNetworks 'My External Network List' -Rules $PolicyRules `
                     -IPAMNetworks $IPAMNetworks

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
onprem_resolve          : False
precedence              : 12
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
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description for the new Security Policy.

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

### -Precedence
The precedence for the new Security Policy.

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

### -GeoLocation
Set the Geolocation option to Enabled/Disabled.
(Defaults to Disabled)

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

### -SafeSearch
Set the Safe Search option to Enabled/Disabled.
(Defaults to Disabled)

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

### -DoHPerPolicy
Set the DoH Per Policy option to Enabled/Disabled.
(Defaults to Disabled)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BlockDNSRebinding
Set the Block DNS Rebinding Attacks option to Enabled/Disabled.
(Defaults to Disabled)

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

### -LocalOnPremResolution
Set the Local On-Prem Resolution option to Enabled/Disabled.
(Defaults to Disabled)

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

### -DFPs
A list of DNS Forwarding Proxy names to apply to the network scope.
You can get a list of DFPs using Get-B1Service -Type DFP.

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

### -ExternalNetworks
A list of External Network names to apply to the network scope.
You can get a list of External Networks using Get-B1NetworkList.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
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
Position: 11
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
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
A list of tags to add to the new Security Policy

```yaml
Type: Object
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
