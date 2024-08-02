---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Invoke-NIOS

## SYNOPSIS
Queries a NIOS Grid Manager via Infoblox WAPI or the BloxOne CSP via NIOS Federation

## SYNTAX

### Local
```
Invoke-NIOS [-Method <WebRequestMethod>] -Server <String> -Uri <String> -ApiVersion <String>
 -Creds <PSCredential> [-Data <String>] [-OutFile <String>] [-SkipCertificateCheck]
 [-AdditionalHeaders <Object>] [<CommonParameters>]
```

### FederatedUID
```
Invoke-NIOS [-Method <WebRequestMethod>] -GridUID <String> -Uri <String> -ApiVersion <String> [-Data <String>]
 [-OutFile <String>] [-AdditionalHeaders <Object>] [<CommonParameters>]
```

### FederatedName
```
Invoke-NIOS [-Method <WebRequestMethod>] -GridName <String> -Uri <String> -ApiVersion <String> [-Data <String>]
 [-OutFile <String>] [-AdditionalHeaders <Object>] [<CommonParameters>]
```

## DESCRIPTION
This is a core function used by all NIOS cmdlets when querying an Infoblox NIOS Grid Manager, required when interacting with the NIOS APIs locally or via BloxOne CSP via NIOS Federation.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-NIOS -Uri "zone_delegated?return_as_object=1"
```

### EXAMPLE 2
```powershell
Invoke-NIOS -Uri "record:a?return_as_object=1" -GridUID 'afjs8fje89hf4fjwsbf9sdvgreg4r'
```

## PARAMETERS

### -Method
Specify the HTTP Method to use.
(Default,Get,Head,Post,Put,Delete,Trace,Options,Merge,Patch)

```yaml
Type: WebRequestMethod
Parameter Sets: (All)
Aliases:
Accepted values: Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

Required: False
Position: Named
Default value: GET
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
Specify the NIOS Grid Manager IP or FQDN to use

This parameter can be ommitted if the Server is stored by using Set-NIOSConnectionProfile

This is used only when connecting to NIOS directly.

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

### -GridUID
Specify the NIOS Grid UID (license_uid).
This indicates which Grid to connect to when using NIOS Federation within BloxOne.

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
Specify the NIOS Grid Name in BloxOne DDI instead of the GridUID.
This is convient, but requires resolving the license_uid on every API Call.

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

### -Uri
Specify the Uri, such as "record:a", you can also use the full URL and http parameters must be appended here.

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

### -ApiVersion
The version of the NIOS API to use (WAPI)

This parameter can be ommitted if the API Version is stored by using Set-NIOSConnectionProfile

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
The creds parameter can be used to specify credentials as part of the command.

This parameter can be ommitted if the Credentials are stored by using New-NIOSConnectionProfile

This is used only when connecting to NIOS directly.

```yaml
Type: PSCredential
Parameter Sets: Local
Aliases: Credentials

Required: True
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutFile
The file path to save downloaded files to.

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
If this parameter is set, SSL Certificates Checks will be ignored

This is used only when connecting to NIOS directly.

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

### -AdditionalHeaders
This parameter can be used to pass additional headers, or override the Content-Type header (defaults to application/json).

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
