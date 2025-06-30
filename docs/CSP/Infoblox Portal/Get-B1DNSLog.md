---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DNSLog

## SYNOPSIS
Queries the Universal DDI DNS Log

## SYNTAX

```
Get-B1DNSLog [[-Query] <String>] [[-IP] <String[]>] [[-Name] <String[]>] [[-Type] <String>]
 [[-Response] <String>] [[-DNSServers] <String[]>] [[-OrderBy] <String>] [[-Order] <String>]
 [[-Start] <DateTime>] [[-End] <DateTime>] [[-Limit] <Int32>] [[-Offset] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query the Universal DDI DNS Logs.
This is the log which contains all generic DNS request information.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DNSLog -IP "10.10.172.35" -Query "google.com" -Type "A" -Response "216.58.201.110" -Start (Get-Date).AddHours(-6) -End (Get-Date) -Limit 1000 -Offset 0
```

### EXAMPLE 2
```powershell
Get-B1DNSLog -IP "10.10.172.35" -Query "google.com" -Type "A" -Response "216.58.201.110" -Start (Get-Date).AddHours(-6) -End (Get-Date) -Limit 1000 -Offset 0
```

## PARAMETERS

### -Query
Use this parameter to filter the DNS Logs by hostname or FQDN

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
Used to filter the DNS Log by IP Address.
Accepts multiple inputs.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Used to filter the DNS Log by Client Host Name.
Accepts multiple inputs.

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

### -Type
Used to filter the DNS Log by query type, such as "A" or "CNAME"

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

### -Response
Use this parameter to filter the DNS Log by the response, i.e "NXDOMAIN"

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

### -DNSServers
Filter the DNS Logs by one or more DNS Servers (i.e "ddihost.mydomain.corp" or "ddihost1.mydomain.corp","myddihost2.mydomain.corp"

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

### -OrderBy
The field in which to order the results by.
This field supports auto-complete, and defaults to timestamp.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: Timestamp
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
Position: 8
Default value: Asc
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
Position: 9
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
Position: 10
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
Position: 11
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
Use this parameter to offset the results by the value entered for the purpose of pagination.
Only works if -Limit is less than 10,000 and combined Limit and Offset do not exceed 10,000

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
