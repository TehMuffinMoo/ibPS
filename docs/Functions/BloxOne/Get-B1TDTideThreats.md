---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDTideThreats

## SYNOPSIS
Queries active threats from the TIDE API

## SYNTAX

### host (Default)
```
Get-B1TDTideThreats [-Hostname <String>] [-Limit <Int32>] [<CommonParameters>]
```

### ip
```
Get-B1TDTideThreats [-IP <String>] [-Limit <Int32>] [<CommonParameters>]
```

### url
```
Get-B1TDTideThreats [-URL <String>] [-Limit <Int32>] [<CommonParameters>]
```

### email
```
Get-B1TDTideThreats [-Email <String>] [-Limit <Int32>] [<CommonParameters>]
```

### hash
```
Get-B1TDTideThreats [-Hash <String>] [-Limit <Int32>] [<CommonParameters>]
```

### type
```
Get-B1TDTideThreats [-Type <String>] [-Value <String>] [-Age <String>] [-Distinct <String>] [-Limit <Int32>]
 [<CommonParameters>]
```

### id
```
Get-B1TDTideThreats [-Id <String>] [-Limit <Int32>] [<CommonParameters>]
```

## DESCRIPTION
This function will query the active threats from the TIDE API

## EXAMPLES

### EXAMPLE 1
```
Get-B1TDTideThreats -Hostname "google.com"
```

### EXAMPLE 2
```
Get-B1TDTideThreats -IP "1.1.1.1"
```

### EXAMPLE 3
```
Get-B1TDTideThreats -Hostname eicar.co -Limit 10
```

### EXAMPLE 4
```
Get-B1TDTideThreats -Type Host -Value eicar.co -Distinct Profile
```

### EXAMPLE 5
```
Get-B1TDTideThreats -Type URL -Age Recent
```

## PARAMETERS

### -Hostname
Use -Hostname to retrieve threats based on a hostname indicator

```yaml
Type: String
Parameter Sets: host
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IP
Use -IP to retrieve threats based on a IP indicator

```yaml
Type: String
Parameter Sets: ip
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -URL
Use -URL to retrieve threats based on a URL indicator

```yaml
Type: String
Parameter Sets: url
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
Use -Email to retrieve threats based on a Email indicator

```yaml
Type: String
Parameter Sets: email
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hash
Use -Hash to retrieve threats based on a Hash indicator

```yaml
Type: String
Parameter Sets: hash
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Use the -Type parameter to search by threat type and optionally indicator.
Must be used in conjunction with the -Value parameter

```yaml
Type: String
Parameter Sets: type
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
The value to search based on the -Type selected

```yaml
Type: String
Parameter Sets: type
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Age
{{ Fill Age Description }}

```yaml
Type: String
Parameter Sets: type
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Distinct
Threats may be considered separately by profile and property, depending on the value of the "distinct" query parameter.
For example, assume an IP has been most recently submitted by an organization as Bot_Sality and Bot_Virut.
If the "distinct" parameter is "property", both records will be returned.
If the "distinct" parameter is "profile", only the most recently detected record from the organization will be returned.
The default is "Property"

```yaml
Type: String
Parameter Sets: type
Aliases:

Required: False
Position: Named
Default value: Property
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Filter the results by Threat ID

```yaml
Type: String
Parameter Sets: id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Used to set the maximum number of records to be returned (default is 100)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
