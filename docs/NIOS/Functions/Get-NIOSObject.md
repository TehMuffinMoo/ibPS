---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-NIOSObject

## SYNOPSIS
Generic Wrapper for interaction with the NIOS WAPI

## SYNTAX

```
Get-NIOSObject [-Object] <String> [<CommonParameters>]
```

## DESCRIPTION
This is a Generic Wrapper for interaction with the NIOS WAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Get-NIOSObject 'network?_max_results=1000&_return_as_object=1'
```

## PARAMETERS

### -Object
Specify the object URI / API endpoint and query parameters here

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
