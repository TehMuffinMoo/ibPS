---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1CSPCurrentUser

## SYNOPSIS
Retrieves the user associated with the current API key

## SYNTAX

### Groups
```
Get-B1CSPCurrentUser [-Groups] [<CommonParameters>]
```

### Account
```
Get-B1CSPCurrentUser [-Account] [<CommonParameters>]
```

### Compartments
```
Get-B1CSPCurrentUser [-Compartments] [<CommonParameters>]
```

## DESCRIPTION
This function will retrieve the user associated with the current API key

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1CSPCurrentUser
```

## PARAMETERS

### -Groups
Using the -Groups switch will return a list of Groups associated with the current user

```yaml
Type: SwitchParameter
Parameter Sets: Groups
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Account
Using the -Account switch will return the account data associated with the current user

```yaml
Type: SwitchParameter
Parameter Sets: Account
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Compartments
Using the -Compartments switch will return a list of Compartments associated with the current user

```yaml
Type: SwitchParameter
Parameter Sets: Compartments
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
