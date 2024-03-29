---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DHCPLease

## SYNOPSIS
Retrieves a list of DHCP Leases from BloxOneDDI IPAM

## SYNTAX

### st (Default)
```
Get-B1DHCPLease [-Space <String>] [-Limit <Int32>] [-Offset <Int32>] [-Fields <String[]>] [-OrderBy <String>]
 [-Strict] [<CommonParameters>]
```

### htree
```
Get-B1DHCPLease [-Range] -RangeStart <String> [-RangeEnd <String>] [-Space <String>] [-Limit <Int32>]
 [-Offset <Int32>] [-Fields <String[]>] [-OrderBy <String>] [-Strict] [<CommonParameters>]
```

### std
```
Get-B1DHCPLease [-Address <String>] [-MACAddress <String>] [-Hostname <String>] [-HAGroup <String>]
 [-DHCPServer <String>] [-Space <String>] [-Limit <Int32>] [-Offset <Int32>] [-Fields <String[]>]
 [-OrderBy <String>] [-Strict] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of DHCP Leases from BloxOneDDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DHCPLease -Range -RangeStart 10.10.100.20 -RangeEnd 10.10.100.50 -Limit 100
```

### EXAMPLE 2
```powershell
Get-B1DHCPLease -Address "10.10.100.30"
```

## PARAMETERS

### -Range
Indicates whether to search by DHCP Range

```yaml
Type: SwitchParameter
Parameter Sets: htree
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RangeStart
The start address of the DHCP Range to search

```yaml
Type: String
Parameter Sets: htree
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RangeEnd
The end address of the DHCP Range to search

```yaml
Type: String
Parameter Sets: htree
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Address
Filter the DHCP Leases by IP Address

```yaml
Type: String
Parameter Sets: std
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MACAddress
Filter the DHCP Leases by MAC Address

```yaml
Type: String
Parameter Sets: std
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostname
Filter the DHCP Leases by Hostname

```yaml
Type: String
Parameter Sets: std
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HAGroup
Filter the DHCP Leases by HA Group

```yaml
Type: String
Parameter Sets: std
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DHCPServer
Filter the DHCP Leases by DHCP Server

```yaml
Type: String
Parameter Sets: std
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
Filter the DHCP Leases by IPAM Space

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

### -Limit
Limits the number of results returned, the default is 100

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

### -Offset
Use this parameter to offset the results by the value entered for the purpose of pagination

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

### -Fields
Specify a list of fields to return.
The default is to return all fields.

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

### -OrderBy
Optionally return the list ordered by a particular value.
If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy.
Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

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
