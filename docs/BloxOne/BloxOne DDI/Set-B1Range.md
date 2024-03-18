---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version: https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
schema: 2.0.0
---

# Set-B1Range

## SYNOPSIS
Updates an existing DHCP Range in BloxOneDDI IPAM

## SYNTAX

### Default
```
Set-B1Range -StartAddress <String> [-EndAddress <String>] -Space <String> [-Name <String>]
 [-Description <String>] [-HAGroup <String>] [-Tags <Object>] [<CommonParameters>]
```

### With ID
```
Set-B1Range [-Name <String>] [-Description <String>] [-HAGroup <String>] [-Tags <Object>] -id <String>
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing DHCP Range in BloxOneDDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1Range -StartAddress 10.250.20.20 -EndAddress 10.250.20.100 -Description -Tags @{"siteCode"="12345"}
```

## PARAMETERS

### -StartAddress
The start address of the DHCP Range you want to update

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

### -EndAddress
The end address of the DHCP Range you want to update

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
The IPAM space where the DHCP Range is to be placed

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

### -Name
The name to update the DHCP Range to

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

### -Description
The description to update the DHCP Range to

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

### -HAGroup
The name of the HA group to apply to this DHCP Range.
This will overwrite the existing HA Group.

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

### -Tags
Any tags you want to apply to the DHCP Range.
This will overwrite existing tags.

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

### -id
The id of the range.
Accepts pipeline input

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
