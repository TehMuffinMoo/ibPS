---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DTCStatus

## SYNOPSIS
Retrieves a list of Universal DDI DTC LBDNs

## SYNTAX

### None
```
Get-B1DTCStatus -LBDN <String> [-Raw] [<CommonParameters>]
```

### With ID
```
Get-B1DTCStatus [-Raw] -id <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of Universal DDI DTC LBDNs

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DTCLBDN -Name 'email.domain.corp' | Get-B1DTCStatus

[LBDN]  email.domain.corp
  [Policy]  Exchange
    [B1Host]  B1-1
      [Pool]  HEALTHY: Exchange
        [Server]  HEALTHY: EXCHANGE-MAIL01
          [HealthCheck]  HEALTHY: Exchange-HTTPS - 04/16/2024 08:25:15
          [HealthCheck]  HEALTHY: ICMP Health Check - 04/16/2024 08:24:45
        [Server]  HEALTHY: EXCHANGE-MAIL02
          [HealthCheck]  HEALTHY: Exchange-HTTPS - 04/16/2024 08:25:10
          [HealthCheck]  HEALTHY: ICMP Health Check - 04/16/2024 08:24:38
  [Policy]  Exchange
    [B1Host]  B1-2
      [Pool]  HEALTHY: Exchange
        [Server]  HEALTHY: EXCHANGE-MAIL01
          [HealthCheck]  HEALTHY: Exchange-HTTPS - 04/16/2024 08:25:08
          [HealthCheck]  HEALTHY: ICMP Health Check - 04/16/2024 08:25:16
        [Server]  HEALTHY: EXCHANGE-MAIL02
          [HealthCheck]  HEALTHY: Exchange-HTTPS - 04/16/2024 08:25:13
          [HealthCheck]  HEALTHY: ICMP Health Check - 04/16/2024 08:25:08
```

## PARAMETERS

### -LBDN
The name of the DTC LBDN to get the status for

```yaml
Type: String
Parameter Sets: None
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
This switch indicates whether to return raw or parsed results.
The default is parsed (-Raw:$false)

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

### -id
The id of the DTC LBDN to get the status for.
Accepts pipeline input from Get-B1DTCLBDN

```yaml
Type: String[]
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
