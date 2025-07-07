---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Disable-B1LookalikeTargetCandidate

## SYNOPSIS
Disables a lookalike from the Common Watched Domains list

## SYNTAX

```
Disable-B1LookalikeTargetCandidate [-Domain] <String[]> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to disable a lookalike from the Common Watched Domains list

## EXAMPLES

### EXAMPLE 1
```powershell
Disable-B1LookalikeTargetCandidate -Domain "adobe.com","airbnb.com"

Successfully disabled lookalike candidate: adobe.com
Successfully disabled lookalike candidate: airbnb.com
```

### EXAMPLE 2
```powershell
Disable-B1LookalikeTargetCandidate -Domain <TabComplete>

accuweather.com        barclays.co.uk         craigslist.org         googledoc.com          microsoft.com          tripadvisor.com
active.aero            blackberry.com         cyber.mil.pl           googledocs.com         microsoftonline.com    tumblr.com
adobe.com              blogger.com            dropbox.com            googledrive.com        mozilla.org            twitch.tv
...
```

## PARAMETERS

### -Domain
One or more common watched domain to disable

This parameter auto-completes based on the current list of enabled domains

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Perform the operation without prompting for confirmation.
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

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
