---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1AddressReservation

## SYNOPSIS
Removes an address reservation from BloxOneDDI IPAM

## SYNTAX

### Default
```
Remove-B1AddressReservation -Address <String> -Space <String> [<CommonParameters>]
```

### With ID
```
Remove-B1AddressReservation -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove an address reservation from BloxOneDDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1AddressReservation -Address "10.0.0.1" -Space "Global"
```

## PARAMETERS

### -Address
The IP address of the reservation to remove

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
The IPAM space the reservation is contained in

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the Address Reservation to remove.
Accepts pipeline input.

```yaml
Type: String
Parameter Sets: With ID
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
