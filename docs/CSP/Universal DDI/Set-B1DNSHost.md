---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1DNSHost

## SYNOPSIS
Updates an existing DNS Host

## SYNTAX

### Default
```
Set-B1DNSHost -Name <String> [-DNSConfigProfile <String>] [-DNSName <String>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Object
```
Set-B1DNSHost [-DNSConfigProfile <String>] [-DNSName <String>] -Object <Object> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to updates an existing DNS Host

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1DNSHost -Name "ddihost1.mydomain.corp" -DNSConfigProfile "Data Centre" -DNSName "ddihost1.mydomain.corp"
```

### EXAMPLE 2
```powershell
Get-B1DNSHost -Name "ddihost1.mydomain.corp" | Set-B1DNSHost -DNSConfigProfile "Data Centre" -DNSName "ddihost1.mydomain.corp"
```

## PARAMETERS

### -Name
The name of the Universal DDI DNS Host

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

### -DNSConfigProfile
The name of the DNS Config Profile to apply to the DNS Host.
This will overwrite the existing value.
Using the value 'None' will remove the DNS Config Profile from the host.

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

### -DNSName
The DNS FQDN to use for this DNS Server.
This will overwrite the existing value.
Using the value 'None' will remove the DNS Name from the host.

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

### -Object
The DNS Host Object to update.
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
