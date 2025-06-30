---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Enable-B1HostLocalAccess

## SYNOPSIS
Enables the Bootstrap UI Local Access for the given NIOS-X Host

## SYNTAX

### Typed Credentials B1Host
```
Enable-B1HostLocalAccess -B1Host <String> -Credentials <PSCredential> [-Wait] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Default Credentials B1Host
```
Enable-B1HostLocalAccess -B1Host <String> [-UseDefaultCredentials] [-Wait] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Default Credentials Pipeline
```
Enable-B1HostLocalAccess [-UseDefaultCredentials] [-Wait] -OPH <PSObject[]> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Typed Credentials Pipeline
```
Enable-B1HostLocalAccess -Credentials <PSCredential> [-Wait] -OPH <PSObject[]> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to enable the Bootstrap UI Local Access for the given NIOS-X Host

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Host my-host-1 | Enable-B1HostLocalAccess -UseDefaultCredentials -Wait

Local access enable request successfully sent for: my-host-1
    Checking local access enabled state..
    Local Access Enabled Successfully.
    You can access this by browsing to: https://10.15.23.101

    enabled  time_left    period    B1Host
    -------  ---------    ------    ------
    True     1h 59m 50s   2h 0m 0s  my-host-1
```

### EXAMPLE 2
```powershell
Enable-B1HostLocalAccess -B1Host my-host-1 -UseDefaultCredentials

Local access enable request successfully sent for: my-host-1
```

## PARAMETERS

### -B1Host
The name of the NIOS-X Host to enable local access for

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
The -Credentials parameter allows entering the Local Access credentials required to enable it

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
Using the -Wait parameter will wait and check if the local access is enabled successfully.
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
The NIOS-X Host object to submit a enable local access request for.
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
