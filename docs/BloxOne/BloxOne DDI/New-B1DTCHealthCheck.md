---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1DTCHealthCheck

## SYNOPSIS
Creates a new health check object within BloxOne DTC

## SYNTAX

### ICMP Health Check
```
New-B1DTCHealthCheck [-Name] <String> [[-Description] <String>] [-Type] <String> [[-Interval] <Int32>]
 [[-Timeout] <Int32>] [[-RetryUp] <Int32>] [[-RetryDown] <Int32>] [[-State] <String>] [[-Tags] <Object>]
 [<CommonParameters>]
```

### TCP Health Check
```
New-B1DTCHealthCheck [-Name] <String> [[-Description] <String>] [-Type] <String> [-Port] <Int32> [[-Interval] <Int32>]
 [[-Timeout] <Int32>] [[-RetryUp] <Int32>] [[-RetryDown] <Int32>] [[-State] <String>] [[-Tags] <Object>]
 [<CommonParameters>]
```

### HTTP Health Check
```
New-B1DTCHealthCheck [-Name] <String> [[-Description] <String>] [-Type] <String> [-Port] <Int32> [-UseHTTPS] [-HTTPRequest]
 <String> [[-StatusCodes] <Object>] [-ResponseBody] <String> [-ResponseBodyRegex] <String> [-ResponseHeader] <String> 
 [[-ResponseHeaderRegex] <Object>] [[-Interval] <Int32>] [[-Timeout] <Int32>] [[-RetryUp] <Int32>] [[-RetryDown] <Int32>] [[-State] 
 <String>] [[-Tags] <Object>]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new health check object within BloxOne DTC

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1DTCHealthCheck -Name 'Exchange HTTPS Check' -Type HTTP -UseHTTPS -Port 443 -HTTPRequest "GET /owa/auth/logon.aspx HTTP/1.1`nHost: webmail.company.corp"

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
codes                          : 200,401
metadata                       :
```

### EXAMPLE 2
```
$HeaderRegexes = @(
    @{
        'header' = 'X-Some-Header'
        'regex' = '(.*)'
    }
    @{
        'header' = 'X-Another-Header'
        'regex' = '(.*)'
    }
)
New-B1DTCHealthCheck -Name 'Exchange HTTPS Check' -Type HTTP -UseHTTPS -Port 443 `
                    -HTTPRequest "GET /owa/auth/logon.aspx HTTP/1.1`nHost: webmail.company.corp" `
                    -ResponseBody Found -ResponseBodyRegex '(.*)' `
                    -ResponseHeader Found -ResponseHeaderRegexes $HeaderRegexes

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
check_response_header_regexes  : {@{header=X-Some-Header; regex=(.*)}, @{header=X-Another-Header; regex=(.*)}}
check_response_header_negative : False
```

## PARAMETERS

### -Name
The name of the DTC health check object to create

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

### -Description
The description for the new health check object

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

### -Type
The type of Health Check to create (TCP/ICMP/HTTP(s))

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

### -Interval
The frequency in seconds in which the health check is performed.
Defaults to 15s

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
The number of seconds before the health check times out.
Defaults to 10s

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -RetryUp
How many retry attempts before reporting a Healthy status.
Defaults to 1

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -RetryDown
How many retry attempts before reporting a Down status.
Defaults to 1

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Whether or not the new health check is created as enabled or disabled.
Defaults to enabled

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: Enabled
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
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## DYNAMIC PARAMETERS
### -Port
The -Port parameter is required when creating a HTTP or TCP Health Check.

!!! info
    **This parameter is only available when `-Type` is HTTP or TCP**

```yaml
Type: Int
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseHTTPS
The -UseHTTPS parameter is used to create a HTTPS Health Check, instead of HTTP.

!!! info
    **This parameter is only available when `-Type` is HTTP**

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HTTPRequest
The -HTTPRequest parameter is used to specify the HTTP Request to make during the health check.

!!! info
    **This parameter is only available when `-Type` is HTTP**

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

### -StatusCodes
The -StatusCodes parameter is used to specify the status codes to identify healthy status. This could be `"Any`" or a list of Status Codes

!!! info
    **This parameter is only available when `-Type` is HTTP**

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResponseBody
The -ResponseBody parameter is used to indicate the type of check to perform on the HTTP response body. (Found/Not Found/None)

This is to be used in conjunction with `-ResponseBodyRegex`.

!!! info
    **This parameter is only available when `-Type` is HTTP**

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
The -ResponseBodyRegex parameter is used to specify the regular expression to test against the response body.

This should be used in conjunction with `-ResponseBody` to indicate the expected result.

!!! info
    **This parameter is only available when `-Type` is HTTP**

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
The -ResponseHeader parameter is used to indicate the type of check to perform on one or more response headers. (Found/Not Found/None)

This is to be used in conjunction with `-ResponseHeaderRegex`.

!!! info
    **This parameter is only available when `-Type` is HTTP**

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

### -ResponseHeaderRegex
The -ResponseHeaderRegex parameter is used to specify a list of response headers and the associated regular expression to test against it. See examples for usage.

!!! info
    **This parameter is only available when `-Type` is HTTP**

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
