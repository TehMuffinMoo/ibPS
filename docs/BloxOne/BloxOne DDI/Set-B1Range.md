---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1Range

## SYNOPSIS
Updates an existing DHCP Range in BloxOneDDI IPAM

## SYNTAX

### Range
```
Set-B1Range -StartAddress <String> [-EndAddress <String>] -Space <String> [-NewName <String>]
 [-Description <String>] [-HAGroup <String>] [-Tags <Object>] [<CommonParameters>]
```

### Name
```
Set-B1Range -Space <String> -Name <String> [-NewName <String>] [-Description <String>] [-HAGroup <String>]
 [-Tags <Object>] [<CommonParameters>]
```

### Object
```
Set-B1Range [-NewName <String>] [-Description <String>] [-HAGroup <String>] [-Tags <Object>] -Object <Object>
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing DHCP Range in BloxOneDDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1Range -StartAddress 10.250.20.20 -EndAddress 10.250.20.100 -Description "Some Description" -Tags @{"siteCode"="12345"}
```

### EXAMPLE 2
```powershell
Get-B1Range -StartAddress 10.250.20.20 -EndAddress 10.250.20.100 | Set-B1Range -Description "Some Description" -Tags @{"siteCode"="12345"}
```

## PARAMETERS

### -StartAddress
The start address of the DHCP Range you want to update

```yaml
Type: String
Parameter Sets: Range
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
Parameter Sets: Range
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
The IPAM space where the DHCP Range is located

```yaml
Type: String
Parameter Sets: Range, Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the range.
If more than one range object within the selected space has the same name, this will error and you will need to use Pipe as shown in the second example.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Use -NewName to update the name of the range

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
Using the value 'None' will clear the HA Group.

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

### -Object
The Range Object to update.
Accepts pipeline input

```yaml
Type: Object
Parameter Sets: Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
