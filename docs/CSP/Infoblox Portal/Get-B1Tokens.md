---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1Tokens

## SYNOPSIS
Provides a summary of token utilization

## SYNTAX

```
Get-B1Tokens [-Bucket] <String> [[-Granularity] <String>] [[-Start] <DateTime>] [[-End] <DateTime>]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to provide a summary of token utilization

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Tokens -Bucket Management
```

## PARAMETERS

### -Bucket
Management, Server or Reporting

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

### -Granularity
The grouping granularity of the data to retrieve.
Valid values are: second, minute, hour, day, week, month, quarter, year

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Now
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start
The start date/time for the data to retrieve.
If not specified, defaults to 1 month ago.
The date/time must be in UTC format.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
The end date/time for the data to retrieve.
If not specified, defaults to now.
The date/time must be in UTC format.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

## DYNAMIC PARAMETERS

### Management
!!! warning "Important Information"
    **These parameters are only available when `-Bucket` is Management**

#### -ObjectType
The ObjectType parameter is used to filter by the type of object for the specified token utilization bucket. Available values are `Active IPs`, `DDI` & `Assets`.

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

### Server
!!! warning "Important Information"
    **These parameters are only available when `-Bucket` is Server**

#### -ServerType
The ServerType parameter is used to filter by the type of server. Available values are `Self Managed` & `As a Service`.

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

#### -InstanceType
The InstanceType parameter is used to filter by the SKU size of the instance. Available values are `XXS`, `XS`, `S`, `M`, `L` & `XL`.

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

### Reporting
!!! warning "Important Information"
    **These parameters are only available when `-Bucket` is Reporting**

#### -Category
The Category parameter is used to filter by the reporting category. Available values are `30-day Active Search` & `Ecosystem`.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
