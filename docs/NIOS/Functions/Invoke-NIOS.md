---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Invoke-NIOS

## SYNOPSIS
Queries a NIOS Grid Manager via Infoblox WAPI

## SYNTAX

```
Invoke-NIOS [-Method] <String> [-Server] <String> [-Uri] <String> [-ApiVersion] <String> [-Creds] <PSCredential> [-Data] <String> [-SkipCertificateCheck] <Switch> [<CommonParameters>]
```

## DESCRIPTION
This is a core function used by all NIOS cmdlets when querying an Infoblox NIOS Grid Manager, required when interacting with the NIOS APIs.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-NIOS -Method GET -Uri "zone_auth?_return_as_object=1&_max_results=10"
```

### EXAMPLE 2
```powershell
Invoke-NIOS -Method GET -Uri "record:a?_return_as_object=1&_max_results=10"
```

## PARAMETERS

### -Method
Specify the HTTP Method to use

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
Specify the NIOS Grid Manager IP or FQDN to use  
This parameter can be ommitted if the Server is stored by using Set-NIOSConfiguration

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

### -Uri
Specify the Uri, such as "record:a", you can also use the full URL and http parameters must be appended here.

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

### -ApiVersion
The version of the NIOS API to use (WAPI)  
This parameter can be ommitted if the API Version is stored by using Set-NIOSConfiguration

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

### -ApiVersion
The creds parameter can be used to specify credentials as part of the command.  
This parameter can be ommitted if the Credentials are stored by using Set-NIOSCredentials

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Data
Data to be submitted on POST/PUT/PATCH/DELETE requests

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

### -SkipCertificateCheck
If this parameter is set, SSL Certificates Checks will be ignored

```yaml
Type: Switch
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
