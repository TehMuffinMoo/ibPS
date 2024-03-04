---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1Object

## SYNOPSIS
Generic Wrapper for interaction with the CSP (Cloud Services Portal) via GET requests

## SYNTAX

```
Get-B1Object [-Product] <String> [-App] <String> [-Endpoint] <String> [[-Fields] <String[]>]
 [[-Filters] <Object>] [[-tfilter] <String>] [[-Limit] <Int32>] [[-Offset] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This is a Generic Wrapper for getting objects from the BloxOne CSP (Cloud Services Portal).

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Object -Product 'BloxOne DDI' -App DnsConfig -Endpoint /dns/record -Filters @('name_in_zone~"webserver" or absolute_zone_name=="mydomain.corp." and type=="caa"') -tfilter '("Site"=="New York")' -Limit 100
```

## PARAMETERS

### -Product
Specify the product to use, such as 'BloxOne DDI'.
This parameter is auto-populated when using tab

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

### -App
Specify the App to use, such as 'DnsConfig'
This parameter is auto-populated when using tab

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Endpoint
Specify the API Endpoint to use, such as "/ipam/record".
This parameter is auto-populated when using tab

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
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
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filters
Specify one or more filters to use.
Requires object input

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tfilter
Use this parameter to filter the results returned by tag.

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

### -Limit
Use this parameter to limit the quantity of results.
The default number of results is 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
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
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
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
