---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1ForwardZone

## SYNOPSIS
Updates an existing Forward Zone in BloxOneDDI

## SYNTAX

### noID
```
Set-B1ForwardZone -FQDN <String> [-Forwarders <Object>] [-DNSHosts <Object>] [-DNSServerGroups <String>]
 -View <Object> [<CommonParameters>]
```

### ID
```
Set-B1ForwardZone [-Forwarders <Object>] [-DNSHosts <Object>] [-DNSServerGroups <String>] -id <String>
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to an existing Forward Zone in BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```
Set-B1ForwardZone -FQDN "mysubzone.mycompany.corp" -View "default" -DNSHosts "mybloxoneddihost1.corp.mycompany.com" -DNSServerGroups "Data Centre"
```

## PARAMETERS

### -FQDN
The FQDN of the zone to update

```yaml
Type: String
Parameter Sets: noID
Aliases:

Required: True
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

### -View
The DNS View the zone is located in

```yaml
Type: Object
Parameter Sets: noID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the forward zone to update.
Accepts pipeline input

```yaml
Type: String
Parameter Sets: ID
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
