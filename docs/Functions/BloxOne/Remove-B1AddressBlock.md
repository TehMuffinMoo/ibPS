---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1AddressBlock

## SYNOPSIS
Removes an address block from BloxOneDDI IPAM

## SYNTAX

### noID
```
Remove-B1AddressBlock -Subnet <String> -CIDR <Int32> -Space <String> [-Recurse] [-NoWarning]
 [<CommonParameters>]
```

### ID
```
Remove-B1AddressBlock [-Recurse] [-NoWarning] -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove an address block from BloxOneDDI IPAM

## EXAMPLES

### EXAMPLE 1
```
Remove-B1AddressBlock -Subnet "10.0.0.1" -CIDR "24" -Space "Global"
```

## PARAMETERS

### -Subnet
The network address of the address block you want to remove

```yaml
Type: String
Parameter Sets: noID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CIDR
The CIDR suffix of the address block you want to remove

```yaml
Type: Int32
Parameter Sets: noID
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
The IPAM space where the address block is located

```yaml
Type: String
Parameter Sets: noID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse
WARNING!
Using -Recurse will move all child objects to the recycle bin.
By default, child objects are re-parented.

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

### -NoWarning
WARNING!
This is very dangerous if used inappropriately.
The -NoWarning parameter is there to be combined with -Recurse.
When specified, using -Recurse will not prompt for confirmation before deleting.

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
The id of the address block.
Accepts pipeline input

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
