---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1DHCPConfigProfile

## SYNOPSIS
Removes a DHCP Config Profile

## SYNTAX

### Default (Default)
```
Remove-B1DHCPConfigProfile [-Name <String>] [<CommonParameters>]
```

### With ID
```
Remove-B1DHCPConfigProfile -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a DHCP Config Profile

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1DHCPConfigProfile -Name "My Config Profile"
```

### EXAMPLE 2
```powershell
Get-B1DHCPConfigProfile -Name "My Config Profile" | Remove-B1DHCPConfigProfile
```

## PARAMETERS

### -Name
The name of the DHCP Config Profile to remove

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

### -id
The id of the DHCP Config Profile to remove.
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
