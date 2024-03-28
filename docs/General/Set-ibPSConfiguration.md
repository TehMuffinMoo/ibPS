---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-ibPSConfiguration

## SYNOPSIS
Used to set ibPS specific configuration

## SYNTAX

```
Set-ibPSConfiguration [[-DevelopmentMode] <String>] [[-DebugMode] <String>] [[-Branch] <String>]
```

## DESCRIPTION
This function is used to set ibPS specific configuration, such as enabling development or debug mode

## EXAMPLES

### EXAMPLE 1
```powershell
Set-ibPSConfiguration -DebugMode Enabled
```

### EXAMPLE 2
```powershell
Set-ibPSConfiguration -DevelopmentMode Enabled
```

## PARAMETERS

### -DevelopmentMode
Enabling development mode will expose additional functions to allow development of new cmdlets

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

### -DebugMode
Enabling Debug Mode will return additional debug data when using the module

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

### -Branch
Use the -Branch parameter to select the github branch to update with.
Only works when installed from Github, not from PowerShell Gallery.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
