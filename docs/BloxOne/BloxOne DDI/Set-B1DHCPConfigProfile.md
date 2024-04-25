---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1DHCPConfigProfile

## SYNOPSIS
Updates an existing DHCP Config Profiles from BloxOneDDI

## SYNTAX

### Default
```
Set-B1DHCPConfigProfile -Name <String> [-AddDDNSZones] [-RemoveDDNSZones] [-DDNSZones <Object>]
 -DNSView <String> [-Tags <Object>] [<CommonParameters>]
```

### With ID
```
Set-B1DHCPConfigProfile [-AddDDNSZones] [-RemoveDDNSZones] [-DDNSZones <Object>] -DNSView <String>
 [-Tags <Object>] -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing DHCP Config Profiles from BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1DHCPConfigProfile -Name 'Data Centre DHCP' -AddDDNSZones -DDNSZones 'company.corp' -DNSView default

Overriding Global DHCP Properties for DHCP Config Profile: Data Centre DHCP..
company.corp added successfully to DDNS Config for the DHCP Config Profile: Data Centre DHCP
```

## PARAMETERS

### -Name
The name of the DHCP Config Profile

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

### -AddDDNSZones
This switch determines if you want to add DDNS Zones using the -DDNSZones parameter

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
This switch determines if you want to remove DDNS Zones using the -DDNSZones parameter

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
Provide a list of DDNS Zones to add or remove to/from the the DHCP Config Profile.

This is to be used in conjunction with -AddDDNSZones and -RemoveDDNSZones respectively.

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

### -DNSView
The DNS View the Authoritative DDNS Zones are located in

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

### -Tags
The tags to apply to the DHCP Config Profile

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
The id of the DHCP config profile to update.
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
