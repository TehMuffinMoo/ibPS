---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-NIOSConnectionProfile

## SYNOPSIS
This function is used to create a new connection profiles.
By default, the new profile will be set as active.

## SYNTAX

### Local
```
New-NIOSConnectionProfile -Name <String> -Server <String> -Creds <PSCredential> [-SkipCertificateCheck]
 -APIVersion <String> [-NoSwitchProfile] [<CommonParameters>]
```

### FederatedUID
```
New-NIOSConnectionProfile -Name <String> -APIVersion <String> -GridUID <String> [-NoSwitchProfile]
 [<CommonParameters>]
```

### FederatedName
```
New-NIOSConnectionProfile -Name <String> -APIVersion <String> -GridName <String> [-NoSwitchProfile]
 [<CommonParameters>]
```

## DESCRIPTION
Connection profiles provide a convenient way of saving connection details to local or federated NIOS Grids.

These can easily be switched between by using [`Switch-NIOSConnectionProfile`](NIOS/Profiles/Switch-NIOSConnectionProfile/).

## EXAMPLES

### EXAMPLE 1
```powershell
New-NCP
```

### EXAMPLE 2
```powershell
New-NIOSConnectionProfile
```

## PARAMETERS

### -Name
Specify the name for the new connection profile

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

### -Server
Specify the NIOS Grid Manager IP or FQDN for the new connection profile

Using this parameter will set the connection profile type to Local.

```yaml
Type: String
Parameter Sets: Local
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Creds
Specify the NIOS Grid Manager credentials for the new connection profile

Using this parameter will set the connection profile type to Local.

```yaml
Type: PSCredential
Parameter Sets: Local
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
If this parameter is set, SSL Certificates Checks will be ignored.

Using this parameter will set the connection profile type to Local.

```yaml
Type: SwitchParameter
Parameter Sets: Local
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -APIVersion
The version of the NIOS WAPI to use for the new connection profile.
(i.e 2.12)

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

### -GridUID
Specify the NIOS Grid UID (license_uid) to use for the new connection profile.
This indicates which Grid to connect to when using NIOS Federation within BloxOne.

Using this parameter will set the connection profile type to Federated.

```yaml
Type: String
Parameter Sets: FederatedUID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GridName
Specify the NIOS Grid Name in BloxOne DDI to use for the new connection profile.

Using this parameter will set the connection profile type to Federated.

```yaml
Type: String
Parameter Sets: FederatedName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoSwitchProfile
Do not make this profile active upon creation

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
