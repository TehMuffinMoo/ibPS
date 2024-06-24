---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-NIOSConnectionProfile

## SYNOPSIS
{{ Fill in the Synopsis }}

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
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -APIVersion
{{ Fill APIVersion Description }}

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

### -Creds
{{ Fill Creds Description }}

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

### -GridName
{{ Fill GridName Description }}

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

### -GridUID
{{ Fill GridUID Description }}

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

### -Name
{{ Fill Name Description }}

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

### -NoSwitchProfile
{{ Fill NoSwitchProfile Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
{{ Fill Server Description }}

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

### -SkipCertificateCheck
{{ Fill SkipCertificateCheck Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Local
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
