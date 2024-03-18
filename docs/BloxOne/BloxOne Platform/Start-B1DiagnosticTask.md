---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version: https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
schema: 2.0.0
---

# Start-B1DiagnosticTask

## SYNOPSIS
Initiates a BloxOneDDI Diagnostic Task

## SYNTAX

### traceroute
```
Start-B1DiagnosticTask [-OnPremHost <String>] [-Traceroute] -Target <String> [-Port <String>] [-WaitForOutput]
 [-id <String>] [<CommonParameters>]
```

### dnstest
```
Start-B1DiagnosticTask [-OnPremHost <String>] [-DNSTest] -FQDN <String> [-WaitForOutput] [-id <String>]
 [<CommonParameters>]
```

### ntptest
```
Start-B1DiagnosticTask [-OnPremHost <String>] [-NTPTest] [-WaitForOutput] [-id <String>] [<CommonParameters>]
```

### dnsconf
```
Start-B1DiagnosticTask [-OnPremHost <String>] [-DNSConfiguration] [-WaitForOutput] [-id <String>]
 [<CommonParameters>]
```

### dhcpconf
```
Start-B1DiagnosticTask [-OnPremHost <String>] [-DHCPConfiguration] [-WaitForOutput] [-id <String>]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to initiate a BloxOneDDI Diagnostic Task

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

### -OnPremHost
The name/fqdn of the BloxOneDDI Host to run the task against

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
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the BloxOneDDI Host to run the diagnostic task on.
Accepts pipeline input

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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
