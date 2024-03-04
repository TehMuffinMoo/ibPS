---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DHCPHost

## SYNOPSIS
Retrieves a list of BloxOneDDI DHCP Hosts

## SYNTAX

```
Get-B1DHCPHost [[-Name] <String>] [[-IP] <String>] [-Strict] [[-Limit] <Int32>] [[-Offset] <Int32>]
 [[-tfilter] <String>] [[-Fields] <String[]>] [-Associations] [[-id] <String>]
```

## DESCRIPTION
This function is used to query a list of BloxOneDDI DHCP Hosts

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DHCPHost -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.10.10"
```

### EXAMPLE 2
```powershell
$AssociatedSubnets = (Get-B1DHCPHost -Name "bloxoneddihost1.mydomain.corp" -Associations).Subnets
$AssociatedSubnets | ft name,address,cidr,comment
```

## PARAMETERS

### -Name
The name of the DHCP Host to filter by

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
The IP of the DHCP Host to filter by

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

### -Limit
Use this parameter to limit the quantity of results.
The default number of results is 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 1000
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
Position: 4
Default value: 0
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
Position: 5
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
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Associations
{{ Fill Associations Description }}

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

### -id
Return results based on DHCP Host id

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
