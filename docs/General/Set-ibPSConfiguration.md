---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-ibPSConfiguration

## SYNOPSIS
Used to set ibPS specific configuration

## SYNTAX

```
Set-ibPSConfiguration [[-CSPAPIKey] <String>] [[-CSPRegion] <String>] [[-CSPUrl] <String>]
 [[-DoHServer] <String>] [-Persist] [[-DevelopmentMode] <String>] [[-DebugMode] <String>]
 [[-Telemetry] <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to set ibPS specific configuration, such as the Infoblox Portal CSP API Key, Region/URL and enabling/disabling development or debug mode

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ibPSConfiguration -CSPAPIKey 'longapikeygoeshere' -Persist

Universal DDI API key has been stored permanently for user on MAC-DSD984HG
```

### EXAMPLE 2
```powershell
Set-ibPSConfiguration -CSPRegion EU

Universal DDI CSP URL (https://csp.eu.infoblox.com) has been stored for this session.
You can make the CSP URL persistent for this user on this machine by using the -persist parameter.
```

### EXAMPLE 3
```powershell
Set-ibPSConfiguration -DebugMode Enabled -DevelopmentMode Enabled
```

## PARAMETERS

### -CSPAPIKey
This is the Infoblox Portal API Key retrieved from the Cloud Services Portal

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

### -CSPRegion
Optionally configure the the CSP Region to use (i.e EU for the EMEA instance).
The region defaults to US if not defined.
You only need to use -CSPRegion OR -CSPUrl.

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

### -CSPUrl
Optionally configure the the CSP URL to use manually.
The CSP URL defaults to https://csp.infoblox.com if not defined.
You only need to use -CSPUrl OR -CSPRegion.

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

### -DoHServer
Optionally configure the DNS over HTTPS Server to use when calling Resolve-DoHQuery

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

### -Persist
Setting the -Persist parameter will save the configuration permanently for your user on this device.
Without using this switch, the settings will only be saved for the duration of the PowerShell session.

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

### -DevelopmentMode
Enabling development mode will expose additional functions to allow development of new cmdlets.
Enabling development mode will always apply as a persistent setting until it is disabled.
This is because in some cases it may require a restart of the PowerShell session to fully enable.

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

### -DebugMode
Enabling Debug Mode will return additional debug data when using the module. 
Enabling debug mode will always apply as a persistent setting until it is disabled.
This is because in some cases it may require a restart of the PowerShell session to fully enable.

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

### -Telemetry
Disabling Telemetry will prevent the module sending diagnostic information to Google Analytics.
None of the diagnostic information sent contains any sensitive information, only the name of the executed function, any error associated error categories and source platform information (OS/Version).

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

### -Force
Perform the operation without prompting for confirmation.
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

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
