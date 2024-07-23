---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1ThreatActor

## SYNOPSIS
Queries Threat Actor information by Actor ID or IOC

## SYNTAX

### ByActorID
```
Get-B1ThreatActor -actor_id <String[]> [-Page <Int32>] [-Summary] [-Live] [<CommonParameters>]
```

### ByIOC
```
Get-B1ThreatActor -Indicator <String[]> [-Page <Int32>] [-Live] [<CommonParameters>]
```

## DESCRIPTION
This function will query Threat Actor information by Actor ID or IOC, with the option to return all associated IOCs.

## EXAMPLES

### EXAMPLE 1
```powershell
## Get Threat Actor by Indicator
Get-B1ThreatActor -Indicator j2update.cc

actor_id                       : 365173e1-b679-4267-bdee-fa6b5ba2ba7e
actor_name                     : Decoy Dog
actor_description              : Decoy Dog is a DNS C2 malware toolkit discovered by Infoblox in April 2023. It is a variant of the open source remote 
                                access trojan (RAT) known as Pupy. There are several versions of the toolkit and is considerably advanced over Pupy. 
                                Infoblox was able to detect and describe the features of the toolkit based on DNS and domain registration data alone. 
                                Russian intel companies have subsequently reported that Decoy Dog was used by Ukrainian nation state actors against 
                                Russian critical infrastructure and government entities. It reportedly disrupted the Rosetelecom ISP for Russian users 
                                for over 24 hours and the actors deleted a substantial amount of proprietary data before exiting. Some of these domains 
                                are lookalikes. Because the IP resolution addresses for Decoy Dog are encrypted communication it is possible to have 
                                Decoy Dog domains falsely associated to other actors.
infoblox_references            : {https://blogs.infoblox.com/cyber-threat-intelligence/decoy-dog-is-no-ordinary-pupy-distinguishing-malware-via-dns/, htt
                                ps://blogs.infoblox.com/cyber-threat-intelligence/cyber-threat-advisory/dog-hunt-finding-decoy-dog-toolkit-via-anomalous
                                -dns-traffic/}
external_references            : {https://www.ptsecurity.com/ww-en/analytics/pt-esc-threat-intelligence/hellhounds-operation-lahat/, 
                                https://forumsoc.ru/upload/iblock/f7c/6ncp0iit9pxcth1taxfku9varczadc5b.pdf}
purpose                        : {malware}
ttp                            : {dns_c2, dns_abuse, dns_tunneling, exfiltration…}
display_name                   : Decoy Dog
customer_first_dns_query       : 5/11/2022 12:00:00 AM
customer_last_dns_query        : 7/22/2024 12:00:00 AM
ikb_submitted                  : 4/15/2023 3:46:29 PM
ikb_first_classified_malicious : 3/17/2023 7:07:17 PM
related_count                  : 49
page                           : 1
related_indicators             : {hsdps.cc, j2update.cc, claudfront.net, 213.183.48.75…}
```

### EXAMPLE 2
```powershell
## Get Threat Actor by Actor ID
Get-B1ThreatActor -actor_id '131388ee-71fd-48bd-93cb-922fafb105f1'

actor_id                       : 131388ee-71fd-48bd-93cb-922fafb105f1
actor_name                     : Prolific Puma
actor_description              : Underground link shortening service used for criminal activities, including phishing and malware distribution. The service 
                                has been active since at least January 2020 and includes more than 40k active domains. The service is hosted on anonymous 
                                hosting providers with dedicated IP address. The actor is known to use SMS as a distribution method. They successfully 
                                averted the transparency guardrails of the usTLD nexus requirements at NameSilo in October 2023. Their identity and location 
                                are unknown, although they appear to have some tie to Ukraine and have chosen hosting at times in Estonia. Prolific Puma 
                                occasionally abandons both domain names and IP addresses. Some of their dropped domain names have been registered by Chinese 
                                phishing actors in the past.
infoblox_references            : {https://blogs.infoblox.com/cyber-threat-intelligence/prolific-puma-shadowy-link-shortening-service-enables-cybercrime/}
external_references            : {https://urlscan.io/result/3be86d9f-e596-4a9b-9260-d331811262e5/, 
                                https://urlscan.io/result/00c1d82d-0f03-44b6-96d3-63b503fff464/, 
                                https://urlscan.io/result/26077ac3-1559-4329-ab48-120181555586/, 
                                https://urlscan.io/result/726b6baa-d259-4f67-a4f9-aef3bd93aca3/…}
purpose                        : {phishing, malware, adware, scam}
ttp                            : {rdga, url_shortener, redirect, sms…}
display_name                   : Prolific Puma
customer_first_dns_query       : 7/1/2021 12:00:00 AM
customer_last_dns_query        : 7/22/2024 12:00:00 AM
ikb_first_submitted            : 6/17/2022 2:16:52 AM
ikb_last_submitted             : 7/8/2024 5:13:27 PM
ikb_first_classified_malicious : 3/16/2023 10:13:27 PM
related_count                  : 39114
page                           : 1
related_indicators             : {0tj.us, 136.244.97.78, 18w.us, 1ma.us…}
```

### EXAMPLE 3
```powershell
## Get List of related indicators for particular threat actor
(Get-B1ThreatActor -actor_id '131388ee-71fd-48bd-93cb-922fafb105f1').related_indicators

0tj.us
136.244.97.78
18w.us
1ma.us
2fs.us
2ta.us
2zs.us
3d1.us
3gk.us
3ub.us
3ztq.me
4eg.us
4fe.us
5jp.us
5nz.us
...
```

## PARAMETERS

### -actor_id
A comma separated list of IDs for the threat actors to get details for.

```yaml
Type: String[]
Parameter Sets: ByActorID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Indicator
A comma separated list of IPs, Hostnames or URLs to search related threat actor details for.

```yaml
Type: String[]
Parameter Sets: ByIOC
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
The Page number for related indicators.
These will be returned in batches of 10K for each page.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Summary
Return the threat actor summary, including only those IOCs which have been identified within the customer environment.
    A full list of threat actors observed within your environment can be found using "Get-B1ThreatIntel -ThreatActors"

```yaml
Type: SwitchParameter
Parameter Sets: ByActorID
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Live
Return live results instead of cached results.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
