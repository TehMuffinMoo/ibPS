---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1DTCHealthCheck

## SYNOPSIS
Updates a health check object within BloxOne DTC

## SYNTAX

### Default
```
Set-B1DTCHealthCheck -Name <String> [-NewName <String>] [-Description <String>] [-Interval <Int32>]
 [-Timeout <Int32>] [-RetryUp <Int32>] [-RetryDown <Int32>] [-State <String>] [-Port <Int32>]
 [-UseHTTPS <String>] [-HTTPRequest <String>] [-ResponseBody <String>] [-ResponseBodyRegex <String>]
 [-ResponseHeader <String>] [-ResponseHeaderRegexes <Object>] [-StatusCodes <Nullable`1[]>] [-Tags <Object>]
 [<CommonParameters>]
```

### With ID
```
Set-B1DTCHealthCheck [-NewName <String>] [-Description <String>] [-Interval <Int32>] [-Timeout <Int32>]
 [-RetryUp <Int32>] [-RetryDown <Int32>] [-State <String>] [-Port <Int32>] [-UseHTTPS <String>]
 [-HTTPRequest <String>] [-ResponseBody <String>] [-ResponseBodyRegex <String>] [-ResponseHeader <String>]
 [-ResponseHeaderRegexes <Object>] [-StatusCodes <Nullable`1[]>] [-Tags <Object>] -Object <Object>
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to update a health check object within BloxOne DTC

## EXAMPLES

### EXAMPLE 1
```powershell
$HeaderRegexes = @(
    @{
        'header' = 'X-A-Header'
        'regex' = '(/w/s/w+)'
    }
    @{
        'header' = 'X-Hello-Header'
        'regex' = '(.*)'
    }
)
Get-B1DTCHealthCheck -Name 'Exchange HTTPS Check' | Set-B1DTCHealthCheck -ResponseBody Found -ResponseBodyRegex '(.*)' `
                                                    -ResponseHeader NotFound -ResponseHeaderRegexes $HeaderRegexes

id                             : dtc/health_check_http/0fsdfef-34fg-dfvr-9dxf-svev4vgv21d9
name                           : Exchange HTTPS Check
comment                        : 
disabled                       : False
interval                       : 15
timeout                        : 10
retry_up                       : 1
retry_down                     : 1
tags                           : 
port                           : 443
https                          : True
request                        : GET /owa/auth/logon.aspx HTTP/1.1
                                 Host: webmail.company.corp
codes                          : 
metadata                       : 
check_response_body            : True
check_response_body_regex      : (.*)
check_response_body_negative   : False
check_response_header          : True
check_response_header_regexes  : {@{header=X-A-Header; regex=(/w/s/w+)}, @{header=X-Hello-Header; regex=(.*)}}
check_response_header_negative : True
```

## PARAMETERS

### -Name
The name of the DTC health check object to update

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Use -NewName to update the name of the DTC health check object

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

### -Description
The new description for the health check object

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

### -Interval
Update the frequency in seconds in which the health check is performed.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Update the number of seconds before the health check times out.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RetryUp
Update how many retry attempts before reporting a Healthy status.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RetryDown
Update how many retry attempts before reporting a Down status.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Update the state of the health check to enabled or disabled.

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

### -Port
The -Port parameter is used only when updating the port on TCP or HTTP Health Checks.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseHTTPS
The -UseHTTPS parameter is used when selecting Use HTTPS in a HTTP Health Check

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

### -HTTPRequest
The -HTTPRequest parameter is the HTTP Request that a HTTP Health Check will make when checking status.
This accepts multi-line strings if separated by \`n

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

### -ResponseBody
The -ResponseBody parameter is used to indicate if to check the body response content.
This should be used in combination with -ResponseBodyRegex

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

### -ResponseBodyRegex
The -ResponseBodyRegex parameter is used to specify the regex used when checking the body of the response

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

### -ResponseHeader
The -ResponseHeader parameter is used to indicate if to check the header response content.
This should be used in combination with -ResponseHeaderRegex

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

### -ResponseHeaderRegexes
The -ResponseHeaderRegex parameter is used to provide a list of regular expressions when checking specific response headers.
See examples for usage.

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

### -StatusCodes
The -StatusCodes parameter is used to specify which status codes are accepted to report a healthy status when using HTTP Health Checks.
Use a zero ( 0 ) to select Status Codes 'any'

```yaml
Type: Nullable`1[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Any tags you want to apply to the DTC health check

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

### -Object
The DTC Health Check Object(s) to update.
Accepts pipeline input.

```yaml
Type: Object
Parameter Sets: With ID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
