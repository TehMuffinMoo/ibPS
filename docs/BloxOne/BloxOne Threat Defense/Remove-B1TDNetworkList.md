---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version: https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
schema: 2.0.0
---

# Remove-B1TDNetworkList

## SYNOPSIS
Removes a network list from BloxOne Threat Defense

## SYNTAX

### notid (Default)
```
Remove-B1TDNetworkList [-Name <String>] [<CommonParameters>]
```

### With ID
```
Remove-B1TDNetworkList -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a network list from BloxOne Threat Defense

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1TDNetworkList -Name "My Network List"
```

### EXAMPLE 2
```powershell
Get-B1TDNetworkList -Name "My Network List" | Remove-B1TDNetworkList
```

## PARAMETERS

### -Name
The name of the network list to remove

```yaml
Type: String
Parameter Sets: notid
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the network list to remove

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
