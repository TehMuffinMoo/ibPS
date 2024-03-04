---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Grant-B1DHCPConfigProfile

## SYNOPSIS
Applies a DHCP Config Profile to one or most BloxOneDDI Hosts

## SYNTAX

### noID
```
Grant-B1DHCPConfigProfile -Name <String> -Hosts <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ID
```
Grant-B1DHCPConfigProfile -Name <String> -id <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to apply a DHCP Config Profile to one or most BloxOneDDI Hosts

## EXAMPLES

### EXAMPLE 1
```powershell
Grant-B1DHCPConfigProfile -Name "Data Centre" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
```

## PARAMETERS

### -Name
The name of the new DHCP Config Profile

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hosts
A list of BloxOneDDI Hosts to apply the DHCP Config Profile to

```yaml
Type: Object
Parameter Sets: noID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
{{ Fill id Description }}

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
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
