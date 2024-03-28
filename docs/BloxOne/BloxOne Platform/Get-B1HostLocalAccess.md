---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1HostLocalAccess

## SYNOPSIS
Checks the Bootstrap UI Local Access status for the given BloxOne Host

## SYNTAX

### Default
```
Get-B1HostLocalAccess -B1Host <String> [<CommonParameters>]
```

### Pipeline
```
Get-B1HostLocalAccess -OPH <PSObject[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to check the Bootstrap UI Local Access status for the given BloxOne Host

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1HostLocalAccess -B1Host "my-host-1"

enabled  time_left    period     B1Host
-------  ---------    ------     ------
True     1h 53m 46s   2h 0m 0s   my-host-1
```

### EXAMPLE 2
```powershell
Get-B1Host | Get-B1HostLocalAccess

time_left   period       enabled   B1Host
---------   ------       -------   ------
1h 53m 42s  2h 0m 0s     True      my-host-1
0h 0m 0s    2h 0m 0s     False     my-host-2
0h 0m 0s    2h 0m 0s     False     my-host-3
0h 0m 0s    2h 0m 0s     False     my-host-4
...
```

## PARAMETERS

### -B1Host
{{ Fill B1Host Description }}

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

### -OPH
{{ Fill OPH Description }}

```yaml
Type: PSObject[]
Parameter Sets: Pipeline
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
