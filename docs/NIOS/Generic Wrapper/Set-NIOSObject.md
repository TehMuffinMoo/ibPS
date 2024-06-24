---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-NIOSObject

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Object
```
Set-NIOSObject -Object <PSObject> [-Fields <String[]>] [-AllFields] [-BaseFields] [-Server <String>]
 [-GridUID <String>] [-GridName <String>] [-ApiVersion <String>] [-SkipCertificateCheck]
 [-Creds <PSCredential>] [<CommonParameters>]
```

### Ref
```
Set-NIOSObject -ObjectRef <String> -TemplateObject <PSObject> [-Fields <String[]>] [-AllFields] [-BaseFields]
 [-Server <String>] [-GridUID <String>] [-GridName <String>] [-ApiVersion <String>] [-SkipCertificateCheck]
 [-Creds <PSCredential>] [<CommonParameters>]
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

### -AllFields
{{ Fill AllFields Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ReturnAllFields

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
{{ Fill ApiVersion Description }}

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

### -BaseFields
{{ Fill BaseFields Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ReturnBaseFields

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Creds
{{ Fill Creds Description }}

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fields
{{ Fill Fields Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: ReturnFields

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GridName
{{ Fill GridName Description }}

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

### -GridUID
{{ Fill GridUID Description }}

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

### -Object
{{ Fill Object Description }}

```yaml
Type: PSObject
Parameter Sets: Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ObjectRef
{{ Fill ObjectRef Description }}

```yaml
Type: String
Parameter Sets: Ref
Aliases: ref, _ref

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Server
{{ Fill Server Description }}

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

### -SkipCertificateCheck
{{ Fill SkipCertificateCheck Description }}

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

### -TemplateObject
{{ Fill TemplateObject Description }}

```yaml
Type: PSObject
Parameter Sets: Ref
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

### System.Management.Automation.PSObject
### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
