---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Submit-B1TDTideData

## SYNOPSIS
Used to submit threat indicators into a TIDE Data Profile

## SYNTAX

### None (Default)
```
Submit-B1TDTideData [<CommonParameters>]
```

### File
```
Submit-B1TDTideData -Profile <String> -File <String> [<CommonParameters>]
```

### Class Property
```
Submit-B1TDTideData -Profile <String> -RecordType <String> -RecordValue <String> [-external_id <String>]
 -Detected <DateTime> [-Confidence <Int32>] [-Domain <String>] [-Duration <String>] [-Expiration <DateTime>]
 [-ThreatLevel <String>] [-Target <String>] [-TLD <String>] [<CommonParameters>]
```

### Class
```
Submit-B1TDTideData -ThreatClass <String> [<CommonParameters>]
```

### Property
```
Submit-B1TDTideData -ThreatProperty <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to submit threat indicators into a TIDE Data Profile

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Profile
This is the data profile name to submit the TIDE data to

```yaml
Type: String
Parameter Sets: File, Class Property
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
Parameter Sets: Class Property
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
Parameter Sets: Class Property
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
Parameter Sets: Class Property
Aliases:

Required: False
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
Parameter Sets: Class Property
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThreatClass
The Threat/Indicator class and supports tab-completion.

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
The Threat/Indicator property and supports tab-completion.

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
Parameter Sets: Class Property
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
Parameter Sets: Class Property
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
Parameter Sets: Class Property
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
Parameter Sets: Class Property
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
Parameter Sets: Class Property
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
Parameter Sets: Class Property
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
Parameter Sets: Class Property
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
