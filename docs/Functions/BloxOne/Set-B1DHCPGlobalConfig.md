---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1DHCPGlobalConfig

## SYNOPSIS
Updates the BloxOneDDI Global DHCP Configuration

## SYNTAX

```
Set-B1DHCPGlobalConfig [-AddDDNSZones] [-RemoveDDNSZones] [[-DDNSZones] <Object>] [-DNSView] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update the BloxOneDDI Global DHCP Configuration

## EXAMPLES

### EXAMPLE 1
```
Set-B1DHCPGlobalConfig -AddDDNSZones -DDNSZones "mysubzone.corp.mycompany.com" -DNSView "default"
```

## PARAMETERS

### -AddDDNSZones
Using this switch indicates the zones specified in -DDNSZones are to be added to the Global DHCP Configuration

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

### -RemoveDDNSZones
Using this switch indicates the zones specified in -DDNSZones are to be removed from the Global DHCP Configuration

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

### -DDNSZones
{{ Fill DDNSZones Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSView
The DNS View for applying the configuration to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
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
