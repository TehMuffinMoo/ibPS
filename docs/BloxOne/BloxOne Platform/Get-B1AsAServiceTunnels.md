---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1AsAServiceTunnels

## SYNOPSIS
Retrieves the connection information of NIOS-X As A Service IPSEC Tunnels

## SYNTAX

### ByService
```
Get-B1AsAServiceTunnels -Service <String> -Location <String> [-ReturnStatus] [<CommonParameters>]
```

### ByServiceID
```
Get-B1AsAServiceTunnels -ServiceID <String> -Location <String> [-ReturnStatus] [<CommonParameters>]
```

## DESCRIPTION
This function is used query the connection information of NIOS-X As A Service IPSEC Tunnels

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1AsAServiceTunnels -Service Production | ft -AutoSize
```

## PARAMETERS

### -Service
{{ Fill Service Description }}

```yaml
Type: String
Parameter Sets: ByService
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceID
{{ Fill ServiceID Description }}

```yaml
Type: String
Parameter Sets: ByServiceID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
{{ Fill Location Description }}

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

### -ReturnStatus
{{ Fill ReturnStatus Description }}

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
