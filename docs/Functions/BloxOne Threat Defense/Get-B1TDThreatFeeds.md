---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDThreatFeeds

## SYNOPSIS
Use this cmdlet to retrieve information on all Threat Feed objects for the account

## SYNTAX

```
Get-B1TDThreatFeeds [[-Name] <String>] [-Strict]
```

## DESCRIPTION
Use this cmdlet to retrieve information on all Threat Feed objects for the account.
BloxOne Cloud provides predefined threat intelligence feeds based on your subscription.
The Plus subscription offers a few more feeds than the Standard subscription.
The Advanced subscription offers a few more feeds than the Plus subscription.
A threat feed subscription for RPZ updates offers protection against malicious hostnames.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDThreatFeeds -Name "AntiMalware" | ft -AutoSize

confidence_level description
---------------- -----------                                                                                                                                                                                                                                                                   
HIGH             Suspicious/malicious as destinations: Enables protection against known malicious hostname threats that can take action on or control of your systems, such as Malware Command & Control, Malware Download, and active Phishing sites.                                         
MEDIUM           Suspicious/malicious as destinations: Enables protection against known malicious or compromised IP addresses. These are known to host threats that can take action on or control of your systems, such as Malware Command & Control, Malware Download, and active Phishing si…
LOW              Suspicious/malicious as destinations: An extension of the AntiMalware IP feed that contains recently expired Malware IP's with an extended time-to-live (TTL) applied. The extended time-to-live (TTL) provides an extended reach of protection for the DNS FW, but may also …
LOW              Suspicious/malicious as destinations: An extension of the Base and AntiMalware feed that contains recently expired hostname
```

## PARAMETERS

### -Name
Use this parameter to filter the list of Subnets by Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
