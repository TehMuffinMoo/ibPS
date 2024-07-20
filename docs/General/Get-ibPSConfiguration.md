---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-ibPSConfiguration

## SYNOPSIS
Used to get the current configuration for ibPS

## SYNTAX

```
Get-ibPSConfiguration [-IncludeAPIKey] [-Details] [<CommonParameters>]
```

## DESCRIPTION
This function is used to get the current configuration for ibPS

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ibPSConfiguration

CSP Url          : https://csp.infoblox.com
CSP API User     : svc-csp
CSP Account      : ACME Corp
CSP API Key      : ********
ibPS Version     : 1.9.4.4
ibPS Branch      : main
Debug Mode       : Disabled
Development Mode : Disabled
```

## PARAMETERS

### -IncludeAPIKey
The -IncludeAPIKey indicates whether the API Key should be returned in the response

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

### -Details
The -Details parameter optionally includes the Build Version, Github Commit SHA & Module Location in the response

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
