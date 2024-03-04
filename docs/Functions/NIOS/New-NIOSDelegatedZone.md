---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-NIOSDelegatedZone

## SYNOPSIS
Used to create a new delegated zone within NIOS

## SYNTAX

```
New-NIOSDelegatedZone [[-Server] <String>] [-Hosts] <Object> [-FQDN] <String> [-View] <String>
 [[-Creds] <PSCredential>] [-SkipCertificateCheck] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new delegated zone within NIOS

## EXAMPLES

### EXAMPLE 1
```
New-NIOSDelegatedZone -Server gridmaster.domain.corp -FQDN my-dns.zone -Hosts "1.2.3.4","2.3.4.5"
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

### -Hosts
A list of DNS Hosts to delegate this zone to

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

### -FQDN
The FQDN of the delegated zone to create

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

### -View
The DNS View the delegated zone should be placed in

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

### -Creds
Used when specifying NIOS credentials explicitly, if they have not been pre-defined using Store-NIOSCredentials

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
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
