---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Start-B1DiagnosticTask

## SYNOPSIS
Initiates a NIOS-X Diagnostic Task

## SYNTAX

### traceroute
```
Start-B1DiagnosticTask [-B1Host <String>] [-Traceroute] -Target <String> [-Port <String>]
 [-WaitForOutput <Boolean>] [-Object <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### dnstest
```
Start-B1DiagnosticTask [-B1Host <String>] [-DNSTest] -FQDN <String> [-WaitForOutput <Boolean>]
 [-Object <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ntptest
```
Start-B1DiagnosticTask [-B1Host <String>] [-NTPTest] [-WaitForOutput <Boolean>] [-Object <Object>] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### dnsconf
```
Start-B1DiagnosticTask [-B1Host <String>] [-DNSConfiguration] [-WaitForOutput <Boolean>] [-Object <Object>]
 [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### dhcpconf
```
Start-B1DiagnosticTask [-B1Host <String>] [-DHCPConfiguration] [-WaitForOutput <Boolean>] [-Object <Object>]
 [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to initiate a NIOS-X Diagnostic Task

## EXAMPLES

### EXAMPLE 1
```powershell
Start-B1DiagnosticTask -DNSTest -FQDN "google.com"
```

### EXAMPLE 2
```powershell
Start-B1DiagnosticTask -DHCPConfiguration
```

## PARAMETERS

### -B1Host
The name/fqdn of the NIOS-X Host to run the task against

```yaml
Type: String
Parameter Sets: (All)
Aliases: OnPremHost

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Traceroute
This switch indicates you want to use the traceroute test

```yaml
Type: SwitchParameter
Parameter Sets: traceroute
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSTest
This switch indicates you want to use the dns test

```yaml
Type: SwitchParameter
Parameter Sets: dnstest
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NTPTest
This switch indicates you want to use the ntp test

```yaml
Type: SwitchParameter
Parameter Sets: ntptest
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSConfiguration
This switch indicates you want to return the DNS Configuration file

```yaml
Type: SwitchParameter
Parameter Sets: dnsconf
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DHCPConfiguration
This switch indicates you want to return the DHCP Configuration file

```yaml
Type: SwitchParameter
Parameter Sets: dhcpconf
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
This is used as the target for the traceroute test

```yaml
Type: String
Parameter Sets: traceroute
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
This is used as the port for the traceroute test

```yaml
Type: String
Parameter Sets: traceroute
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FQDN
This is used as the fqdn for the dns test

```yaml
Type: String
Parameter Sets: dnstest
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WaitForOutput
Indicates whether the function should wait for results to be returned from the diagnostic task, or start it in the background only.
This defaults to $true

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
The NIOS-X Host Object(s) to run the diagnostic task on.
Accepts pipeline input

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
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
