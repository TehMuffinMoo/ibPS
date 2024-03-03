---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-NIOSDelegatedZone

## SYNOPSIS
Used to retrieve a list of Delegated Zones from NIOS

## SYNTAX

```
Get-NIOSDelegatedZone [[-Server] <String>] [[-FQDN] <String>] [[-View] <String>] [[-Limit] <Int32>]
 [[-Creds] <PSCredential>] [-SkipCertificateCheck]
```

## DESCRIPTION
This function is used to retrieve a list of Delegated Zones from NIOS

## EXAMPLES

### EXAMPLE 1
```
Get-NIOSDelegatedZone -Server gridmaster.domain.corp -View External -FQDN my-dns.zone
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

### -FQDN
The FQDN of the subzone to filter by

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -View
The DNS View within NIOS where the subzone is located

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

### -Limit
Use this parameter to limit the quantity of results returned.
The default number of results is 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 1000
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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
