---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Copy-NIOSDTCToBloxOne

## SYNOPSIS
Used to migrate LBDNs from NIOS DTC to BloxOne DTC

THIS IS STILL A WORK IN PROGRESS, IT IS CURRENTLY UNDERGOING SMOKE TESTING AND HEALTH CHECK/TOPOLOGY RULESET CREATION IS STILL TO BE IMPLEMENTED.

## SYNTAX

```
Copy-NIOSDTCToBloxOne [-NIOSLBDN] <Object> [-B1DNSView] <Object> [[-PolicyName] <String>] [-ApplyChanges]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to automate the migration of Load Balanced DNS Names and associated objects (Pools/Servers/Health Monitors) from NIOS DTC to BloxOne DTC

BloxOne DDI only currently supports Global Availability, Ratio & Toplogy Load Balancing Methods; and TCP, HTTP & ICMP Health Checks.
Unsupported Load Balancing Methods will fail, but unsupported Health Checks will be skipped gracefully.

## EXAMPLES

### EXAMPLE 1
```powershell
Copy-NIOSDTCToBloxOne -B1DNSView 'my-dnsview' -NIOSLBDN 'some-lbdn' -ApplyChanges
```

## PARAMETERS

### -NIOSLBDN
The LBDN Name within NIOS that you would like to migrate to BloxOne DDI.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -B1DNSView
The DNS View within BloxOne DDI in which to assign the new LBDNs to.
The LBDNs will not initialise unless the zone(s) exist within the specified DNS View.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PolicyName
Optionally specify a DTC Policy name.
DTC Policies are new in BloxOne DDI, so by default they will inherit the name of the DTC LBDN if this parameter is not specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplyChanges
Using this switch will apply the changes, otherwise the expected changes will just be displayed.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
