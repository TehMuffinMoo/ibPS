---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Submit-B1TideData

## SYNOPSIS
Used to submit threat indicators into a TIDE Data Profile

## SYNTAX

### File
```
Submit-B1TideData -Profile <String> -File <String> [<CommonParameters>]
```

### Property
```
Submit-B1TideData -Profile <String> -RecordType <String> -RecordValue <String> -external_id <String>
 -Detected <DateTime> -ThreatProperty <String> [-Confidence <Int32>] [-Domain <String>] [-Duration <String>]
 [-Expiration <DateTime>] [-ThreatLevel <String>] [-Target <String>] [-TLD <String>] [<CommonParameters>]
```

### Class
```
Submit-B1TideData -Profile <String> -RecordType <String> -RecordValue <String> -external_id <String>
 -Detected <DateTime> -ThreatClass <String> [-Confidence <Int32>] [-Domain <String>] [-Duration <String>]
 [-Expiration <DateTime>] [-ThreatLevel <String>] [-Target <String>] [-TLD <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to submit threat indicators into a TIDE Data Profile

## EXAMPLES

### EXAMPLE 1
```powershell
Submit-B1TideData -Profile my-dataprofile -ThreatClass Malicious -RecordType host -RecordValue superbaddomain.com -Detected (Get-Date).AddHours(-7) -ThreatLevel 10 -Confidence 30

link           : {@{href=/data/batches/csdv8d8s-fdss-14fe-vsee-cdsuddcs74; rel=self},
                @{href=/data/batches/csdv8d8s-fdss-14fe-vsee-cdsuddcs74/detail; rel=detail}}
id             : csdv8d8s-fdss-14fe-vsee-cdsuddcs74
submitted      : 3/13/2024 9:41:39PM
imported       : 3/13/2024 9:41:39PM
profile        : 0015J44662GhD3jFGF:my-dataprofile
status         : DONE
user           : user.service.dsjcdvse-dssd-dsvc-e83d-csd8cuds3d@infoblox.invalid
organization   : 0015J44662GhD3jFGF
method         : ui
type           : HOST
total          : 1
num_successful : 1
num_errors     : 0
```

### EXAMPLE 2
```powershell
## This supports all file types supported by TIDE, including CSV/TSV/PSV, JSON & XML
PS> Submit-B1TideData -Profile my-dataprofile -File ../tide.csv

link           : {@{href=/data/batches/csdv8d8s-fdss-14fe-vsee-cdsuddcs74; rel=self},
                @{href=/data/batches/csdv8d8s-fdss-14fe-vsee-cdsuddcs74/detail; rel=detail}}
id             : csdv8d8s-fdss-14fe-vsee-cdsuddcs74
submitted      : 3/13/2024 9:42:14PM
imported       : 3/13/2024 9:42:14PM
profile        : 0015J44662GhD3jFGF:my-dataprofile
status         : DONE
user           : user.service.dsjcdvse-dssd-dsvc-e83d-csd8cuds3d@infoblox.invalid
organization   : 0015J44662GhD3jFGF
method         : ui
type           : HOST
total          : 1422
num_successful : 1422
num_errors     : 0
```

## PARAMETERS

### -Profile
This is the data profile name to submit the TIDE data to.
Supports tab-completion.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecordType
The record type indicates the type of indicator you are submitting.
This can be host, ip, url, email, or hash.

```yaml
Type: String
Parameter Sets: Property, Class
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecordValue
This is the threat/indicator Hostname, IP, URL, Email or Hash value to submit.
  This depends on the -RecordType parameter

```yaml
Type: String
Parameter Sets: Property, Class
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -external_id
This is a string indicating an external ID to assign to the batch (optional).

```yaml
Type: String
Parameter Sets: Property, Class
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Detected
The date/time the threat was detected in as a Date/Time object.
This is converted to ISO8601 format prior to submission.

```yaml
Type: DateTime
Parameter Sets: Property, Class
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThreatClass
The Threat/Indicator class i.e: Sinkhole.
Supports tab-completion.

This is mutually exclusive with -ThreatProperty

```yaml
Type: String
Parameter Sets: Class
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThreatProperty
The Threat/Indicator property i.e: Sinkhole_SinkholedHost. 
Supports tab-completion.

This is mutually exclusive with -ThreatClass

```yaml
Type: String
Parameter Sets: Property
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confidence
The threat's confidence score ranging from 0 - 100 (optional).

```yaml
Type: Int32
Parameter Sets: Property, Class
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
The domain string (optional).

```yaml
Type: String
Parameter Sets: Property, Class
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Duration
The duration of the threat in Xd format or XyXmXwXdXh format.

The expiration date will be set to the detected date + this duration (optional).

```yaml
Type: String
Parameter Sets: Property, Class
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Expiration
The expiration is the date & time that the threat will expire.

```yaml
Type: DateTime
Parameter Sets: Property, Class
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThreatLevel
The threat's level ranging from 0 - 100 as an integer (optional).

```yaml
Type: String
Parameter Sets: Property, Class
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
The target of the threat (optional).
For example: "fakeamazon.com" is a threat targeting "amazon.com".

```yaml
Type: String
Parameter Sets: Property, Class
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TLD
The top-level domain, string (optional).

```yaml
Type: String
Parameter Sets: Property, Class
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
The -File parameter accepts a CSV/TSV/PSV, JSON or XML file.

This should conform to the formats listed here: https://docs.infoblox.com/space/BloxOneThreatDefense/35434535/TIDE+Data+Submission+Overview

```yaml
Type: String
Parameter Sets: File
Aliases:

Required: True
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
