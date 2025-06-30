---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1HealthCheck

## SYNOPSIS
Performs a health check on a NIOS-X Host

## SYNTAX

```
Get-B1HealthCheck [-B1Host] <String> [-Type] <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to perform a health check on a NIOS-X Host

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1HealthCheck -B1Host "B1DDI-01" -Type "ApplicationHealth"

B1Host    : B1DDI-01
DNS       : started
Discovery : started
CDC       : started
AnyCast   : started
DHCP      : started
```

### EXAMPLE 2
```powershell
Get-B1HealthCheck -B1Host "B1DDI" -Type "ApplicationHealth" | ft

B1Host    Discovery AnyCast DHCP    CDC     DNS
------    --------- ------- ----    ---     ---
B1DDI-01  started   started started started started
B1DDI-01            started                 started
```

## PARAMETERS

### -B1Host
The NIOS-X Host name/fqdn

```yaml
Type: String
Parameter Sets: (All)
Aliases: OnPremHost

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of health check to perform

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
