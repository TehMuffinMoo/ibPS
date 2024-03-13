---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDLookalikeTargetSummary

## SYNOPSIS
Retrives the summary metrics from the Lookalike Activity Page within the CSP

## SYNTAX

```
Get-B1TDLookalikeTargetSummary [[-Domain] <String>] [[-ThreatClass] <String[]>] [[-Limit] <Int32>]
 [[-Offset] <Int32>] [[-Start] <DateTime>] [-Strict]
```

## DESCRIPTION
This function is used to retrives the summary metrics from the Lookalike Activity Page within the CSP

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDLookalikeTargetSummary
```

### EXAMPLE 2
```powershell
Get-B1TDLookalikeTargetSummary -ThreatClass phishing,malware
```

### EXAMPLE 3
```powershell
Get-B1TDLookalikeTargetSummary -Start (Get-Date).AddDays(-7) -Domain 'google.com'

detected_at                     : 3/12/2024 5:42:32PM
lookalike_count_threats         : 32
lookalike_count_total           : 925
lookalike_threat_types          : {phishing, suspicious}
target_domain                   : google.com
target_domain_content_category  : {Search Engines}
target_domain_registration_date : 1997-09-15
target_domain_type              : common
```

## PARAMETERS

### -Domain
{{ Fill Domain Description }}

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

### -ThreatClass
{{ Fill ThreatClass Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
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
Position: 3
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
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start
A date parameter used as the starting date/time of the lookalike search.
By default, the search will start from 30 days ago and returns the latest results first.
You may need to increase the -Limit parameter or increase the -Start date/time to view earlier events.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: (Get-Date).AddDays(-30)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Strict
{{ Fill Strict Description }}

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
