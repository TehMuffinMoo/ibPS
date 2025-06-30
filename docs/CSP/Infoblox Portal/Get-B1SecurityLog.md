---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1SecurityLog

## SYNOPSIS
Queries the Universal DDI Security Log

## SYNTAX

```
Get-B1SecurityLog [[-Username] <String>] [[-ClientIP] <String>] [[-Type] <String>] [[-App] <String>]
 [[-Domain] <String>] [[-Start] <DateTime>] [[-End] <DateTime>] [[-Limit] <Int32>] [[-Offset] <Int32>]
 [-Strict] [[-CustomFilters] <Object>] [-Raw] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query the Universal DDI Security Log.
This log contains web server information relating to the Cloud Services Portal Web UI.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1SecurityLog -Limit "25" -Offset "0" -Username "my.email@domain.com" -App "nginx" -Type "nginx.access" -Domain "domain.com"
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

### -ClientIP
Used to filter the Audit Log by IP Address

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

### -Type
Used to filter by Security Event Type, such as "nginx.access"

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

### -App
Use this parameter to filter by App, such as "nginx"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
Use this parameter to filter by the domain of the authenticated user, such as "mycorpdomain.com"

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

### -Start
A date parameter used as the starting date/time of the log search.
By default, the search will start from 24hrs ago and returns the latest results first.
You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: (Get-Date).AddDays(-1)
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
Position: 7
Default value: (Get-Date)
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
Position: 8
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
Position: 9
Default value: 0
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

### -CustomFilters
Accepts either an Object, ArrayList or String containing one or more custom filters.
See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
Return results as raw without additional parsing

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
