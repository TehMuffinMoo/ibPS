---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Invoke-B1CubeJS

## SYNOPSIS
A wrapper function for interacting with the BloxOne CubeJS API

## SYNTAX

### Default (Default)
```
Invoke-B1CubeJS [-Cube <String>] [-Measures <String[]>] [-Dimensions <String[]>] [-Segments <String[]>]
 [-AllDimensions] [-Filters <Object>] [-Limit <Int32>] [-Offset <Int32>] [-OrderBy <String>] [-Order <String>]
 [-Grouped] [-Raw] [<CommonParameters>]
```

### TimeDimension
```
Invoke-B1CubeJS [-Cube <String>] [-Measures <String[]>] [-Dimensions <String[]>] [-Segments <String[]>]
 [-AllDimensions] [-Filters <Object>] [-Limit <Int32>] [-Offset <Int32>] [-OrderBy <String>] [-Order <String>]
 -TimeDimension <String> -Start <DateTime> [-End <DateTime>] [-Granularity <String>] [-Grouped] [-Raw]
 [<CommonParameters>]
```

## DESCRIPTION
This is a wrapper function used for interacting with the BloxOne CubeJS APIs.

## EXAMPLES

### EXAMPLE 1
```powershell
$Filters = @(
    @{
        "member" = "asset_daily_counts.asset_context"
        "operator" = "equals"
        "values" = @(
            'cloud'
        )
    }
)
Invoke-B1CubeJS -Cube asset_daily_counts `
                -Measures asset_count `
                -Dimensions asset_context `
                -TimeDimension asset_date `
                -Granularity day `
                -Start (Get-Date).AddDays(-30) `
                -Filters $Filters `
                -Grouped -OrderBy asset_date `
                -Order desc

asset_context asset_count asset_date            asset_date.day
------------- ----------- ----------            --------------
cloud         618         7/23/2024 12:00:00 AM 7/23/2024 12:00:00 AM
cloud         618         7/22/2024 12:00:00 AM 7/22/2024 12:00:00 AM
cloud         618         7/21/2024 12:00:00 AM 7/21/2024 12:00:00 AM
cloud         618         7/20/2024 12:00:00 AM 7/20/2024 12:00:00 AM
cloud         630         7/19/2024 12:00:00 AM 7/19/2024 12:00:00 AM
cloud         69          7/18/2024 12:00:00 AM 7/18/2024 12:00:00 AM
cloud         22          7/17/2024 12:00:00 AM 7/17/2024 12:00:00 AM
cloud         22          7/16/2024 12:00:00 AM 7/16/2024 12:00:00 AM
...
```

## PARAMETERS

### -Cube
Specify the name of the cube to query.
This field supports auto/tab-completion.
Cubes are a way to separate and organise individual tables and databases.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Measures
Specify one or more measures.
This field supports auto/tab-completion.
Measures are referred to as quantitative data, such as number of units sold, number of unique queries, total count, etc.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Dimensions
Specify one or more dimensions.
This field supports auto/tab-completion.
Dimensions are referred to as categorical data, such as ip address, hostname, status or timestamps.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Segments
Specify one or more segments.
This field supports auto/tab-completion.
Segments are predefined filters, used to define complex filtering logic in SQL.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllDimensions
Used to attempt to return all available dimensions.
This discovers a list of dimensions from the CubeJS Meta endpoint, which may not be accurate and could cause errors.

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

### -Filters
Used to provide a list of filters.

A filter is a JavaScript object with the following properties:

$Filters = @(
    @{
        "member" = "NstarLeaseActivity.state"  ## Dimension or measure to be used in the filter, for example: stories.isDraft.
        "operator" = "contains"                ## An operator to be used in the filter.
Only some operators are available for measures.
For dimensions the available operators depend on the type of the dimension.
        "values" = @(                          ## An array of values for the filter.
Values must be of type String.
            'Assignments'
        )
    }
)

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Limit the number of results returned.
This can be used in combination with -Offset for pagination.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
Offset the returned results by the number specified.
This can be used in combination with -Limit for pagination.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderBy
The field in which to order the results by.
This field supports auto-complete, and defaults to timestamp.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Order
The direction to order results in.
This defaults to ascending.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeDimension
In order to be able to work with time series data, Cube needs to identify a time dimension which is a timestamp column in the database.
This field supports auto/tab-completion.

```yaml
Type: String
Parameter Sets: TimeDimension
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start
Used in combination with -TimeDimension and -End to return time series data between specific time periods.

```yaml
Type: DateTime
Parameter Sets: TimeDimension
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
Used in combination with -TimeDimension and -Start to return time series data between specific time periods.

```yaml
Type: DateTime
Parameter Sets: TimeDimension
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Granularity
When returning aggregated results and with the -Grouped parameter, granularity allows you to group data based on time frame such as second, minute, hour, day, week, month, quarter or year.

```yaml
Type: String
Parameter Sets: TimeDimension
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Grouped
Specifying -Grouped will include all dimensions in the GROUP BY statement in the query.

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

### -Raw
Return the Raw results from the API, instead of parsing the output.

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
