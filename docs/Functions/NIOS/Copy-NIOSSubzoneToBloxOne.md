---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Copy-NIOSSubzoneToBloxOne

## SYNOPSIS
Used to copy/migrate Authoritative Zone data from NIOS to BloxOneDDI

## SYNTAX

```
Copy-NIOSSubzoneToBloxOne [[-Server] <String>] [-Subzone] <String> [-NIOSView] <String> [-B1View] <String>
 [[-RecordTypes] <String[]>] [[-Confirm] <Boolean>] [-IncludeDHCP] [-Test] [-CreateZones]
 [[-DNSHosts] <Object>] [[-AuthNSGs] <Object>] [[-Creds] <PSCredential>] [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to copy/migrate Authoritative Zone data from NIOS to BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```
Copy-NIOSSubzoneToBloxOne -Server gridmaster.domain.corp -Subzone my-dns.zone -NIOSView External -B1View my-b1dnsview -Test
```

### EXAMPLE 2
```
Copy-NIOSSubzoneToBloxOne -Server gridmaster.domain.corp -Subzone my-dns.zone -NIOSView External -B1View my-b1dnsview -Confirm:$false
```

### EXAMPLE 3
```
Copy-NIOSSubzoneToBloxOne -Server gridmaster.domain.corp -Subzone my-dns.zone -NIOSView External -B1View my-b1dnsview -CreateZones -AuthNSGs "Core DNS Group"
```

## PARAMETERS

### -Server
The NIOS Grid Master FQDN

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subzone
The name of the subzone to copy/migrate

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

### -NIOSView
The DNS View within NIOS where the subzone is located

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -B1View
The DNS View within BloxOne where the subzone is to be copied/migrated to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecordTypes
A list of one or more record types to copy.
If not specified, all supported record types will be copied.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Set this parameter to false to ignore confirmation prompts

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeDHCP
Use this option to include DHCP addresses when copying/migrating the subzone.
This is not recommended as these records will be created as static A records, not dynamic.

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

### -Test
Specify -Test to verify what will be created, without actually creating it

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

### -CreateZones
Use the -CreateZones parameter to indicate if missing zones should be first created in BloxOne.
This required either -DNSHosts or -AuthNSGs to be specified.

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

### -DNSHosts
Used in combination with -CreateZones to specify which DNS Host(s) the zone should be assigned to.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthNSGs
Used in combination with -CreateZones to specify which Authoriative Name Server Group(s) the zone should be assigned to.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Creds
Used when specifying NIOS credentials explicitly, if they have not been pre-defined using Store-NIOSCredentials

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
If this parameter is set, SSL Certificates Checks will be ignored

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
