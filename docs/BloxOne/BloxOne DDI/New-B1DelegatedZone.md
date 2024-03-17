---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1DelegatedZone

## SYNOPSIS
Creates a new Delegated Zone in BloxOneDDI

## SYNTAX

```
New-B1DelegatedZone [-FQDN] <String> [-View] <Object> [-DelegationServers] <Object> [[-Description] <String>]
 [[-Tags] <Object>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new Delegated Zone in BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1DelegatedZone -FQDN "mysubzone.mycompany.corp" -View "default" -Parent "" -Description "My Delegated Zone" -
```

## PARAMETERS

### -FQDN
The FQDN of the delegated zone to create

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -View
The DNS View the zone will be created in

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

### -DelegationServers
A list of IPs/FQDNs to delegate requests to

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description for the new zone

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
{{ Fill Tags Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
