---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DNSEvent

## SYNOPSIS
Queries the BloxOne Threat Defense DNS Events

## SYNTAX

```
Get-B1DNSEvent [[-Query] <String>] [[-IP] <String>] [[-Response] <String[]>] [[-Source] <String[]>]
 [[-Network] <String[]>] [[-Policy] <String[]>] [[-ThreatLevel] <String[]>] [[-ThreatClass] <String[]>]
 [[-FeedName] <String[]>] [[-FeedType] <String[]>] [[-UserGroup] <String[]>] [[-AppCategory] <String[]>]
 [[-ThreatProperty] <String[]>] [[-ThreatIndicator] <String[]>] [[-PolicyAction] <String[]>]
 [[-EndpointGroup] <String[]>] [[-AppName] <String[]>] [[-DNSView] <String[]>] [[-Start] <DateTime>]
 [[-End] <DateTime>] [[-Fields] <String[]>] [[-Limit] <Int32>] [[-Offset] <Int32>]
```

## DESCRIPTION
This function is used to query the BloxOne Threat Defense DNS Events.
This is the log which contains all security policy hits.

## EXAMPLES

### EXAMPLE 1
```
Get-B1DNSEvent -Start (Get-Date).AddDays(-7)
```

## PARAMETERS

### -Query
Use this parameter to filter the DNS Events by hostname or FQDN

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

### -IP
{{ Fill IP Description }}

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

### -Response
Use this parameter to filter the DNS Log by the response, i.e "NXDOMAIN"

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Source
Used to filter the DNS Events by IP Address

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
{{ Fill Network Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Policy
Used to filter the DNS Events by Policy Name

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThreatLevel
{{ Fill ThreatLevel Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FeedName
{{ Fill FeedName Description }}

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

### -FeedType
{{ Fill FeedType Description }}

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

### -UserGroup
{{ Fill UserGroup Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppCategory
{{ Fill AppCategory Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThreatProperty
{{ Fill ThreatProperty Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThreatIndicator
{{ Fill ThreatIndicator Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PolicyAction
{{ Fill PolicyAction Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndpointGroup
{{ Fill EndpointGroup Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppName
{{ Fill AppName Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSView
{{ Fill DNSView Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start
A date parameter used as the starting date/time of the log seatrch.
By default, the search will start from 24hrs ago and returns the latest results first.
You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: $(Get-Date).AddDays(-1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
A date parameter used as the end date/time of the log search.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: $(Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fields
Specify a list of fields to return.
The default is to return all fields.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
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
Position: 22
Default value: 100
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
Position: 23
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
