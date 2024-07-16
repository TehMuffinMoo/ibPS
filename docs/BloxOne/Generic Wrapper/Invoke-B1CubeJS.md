---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Invoke-B1CubeJS

## SYNOPSIS

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
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```powershell

```

### EXAMPLE 2
```powershell

```

## PARAMETERS

### -Cube
{{ Fill Cube Description }}

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
{{ Fill Measures Description }}

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
{{ Fill Dimensions Description }}

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
{{ Fill Segments Description }}

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
{{ Fill AllDimensions Description }}

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
{{ Fill Filters Description }}

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
{{ Fill Limit Description }}

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
{{ Fill Offset Description }}

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
{{ Fill TimeDimension Description }}

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
{{ Fill Start Description }}

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
{{ Fill End Description }}

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
{{ Fill Granularity Description }}

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
{{ Fill Grouped Description }}

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
{{ Fill Raw Description }}

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
