---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1BypassCode

## SYNOPSIS
Removes a bypass code from BloxOne Cloud

## SYNTAX

### Default
```
Remove-B1BypassCode -Name <String> [<CommonParameters>]
```

### Pipeline
```
Remove-B1BypassCode -Access_Key <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a bypass code from BloxOne Cloud

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1BypassCode -Name 'My Bypass Code' | Remove-B1BypassCode

Successfully deleted Bypass Code: My Bypass Code
```

## PARAMETERS

### -Name
The name of the bypass code to remove

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

### -Access_Key
The Access Key of the bypass code to remove.
Accepts pipeline input from Get-B1BypassCode

```yaml
Type: Object
Parameter Sets: Pipeline
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
