---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1AuditLog

## SYNOPSIS
Queries the Universal DDI Audit Log

## SYNTAX

```
Get-B1AuditLog [[-Username] <String>] [[-ResourceType] <String>] [[-Method] <String>] [[-ResponseCode] <Int32>]
 [[-ClientIP] <String>] [[-Action] <String>] [[-Start] <DateTime>] [[-End] <DateTime>] [[-Limit] <Int32>]
 [[-Offset] <Int32>] [[-OrderBy] <String>] [[-Fields] <String[]>] [[-CustomFilters] <Object>] [-CaseSensitive]
 [-Strict] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query the Universal DDI Audit Log.
This gives you visibility on changes made both via the WebUI and API, along with the context of what has been modified.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1AuditLog -Limit "25" -Offset "0" -Username "my.email@domain.com" -Method "POST" -Action "Create" -ClientIP "1.2.3.4" -ResponseCode "200"
```

## PARAMETERS

### -Username
The username of which you would like to filter the audit log with

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

### -ResourceType
Used to filter by Resource Type, such as "record" or "address_block"

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

### -Method
Use this parameter to filter by the HTTP Method of the API call

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

### -ResponseCode
Use this parameter to filter by the HTTP Response Code of the API call

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

### -ClientIP
Used to filter the Audit Log by IP Address

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Action
Use this parameter to filter by the Audit Log Action, i.e "Create" or "Update"

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

### -Start
A date parameter used as the starting date/time of the log search.
By default, the search will start from 7 days ago and returns the latest results first.
You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: (Get-Date).AddDays(-7)
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
Position: 8
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Use this parameter to limit the quantity of results returned from the Audit Log.
The default number of results is 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
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
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderBy
Optionally return the list ordered by a particular value.
If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy.
Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
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
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomFilters
Accepts either an Object, ArrayList or String containing one or more custom filters.
See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CaseSensitive
Use Case Sensitive matching.
By default, case-insensitive matching both for -Strict matching and regex matching.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
