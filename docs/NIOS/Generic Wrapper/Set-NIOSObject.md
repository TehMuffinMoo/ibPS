---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-NIOSObject

## SYNOPSIS
Generic Wrapper function for updating objects using the NIOS WAPI

## SYNTAX

### Object
```
Set-NIOSObject -Object <PSObject> [-Fields <String[]>] [-AllFields] [-BaseFields] [-Server <String>]
 [-GridUID <String>] [-GridName <String>] [-ApiVersion <String>] [-SkipCertificateCheck]
 [-Creds <PSCredential>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Ref
```
Set-NIOSObject -ObjectRef <String> -TemplateObject <PSObject> [-Fields <String[]>] [-AllFields] [-BaseFields]
 [-Server <String>] [-GridUID <String>] [-GridName <String>] [-ApiVersion <String>] [-SkipCertificateCheck]
 [-Creds <PSCredential>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Generic Wrapper function for updating objects using the NIOS WAPI, either directly or via Universal DDI Federation

## EXAMPLES

### EXAMPLE 1
```powershell
@{
    name = 'my.example.com'
    ipv4addr = '172.25.22.12'
    comment = 'My A Record'
} | New-NIOSObject -ObjectType 'record:a'

record:a/ZG5zLmJpbmRfYSQuX2RlZmF1bHQuY29tLmV4YW1wbGUsbXksMTcyLjI1LjIyLjEy:my.example.com/default
```

## PARAMETERS

### -Object
Specify the Infoblox Object to update.
Accepts pipeline input.

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
Specify the object _ref to update.

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

### -TemplateObject
Specify the Infoblox Object template to use when updating the NIOS object(s).

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

### -Fields
A string array of fields to return in the response.
This field supports tab completion.

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

### -AllFields
Using the -AllFields switch will return all available fields in the response.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ReturnAllFields

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BaseFields
Using the -BaseFields switch will return the base fields in addition to those selected in -Fields.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ReturnBaseFields

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
Specify the NIOS Grid Manager IP or FQDN to use

This parameter can be ommitted if the Server is stored by using Set-NIOSConnectionProfile

This is used only when connecting to NIOS directly.

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
Specify the NIOS Grid UID (license_uid).
This indicates which Grid to connect to when using NIOS Federation within Universal DDI.

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

### -GridName
Specify the NIOS Grid Name in Universal DDI DDI instead of the GridUID.
This is convient, but requires resolving the license_uid on every API Call.

This parameter can be ommitted if the Federated Grid has been stored by using Set-NIOSConnectionProfile

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

### -ApiVersion
The version of the NIOS API to use (WAPI)

This parameter can be ommitted if the API Version is stored by using Set-NIOSConnectionProfile

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
If this parameter is set, SSL Certificates Checks will be ignored.

This parameter can be ommitted if the configuration has been stored by using Set-NIOSConnectionProfile

This is used only when connecting to NIOS directly.

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

### -Creds
The creds parameter can be used to specify credentials as part of the command.

This parameter can be ommitted if the Credentials are stored by using Set-NIOSConnectionProfile

This is used only when connecting to NIOS directly.

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

### -Force
Perform the operation without prompting for confirmation.
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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
