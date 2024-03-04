---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1CSPUrl

## SYNOPSIS
Sets/updates the BloxOneDDI CSP Url.

## SYNTAX

### Region
```
Set-B1CSPUrl [-Region <String>] [-Persist] [<CommonParameters>]
```

### URL
```
Set-B1CSPUrl [-URL <String>] [-Persist] [<CommonParameters>]
```

## DESCRIPTION
This function will set/update the BloxOneDDI CSP Url.
This is used when using an alternate CSP Region (i.e EU)

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1CSPUrl -Region EU
                                                                                                          
BloxOne CSP URL (https://csp.eu.infoblox.com) has been stored for this session.
You can make the CSP URL persistent for this user on this machine by using the -persist parameter.
```

### EXAMPLE 2
```powershell
Set-B1CSPUrl -Region EU -Persist

BloxOne CSP URL (https://csp.eu.infoblox.com) has been stored permenantly for user on computername.
```

## PARAMETERS

### -Region
Specify the CSP Region to use (i.e EU for the EMEA instance)

```yaml
Type: String
Parameter Sets: Region
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -URL
Optionally specify a URL manually

```yaml
Type: String
Parameter Sets: URL
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Persist
{{ Fill Persist Description }}

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
