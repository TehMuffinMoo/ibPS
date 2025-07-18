---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-ibPSVersion

## SYNOPSIS
Checks the version of ibPS, with the option to update if a version is available

## SYNTAX

```
Get-ibPSVersion [-Details] [-CheckForUpdates] [-Update] [-Cleanup] [-Force] [<CommonParameters>]
```

## DESCRIPTION
This function is used check the current version of ibPS, with the option to check for updates and update if a version is available

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ibPSVersion
```

### EXAMPLE 2
```powershell
Get-ibPSVersion -CheckForUpdates
```

### EXAMPLE 3
```powershell
Get-ibPSVersion -Update
```

## PARAMETERS

### -Details
This switch will return installation details, such as module location and install type

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

### -CheckForUpdates
This switch indicates you want to check for new versions

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

### -Update
This switch will perform an upgrade if one is available

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

### -Cleanup
This switch will remove all except the latest version of ibPS automatically.
Best to run as Administrator to avoid permissions issues if modules are installed globally.

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

### -Force
This switch will force an update, whether or not one is available

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
