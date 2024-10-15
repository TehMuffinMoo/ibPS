---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Disable-B1HostLocalAccess

## SYNOPSIS
Disabled the Bootstrap UI Local Access for the given BloxOne Host

## SYNTAX

### Typed Credentials B1Host
```
Disable-B1HostLocalAccess -B1Host <String> -Credentials <PSCredential> [-Wait] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Default Credentials B1Host
```
Disable-B1HostLocalAccess -B1Host <String> [-UseDefaultCredentials] [-Wait] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Default Credentials Pipeline
```
Disable-B1HostLocalAccess [-UseDefaultCredentials] [-Wait] -OPH <PSObject[]> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Typed Credentials Pipeline
```
Disable-B1HostLocalAccess -Credentials <PSCredential> [-Wait] -OPH <PSObject[]> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to disable the Bootstrap UI Local Access for the given BloxOne Host

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Host my-host-1 | Disable-B1HostLocalAccess -UseDefaultCredentials -Wait

Local access disable request successfully sent for: my-host-1
    Checking local access disabled state..
    Local Access Disabled Successfully.
```

### EXAMPLE 2
```powershell
Disable-B1HostLocalAccess -B1Host my-host-1 -UseDefaultCredentials

Local access disable request successfully sent for: my-host-1
```

## PARAMETERS

### -B1Host
The name of the BloxOne Host to disable local access for

```yaml
Type: String
Parameter Sets: Typed Credentials B1Host, Default Credentials B1Host
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseDefaultCredentials
Using the -UseDefaultCredentials parameter will attempt to use the default credentials (admin + last 8 characters of serial number)

```yaml
Type: SwitchParameter
Parameter Sets: Default Credentials B1Host, Default Credentials Pipeline
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credentials
The -Credentials parameter allows entering the Local Access credentials required to disable it

```yaml
Type: PSCredential
Parameter Sets: Typed Credentials B1Host, Typed Credentials Pipeline
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
Using the -Wait parameter will wait and check if the local access is disabled successfully.
This can be manually checked using Get-B1HostLocalAccess

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

### -OPH
The BloxOne Host object to submit a disable local access request for.
This accepts pipeline input from Get-B1Host

```yaml
Type: PSObject[]
Parameter Sets: Default Credentials Pipeline, Typed Credentials Pipeline
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Force
Perform the operation without prompting for confirmation.
By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

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
