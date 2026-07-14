---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1ForwardZone

## SYNOPSIS
Updates an existing Forward Zone in Universal DDI

## SYNTAX

### Default
```
Set-B1ForwardZone -FQDN <String> -View <Object> [-Description <String>] [-Forwarders <Object>]
 [-DNSHosts <Object>] [-DNSServerGroups <String>] [-ForwardOnly <String>] [-State <String>] [-Tags <Object>]
 [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Object
```
Set-B1ForwardZone [-Description <String>] [-Forwarders <Object>] [-DNSHosts <Object>]
 [-DNSServerGroups <String>] [-ForwardOnly <String>] [-State <String>] [-Tags <Object>] -Object <Object>
 [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to an existing Forward Zone in Universal DDI

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1ForwardZone -FQDN "mysubzone.mycompany.corp" -View "default" -DNSHosts "ddihost1.corp.mycompany.com" -DNSServerGroups "Data Centre"
```

### EXAMPLE 2
```powershell
Get-B1ForwardZone -FQDN "mysubzone.mycompany.corp" -View "default" | Set-B1ForwardZone -DNSHosts "ddihost1.corp.mycompany.com" -DNSServerGroups "Data Centre"
```

## PARAMETERS

### -FQDN
The FQDN of the zone to update

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

### -View
The DNS View the zone is located in

```yaml
Type: Object
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The new description for the Forward Zone

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

### -Forwarders
A list of IPs/FQDNs to forward requests to.
This will overwrite existing values

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

### -DNSHosts
A list of DNS Hosts to assign to the zone.
This will overwrite existing values

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

### -DNSServerGroups
A list of Forward DNS Server Groups to assign to the zone.
This will overwrite existing values

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

### -ForwardOnly
Toggle the Forwarders Only option for this Forward Zone.

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

### -State
Set whether the Forward Zone is enabled or disabled.

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
Any tags you want to apply to the forward zone

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
The Forward Zone Object to update.
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
