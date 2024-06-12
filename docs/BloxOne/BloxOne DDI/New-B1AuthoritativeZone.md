---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1AuthoritativeZone

## SYNOPSIS
Creates a new Authoritative Zone in BloxOneDDI

## SYNTAX

```
New-B1AuthoritativeZone [-Type] <String> [-FQDN] <String> [-View] <Object> [[-DNSHosts] <Object>]
 [[-AuthNSGs] <Object>] [[-DNSACL] <String>] [[-Description] <String>] [[-NotifyExternalSecondaries] <String>]
 [[-Compartment] <String>] [[-Tags] <Object>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new Authoritative Zone in BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1AuthoritativeZone -Type Primary -FQDN "mysubzone.mycompany.corp" -View "default" -AuthNSGs "Data Centre" -Description "My Subzone"
```

## PARAMETERS

### -Type
The type of authoritative zone to create (Primary / Secondary)

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

### -FQDN
The FQDN of the zone to create

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

### -View
The DNS View the zone will be created in

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

### -DNSHosts
A list of DNS Hosts to assign to the zone

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthNSGs
A list of Authoritative DNS Server Groups to assign to the zone

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

### -DNSACL
The DNS ACL to assign to the zone for zone transfers

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NotifyExternalSecondaries
Toggle whether to notify external secondary DNS Servers for this zone.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Compartment
The name of the compartment to assign to this authoritative zone

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Any tags you want to apply to the authoritative zone

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
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
