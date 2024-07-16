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
 -View <String> [-Description <String>] [-State <String>] [-NotifyExternalSecondaries <String>]
 [-Compartment <String>] [-Tags <Object>] [<CommonParameters>]
```

### Object
```
Set-B1AuthoritativeZone [-DNSHosts <Object>] [-AddAuthNSGs <Object>] [-RemoveAuthNSGs <Object>]
 [-Description <String>] [-State <String>] [-NotifyExternalSecondaries <String>] [-Compartment <String>]
 [-Tags <Object>] -Object <Object> [<CommonParameters>]
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
Type: String
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

### -State
Set whether the Authoritative Zone is enabled or disabled.

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

### -NotifyExternalSecondaries
Toggle whether to notify external secondary DNS Servers for this zone.

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

### -Compartment
The name of the compartment to assign to this authoritative zone

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

### -Tags
A list of tags to update on the authoritative zone.
This will replace existing tags, so would normally be a combined list of existing and new tags

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

### -Object
The Authoritative Zone Object to update.
Accepts pipeline input

```yaml
Type: Object
Parameter Sets: Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
