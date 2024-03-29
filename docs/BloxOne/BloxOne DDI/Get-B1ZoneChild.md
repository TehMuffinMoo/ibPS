---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1ZoneChild

## SYNOPSIS
Retrieves a list of child objects from a DNS View or Zone

## SYNTAX

```
Get-B1ZoneChild [-ID] <String> [-Flat] [[-Limit] <Int32>] [[-Offset] <Int32>] [[-Fields] <String[]>]
 [[-OrderBy] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of child objects from a DNS View or Zone.

This accepts pipeline input from Get-B1DNSView, Get-B1AuthoritativeZone & Get-B1ForwardZone

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DNSView -Name "my-dnsview" | Get-B1ZoneChild
```

### EXAMPLE 2
```powershell
Get-B1AuthoritativeZone -FQDN "my.dns.zone" | Get-B1ZoneChild
```

### EXAMPLE 3
```powershell
Get-B1ForwardZone -FQDN "my.dns.zone" | Get-B1ZoneChild
```

## PARAMETERS

### -ID
The ID of the parent DNS View or Zone to list child objects for

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Flat
Specify the -Flat parameter to return the children as a recursive flat list

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
Limits the number of results returned, the default is 100

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
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
Position: 4
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
Position: 5
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
