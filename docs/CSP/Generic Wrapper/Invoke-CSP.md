---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Invoke-CSP

## SYNOPSIS
Queries the Universal DDI Cloud Services Portal

## SYNTAX

```
Invoke-CSP [-Method] <String> [-Uri] <String> [-Data] <String> [-InFile] <String> [-ContentType] <String> [<CommonParameters>]
```

## DESCRIPTION
This is a core function used by all cmdlets when querying the CSP (Cloud Services Portal), required when interacting with the  Infoblox Portal APIs.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/record?_limit=10"
```

### EXAMPLE 2
```powershell
Invoke-CSP -Method GET -Uri "ipam/subnet?_filter=address==`"10.10.10.10`""
```

### EXAMPLE 3
```powershell
Invoke-CSP -Method DELETE -Uri "dns/record/abc16def-a125-423a-3a42-dcv6f6c4dj8x"
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

### -Uri
Specify the Uri, such as "ipam/record", you can also use the full URL and http parameters must be appended here. If the full URL is not used, the default base path is `https://<CSPUrl>/api/ddi/v1`

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

### -InFile
File path of data to submit as part of POST request

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

### -ContentType
The Content-Type header to be passed in requests. Defaults to 'application/json'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: application/json
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
