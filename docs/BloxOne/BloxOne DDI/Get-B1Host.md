---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1Host

## SYNOPSIS
Queries a list of BloxOneDDI Hosts

## SYNTAX

```
Get-B1Host [[-Name] <String>] [[-IP] <String>] [[-OPHID] <String>] [[-Space] <String>] [[-Limit] <String>]
 [[-Status] <String>] [-Detailed] [-BreakOnError] [-Reduced] [-Strict] [-NoIPSpace] [[-tfilter] <String>]
 [[-Fields] <String[]>] [[-id] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of BloxOneDDI Hosts

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Host -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.10.10" -OPHID "OnPremHostID" -Space "Global" -Limit "100" -Status "degraded" -Detailed
```

## PARAMETERS

### -Name
The name of the host to filter by

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
The IP of the host to filter by

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

### -OPHID
The On Prem Host ID of the host to filter by

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

### -Space
The IPAM Space of the host to filter by

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

### -Limit
Used to limit the number of results.
The default is 10001

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 10001
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Return results based on host status

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

### -Detailed
Include service information with host details

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

### -BreakOnError
Whether to break out of the script/function if a host does not exist

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

### -Reduced
Return minimal details relating to the host.
This includes display name, ip_address, description, host_subtype, host_version, mac_address, nat_ip, last_seen & updated_at fields.

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

### -NoIPSpace
Filter by hosts which do not have an IPAM space assigned

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

### -tfilter
Use this parameter to filter the results returned by tag.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
Use the id parameter to filter the results by ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
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
