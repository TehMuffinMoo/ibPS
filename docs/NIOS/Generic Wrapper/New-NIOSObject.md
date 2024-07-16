---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-NIOSObject

## SYNOPSIS
Generic Wrapper function for creating new objects from the NIOS WAPI

## SYNTAX

```
New-NIOSObject [-ObjectType] <String> [-Object] <PSObject> [[-Fields] <String[]>] [-AllFields] [-BaseFields]
 [[-Server] <String>] [[-GridUID] <String>] [[-GridName] <String>] [[-ApiVersion] <String>]
 [-SkipCertificateCheck] [[-Creds] <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Generic Wrapper function for creating new objects from the NIOS WAPI, either directly or via BloxOne Federation

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

### -ObjectType
Specify the object type to create.
This field supports tab completion.

```yaml
Type: String
Parameter Sets: (All)
Aliases: type

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
Specify the Infoblox Object template to use when creating the new NIOS object.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
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
Position: 3
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
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GridUID
Specify the NIOS Grid UID (license_uid).
This indicates which Grid to connect to when using NIOS Federation within BloxOne.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GridName
Specify the NIOS Grid Name in BloxOne DDI instead of the GridUID.
This is convient, but requires resolving the license_uid on every API Call.

This parameter can be ommitted if the Federated Grid has been stored by using Set-NIOSConnectionProfile

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

### -ApiVersion
The version of the NIOS API to use (WAPI)

This parameter can be ommitted if the API Version is stored by using Set-NIOSConnectionProfile

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
Position: 8
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
