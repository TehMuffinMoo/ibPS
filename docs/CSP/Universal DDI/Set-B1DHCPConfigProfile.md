---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1DHCPConfigProfile

## SYNOPSIS
Updates an existing DHCP Config Profiles from Universal DDI

## SYNTAX

### Default
```
Set-B1DHCPConfigProfile -Name <String> [-NewName <String>] [-Description <String>] [-EnableDDNS <String>]
 [-SendDDNSUpdates <String>] [-DDNSDomain <String>] [-AddDDNSZones] [-RemoveDDNSZones] [-DDNSZones <Object>]
 -DNSView <String> [-Tags <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Object
```
Set-B1DHCPConfigProfile [-NewName <String>] [-Description <String>] [-EnableDDNS <String>]
 [-SendDDNSUpdates <String>] [-DDNSDomain <String>] [-AddDDNSZones] [-RemoveDDNSZones] [-DDNSZones <Object>]
 [-Tags <Object>] -Object <Object> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing DHCP Config Profiles from Universal DDI

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

### -NewName
Use -NewName to update the name of the DHCP Config Profile

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
The new description for the DHCP Config Profile

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

### -EnableDDNS
Enable or Disable the DDNS Service for this DHCP Config Profile

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

### -SendDDNSUpdates
Enable or Disable the sending DDNS Updates for this DHCP Config Profile

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

### -DDNSDomain
The new DDNS Domain for the DHCP Config Profile.
Using the value 'None' will submit an empty DDNS Domain.

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
Parameter Sets: Default
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

### -Object
The DHCP Config Profile Object to update.
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

### -Force
Perform the operation without prompting for confirmation.
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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
