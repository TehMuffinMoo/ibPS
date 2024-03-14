---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1AuthoritativeZone

## SYNOPSIS
Updates an existing Authoritative Zone in BloxOneDDI

## SYNTAX

### Default
```
Set-B1AuthoritativeZone -FQDN <String> [-DNSHosts <Object>] [-AddAuthNSGs <Object>] [-RemoveAuthNSGs <Object>]
 -View <Object> [-Description <String>] [<CommonParameters>]
```

### With ID
```
Set-B1AuthoritativeZone [-DNSHosts <Object>] [-AddAuthNSGs <Object>] [-RemoveAuthNSGs <Object>]
 [-Description <String>] -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to an existing Authoritative Zone in BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1AuthoritativeZone -FQDN "mysubzone.mycompany.corp" -View "default" -DNSHosts "mybloxoneddihost1.corp.mycompany.com" -AddAuthNSGs "Data Centre"
```

## PARAMETERS

### -FQDN
The FQDN of the zone to update

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

### -AddAuthNSGs
A list of Authoritative DNS Server Groups to add to the zone.

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

### -RemoveAuthNSGs
A list of Authoritative DNS Server Groups to remove from the zone.

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

### -View
The DNS View the zone is located in

```yaml
Type: Object
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description for the zone to be updated to

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

### -id
The id of the authoritative zone to update.
Accepts pipeline input

```yaml
Type: String
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
