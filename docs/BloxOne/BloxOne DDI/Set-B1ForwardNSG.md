---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1ForwardNSG

## SYNOPSIS
Updates a Forward DNS Server Group in BloxOneDDI

## SYNTAX

### Default
```
Set-B1ForwardNSG -Name <String> [-NewName <String>] [-Description <String>] [-AddHosts] [-RemoveHosts]
 [-Hosts <Object>] [-Tags <Object>] [<CommonParameters>]
```

### Object
```
Set-B1ForwardNSG [-NewName <String>] [-Description <String>] [-AddHosts] [-RemoveHosts] [-Hosts <Object>]
 [-Tags <Object>] -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to update a Forward DNS Server Group in BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1ForwardNSG -Name "InfoBlox DTC" -AddHosts -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
```

### EXAMPLE 2
```powershell
Get-B1ForwardNSG -Name "InfoBlox DTC" | Set-B1ForwardNSG -AddHosts -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp" -NewName "Infoblox DTC New"
```

## PARAMETERS

### -Name
The name of the Forward DNS Server Group

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

### -NewName
Use -NewName to update the name of the Forward DNS Server Group

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
The new description for the Forward DNS Server Group

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

### -AddHosts
This switch indicates you are adding hosts to the Forward NSG using the -Hosts parameter

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

### -RemoveHosts
This switch indicates you are removing hosts to the Forward NSG using the -Hosts parameter

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

### -Hosts
This is a list of hosts to be added or removed from the Forward NSG, indicated by the -AddHosts & -RemoveHosts parameters

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

### -Tags
Any tags you want to apply to the forward NSG

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
The Forward DNS Server Group Object to update.
Accepts pipeline input.

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
