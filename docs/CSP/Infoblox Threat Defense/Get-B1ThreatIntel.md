---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1ThreatIntel

## SYNOPSIS
Queries Threat Intel analysis, alerts, advisories & other reports from Infoblox Threat Intel

## SYNTAX

### ThreatActors
```
Get-B1ThreatIntel [-ThreatActors] [-Start <DateTime>] [-End <DateTime>] [-Limit <Int32>] [<CommonParameters>]
```

### Publications
```
Get-B1ThreatIntel [-Publications] [-Search <String>] [<CommonParameters>]
```

### ZeroDayDNS
```
Get-B1ThreatIntel [-ZeroDayDNS] [-Unique] [<CommonParameters>]
```

## DESCRIPTION
This function will query Threat Intel analysis, alerts, advisories & other reports from Infoblox Threat Intel.
A full list of Threat Actor IOCs can be retrieved through using Get-B1ThreatActor

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1ThreatIntel -ZeroDayDNS | Select sld -Unique

sld
---
inmedia.agency
mwuff9s29e.com
x92-cc6vty.cc
```

### EXAMPLE 2
```powershell
Get-B1ThreatIntel -ThreatActors -Start (Get-Date).AddDays(-7)

actor_id                       : 8bbe1293-9be7-4533-bc09-13ff1661e0ba
actor_name                     : 3CX compromise
actor_description              : These indicators are associated with the compromise of a legitimate software application 3CX, published by CISA, CrowdStrike, and SentinelOne on or around 30 March 2023. The malicious activity includes beaconing to actor-controlled infrastructure, deployment of second-stage
                                payloads, and, in a small number of cases, hands-on-keyboard activity according to research by CrowdStrike and SentinelOne. See CISA alert for more details : (https://www.cisa.gov/news-events/alerts/2023/03/30/supply-chain-attack-against-3cxdesktopapp).
purpose                        : {malware}
ttp                            : {dns_c2, exfiltration}
display_name                   : 3CX compromise
customer_first_dns_query       : 3/16/2023 12:00:00 AM
customer_last_dns_query        : 6/5/2024 12:00:00 AM
ikb_first_submitted            : 12/12/2022 6:25:48 PM
ikb_last_submitted             : 3/30/2023 5:19:43 PM
ikb_first_classified_malicious : 3/23/2023 5:34:05 PM
related_count                  : 21
page                           : 1
related_indicators_with_dates  : {@{indicator=pbxphonenetwork.com; vt_first_submission_date=3/29/2023 8:24:31 AM; te_ik_submitted=12/27/2022 6:21:34 PM}, @{indicator=msedgepackageinfo.com; vt_first_submission_date=3/29/2023 11:53:17 AM; te_ik_submitted=1/7/2023 6:23:41 PM}, @{indicator=glcloudservice.com;
                                vt_first_submission_date=3/29/2023 2:26:35 PM; te_ik_submitted=3/20/2023 5:36:17 PM}, @{indicator=azureonlinestorage.com; vt_first_submission_date=1/18/2023 2:01:59 AM; te_ik_submitted=1/6/2023 3:06:06 PM}}

actor_id                       : cd186f03-b572-42dd-98c7-202ec25ede93
actor_name                     : Venal Viper
actor_description              : Threat actor operates a malicious HTTP-based traffic distribution system (TDS). Infoblox has tracked actor since 2022 and assess the malicious activity is from advertising company Adsterra. This actor is observed to affiliate with other TDS operators including VexTrio.
infoblox_references            : {https://blogs.infoblox.com/threat-intelligence/cybercrime-central-vextrio-operates-massive-criminal-affiliate-program/}
external_references            : {https://www.blackhatworld.com/seo/warnning-dont-use-adsterra-malware-infected-network.1315557/, https://adsterra.com/blog/official-statement-no-tolerance-for-illegal-traffic-sources/, https://thegrayhatguy.com/ad-programs/adsterra-review/,
                                https://www.qurium.org/alerts/adsterra-used-to-promote-malicious-content-using-hacked-facebook-pages/…}
purpose                        : {malware, pup, scam, phishing…}
ttp                            : {tds, rdga}
display_name                   : Venal Viper
customer_first_dns_query       : 7/1/2021 12:00:00 AM
customer_last_dns_query        : 6/5/2024 12:00:00 AM
ikb_first_submitted            : 12/17/2022 3:06:56 PM
ikb_last_submitted             : 5/27/2024 2:20:25 PM
ikb_first_classified_malicious : 2/16/2023 2:11:58 PM
related_count                  : 14441
page                           : 1
related_indicators_with_dates  : {@{indicator=alienateclergy.com; vt_first_submission_date=2/16/2024 9:49:12 PM; te_ik_submitted=2/16/2024 2:17:53 PM}, @{indicator=amplitudereportmoscow.com; vt_first_submission_date=4/12/2024 2:36:19 AM; te_ik_submitted=3/27/2024 2:24:30 PM},
                                @{indicator=angrilyunbuttoncouch.com; te_ik_submitted=4/15/2024 2:19:16 PM}, @{indicator=antetestingstooped.com; vt_first_submission_date=5/27/2023 9:24:25 AM; te_ik_submitted=5/13/2023 2:11:43 PM}…}
```

### EXAMPLE 3
```powershell
Get-B1ThreatIntel -Publications -Search 'Meerkat'

id           : 30de94e1-c20b-41d9-bc42-6908f1b5bfff
document_id  : BLG-2024-11
title        : Muddling Meerkat: The Great Firewall Manipulator
overview     : Muddling Meerkat appears to be a People's Republic of China (PRC) nation state actor. It conducts active operations through DNS by creating large volumes of widely distributed queries that are subsequently propagated through the internet using open DNS resolvers. Their operations intertwine
            with two topics tightly connected with China and Chinese actors: the Chinese Great Firewall (GFW) and Slow Drip, or random prefix, distributed denial-of-service (DDoS) attacks. While Muddling Meerkat's operations look at first glance like DNS DDoS attacks, it seems unlikely that denial of
            service is their goal, at least in the near term. Muddling Meerkat operations are long-running - apparently starting in October 2019 - and demonstrate a high degree of expertise in DNS.
publish_date : 4/29/2024 10:31:34 PM

id           : 2cdc636d-861f-45d8-9783-2c5bfe60c6ba
document_id  : BLG-2024-13
title        : What a Show! An Ampliﬁed Internet Scale DNS Probing Operation
overview     : A global scale domain name system (DNS) probing operation that targets open resolvers has been underway since at least June 2023. We analyzed queries to Infoblox and many other recursive DNS resolvers in January 2024. While there are numerous commercial and academic DNS measurement
            operations conducted daily on the internet, this one stood out because of its size and the invasive structure of the queries. These probes utilize name servers in the China Education and Research Network (CERNET) to identify open DNS resolvers and measure how they react to different
            responses. The name servers return random IP addresses for a large percentage of queries. The random IP values trigger an ampliﬁcation of queries by the Palo Alto Cortex Xpanse product. This ampliﬁcation pollutes passive DNS collections across the globe and hinders the ability to perform
            reliable research on malicious actors.
publish_date : 6/3/2024 11:13:02 PM
```

## PARAMETERS

### -ThreatActors
The -ThreatActors switch will return a list of threat actors detected within your environment.

```yaml
Type: SwitchParameter
Parameter Sets: ThreatActors
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start
The -Start parameter allows you to define the Start date of which to begin searching.
This is only applicable when using -ThreatActors.
Defaults to 30 days ago.

```yaml
Type: DateTime
Parameter Sets: ThreatActors
Aliases:

Required: False
Position: Named
Default value: (Get-Date).AddMonths(-1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
The -End parameter allows you to define the End date of which to search.
This is only applicable when using -ThreatActors.
Defaults to now.

```yaml
Type: DateTime
Parameter Sets: ThreatActors
Aliases:

Required: False
Position: Named
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Use -Limit to limit the number of results returned.
This is only applicable when using -ThreatActors.
Defaults to 15.
Using a large limit here may result in long waiting times.

```yaml
Type: Int32
Parameter Sets: ThreatActors
Aliases:

Required: False
Position: Named
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### -Publications
The -Publications switch will return a list of threat intelligence publications from Infoblox.

```yaml
Type: SwitchParameter
Parameter Sets: Publications
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Search
The -Search parameter allows you to filter the results of threat intelligence publications using search terms.

```yaml
Type: String
Parameter Sets: Publications
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ZeroDayDNS
The -ZeroDayDNS switch will return a list Zero Day DNS domains associated with your account.

```yaml
Type: SwitchParameter
Parameter Sets: ZeroDayDNS
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Unique
Return only unique results when using -ZeroDayDNS

```yaml
Type: SwitchParameter
Parameter Sets: ZeroDayDNS
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
