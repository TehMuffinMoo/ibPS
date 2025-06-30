---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-NIOSSchema

## SYNOPSIS
Generic Wrapper function for retrieving schema information from the NIOS WAPI

## SYNTAX

```
Get-NIOSSchema [[-ObjectType] <String>] [-Fields] [[-Method] <WebRequestMethod>] [[-Server] <String>]
 [[-GridUID] <String>] [[-GridName] <String>] [[-ApiVersion] <String>] [-SkipCertificateCheck]
 [[-Creds] <PSCredential>]
```

## DESCRIPTION
Generic Wrapper function for retrieving schema information from the NIOS WAPI, either directly or via Universal DDI Federation

## EXAMPLES

### EXAMPLE 1
```powershell
Get-NIOSSchema

requested_version supported_objects                                    supported_versions
----------------- -----------------                                    ------------------
2.12              {ad_auth_service, admingroup, adminrole, adminuser…} {1.0, 1.1, 1.2, 1.2.1…}
```

### EXAMPLE 2
```powershell
Get-NIOSSchema -ObjectType dtc:lbdn

cloud_additional_restrictions : {all}
fields                        : {@{is_array=True; name=auth_zones; standard_field=False; supports=rwu; type=System.Object[]}, @{is_array=False; name=auto_consolidated_monitors; standard_field=False; supports=rwu; type=System.Object[]}, @{is_array=False; name=comment; searchable_by=:=~;
                                standard_field=True; supports=rwus; type=System.Object[]}, @{is_array=False; name=disable; standard_field=False; supports=rwu; type=System.Object[]}…}
restrictions                  : {csv}
type                          : dtc:lbdn
version                       : 2.12
```

### EXAMPLE 3
```powershell
Get-NIOSSchema -ObjectType dtc:lbdn -Fields | ft -AutoSize

is_array name                       standard_field supports type
-------- ----                       -------------- -------- ----
True auth_zones                              False rwu      {zone_auth}
False auto_consolidated_monitors             False rwu      {bool}
False comment                                True  rwus     {string}
False disable                                False rwu      {bool}
False extattrs                               False rwu      {extattr}
False health                                 False r        {dtc:health}
False lb_method                              False rwu      {enum}
False name                                   True  rwus     {string}
True patterns                                False rwu      {string}
False persistence                            False rwu      {uint}
True pools                                   False rwu      {dtc:pool:link}
False priority                               False rwu      {uint}
False topology                               False rwu      {string}
False ttl                                    False rwu      {uint}
True types                                   False rwu      {enum}
False use_ttl                                False rwu      {bool}
```

## PARAMETERS

### -ObjectType
Specify the object type to retrieve schema information for.
This field supports tab completion.

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

### -Fields
A string array of fields to return in the response.
This field supports tab completion.

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

### -Method
If -Method is specified, only fields which support the selected method will be returned.

```yaml
Type: WebRequestMethod
Parameter Sets: (All)
Aliases:
Accepted values: Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

Required: False
Position: 2
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
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
