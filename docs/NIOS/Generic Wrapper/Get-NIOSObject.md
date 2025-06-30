---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-NIOSObject

## SYNOPSIS
Generic Wrapper function for retrieving objects from the NIOS WAPI

## SYNTAX

### Type
```
Get-NIOSObject [-ObjectType] <String> [-Limit <Int32>] [-PageSize <Int32>] [-Filters <Object>]
 [-Fields <String[]>] [-AllFields] [-BaseFields] [-Server <String>] [-GridUID <String>] [-GridName <String>]
 [-ApiVersion <String>] [-SkipCertificateCheck] [-Creds <PSCredential>] [<CommonParameters>]
```

### Ref
```
Get-NIOSObject [-ObjectRef] <String> [-Limit <Int32>] [-PageSize <Int32>] [-Filters <Object>]
 [-Fields <String[]>] [-AllFields] [-BaseFields] [-Server <String>] [-GridUID <String>] [-GridName <String>]
 [-ApiVersion <String>] [-SkipCertificateCheck] [-Creds <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Generic Wrapper function for retrieving objects from the NIOS WAPI, either directly or via Universal DDI Federation

## EXAMPLES

### EXAMPLE 1
```powershell
Get-NIOSObject -ObjectType network -Limit 5

_ref                                                                             comment                          network           network_view
----                                                                             -------                          -------           ------------
network/ZG5zLm5ldHdvcmskMTAuMC4xMC4wLzI0LzA:10.0.10.0/24/Company%201             Lab                              10.0.10.0/24      Company 1
network/ZG5zLm5ldHdvcmskMTI4LjI0Mi45OS4xMjgvMjUvMA:128.242.99.128/25/Company%201 Web DMZ                          128.242.99.128/25 Company 1
network/ZG5zLm5ldHdvcmskMTAuMTAuMC4wLzI0LzA:10.10.0.0/24/Company%201             test                             10.10.0.0/24      Company 1
network/ZG5zLm5ldHdvcmskMTAuMC4xLjAvMjQvMA:10.0.1.0/24/Company%201                                                10.0.1.0/24       Company 1
network/ZG5zLm5ldHdvcmskMTkyLjE2OC4xLjAvMjQvMA:192.168.1.0/24/Company%201        Corporate DC - The Grid + NetMRI 192.168.1.0/24    Company 1
```

## PARAMETERS

### -ObjectType
Specify the object type to retrieve.
This field supports tab completion.

```yaml
Type: String
Parameter Sets: Type
Aliases: type

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjectRef
Specify the object _ref to retrieve.

```yaml
Type: String
Parameter Sets: Ref
Aliases: ref, _ref

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Limit
Specify the number of results to return.
The default limit is 1000.
If a limit higher than 1000 is specified, this will enable paging of results.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Specify the results page size when paging is enabled.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filters
Specify a list of filters to use, this must be one of;

     \[string\]      'network_view=default'
     \[string\[\]\]    'network_view=default','network=10.10.10.0/24'
     \[Hashtable\] @{ 'network_view~'='default' }

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
Specify the NIOS Grid Name in Universal DDI instead of the GridUID.
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
