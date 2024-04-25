---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Remove-B1DTCLBDN

## SYNOPSIS
Removes an existing BloxOne DTC LBDN

## SYNTAX

### Default
```
Remove-B1DTCLBDN -Name <String> [<CommonParameters>]
```

### With ID
```
Remove-B1DTCLBDN -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove an existing BloxOne DTC LBDN

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1DTCLBDN -Name "webmail.company.corp."

Successfully removed DTC LBDN: webmail.company.corp.
```

### EXAMPLE 2
```powershell
Get-B1DTCLBDN -Name "webmail.company.corp"| Remove-B1DTCLBDN

Successfully removed DTC LBDN: Exchange-LBDN
```

## PARAMETERS

### -Name
The name of the DTC LBDN to remove (FQDN)

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

### -Object
The DTC LBDN Object(s) to remove.
Accepts pipeline input.

```yaml
Type: Object
Parameter Sets: With ID
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
