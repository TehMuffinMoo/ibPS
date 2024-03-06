---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDTideThreatProperty

## SYNOPSIS
Queries a list of threat properties

## SYNTAX

```
Get-B1TDTideThreatProperty [[-id] <String>] [[-Name] <String>] [[-Class] <String>] [[-ThreatLevel] <Int32>]
```

## DESCRIPTION
This function will query a list of threat properties

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDTideThreatProperty -Name "CamelCase" -ThreatLevel 100
```

### EXAMPLE 2
```powershell
Get-B1TDTideThreatProperty | ft -AutoSize

link                                                                                id                                             name                           threat_level class                  active added                 updated               reference
----                                                                                --                                             ----                           ------------ -----                  ------ -----                 -------               ---------
{@{href=/data/properties/APT_EmdiviC2; rel=self}}                                   APT_EmdiviC2                                   EmdiviC2                                100 APT                    true   10/28/2016 9:54:36PM  10/28/2016 9:54:36PM  {}
{@{href=/data/properties/APT_ExploitKit; rel=self}}                                 APT_ExploitKit                                 Exploit Kit                             100 APT                    true                         1/28/2020 2:29:36AM   {}
{@{href=/data/properties/APT_Generic; rel=self}}                                    APT_Generic                                    Generic                                 100 APT                    true                         4/23/2016 12:01:53AM  {}
{@{href=/data/properties/APT_MalwareC2; rel=self}}                                  APT_MalwareC2                                  Malware C2                              100 APT                    true                         7/16/2018 6:37:50PM   {}
{@{href=/data/properties/APT_MalwareDownload; rel=self}}                            APT_MalwareDownload                            Malware Download                        100 APT                    true                         3/2/2016 6:57:24PM    {}
{@{href=/data/properties/Bot_Bankpatch; rel=self}}                                  Bot_Bankpatch                                  Bankpatch                               100 Bot                    true                         1/29/2020 5:12:49PM   {}
{@{href=/data/properties/Bot_Citadel; rel=self}}                                    Bot_Citadel                                    Citadel                                 100 Bot                    true                         3/2/2016 6:57:24PM    {}
{@{href=/data/properties/Bot_Cridex; rel=self}}                                     Bot_Cridex                                     Cridex                                  100 Bot                    true                         3/2/2016 6:57:24PM    {}
...
```

## PARAMETERS

### -id
Filter the results by property ID

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

### -Name
Filter the results by property name

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

### -Class
Filter the results by property threat class

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThreatLevel
Filter the results by property threat level

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
