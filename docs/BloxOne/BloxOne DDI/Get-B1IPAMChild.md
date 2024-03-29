---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1IPAMChild

## SYNOPSIS
Retrieves a list of child objects from IPAM

## SYNTAX

```
Get-B1IPAMChild [-ID] <String[]> [[-Limit] <Int32>] [[-Offset] <Int32>] [[-Fields] <String[]>]
 [[-OrderBy] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of child objects from IPAM, relating to a specific parent.

This accepts pipeline input from Get-B1Space, Get-B1AddressBlock, Get-B1Subnet & Get-B1Range

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Space -Name "my-ipspace" | Get-B1IPAMChild
```

### EXAMPLE 2
```powershell
Get-B1AddressBlock -Subnet "10.10.10.0" -CIDR 24 -Space "my-ipspace" | Get-B1IPAMChild
```

### EXAMPLE 3
```powershell
Get-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -Space "my-ipspace" | Get-B1IPAMChild
```

## PARAMETERS

### -ID
The ID of the parent object to list child objects for

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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
