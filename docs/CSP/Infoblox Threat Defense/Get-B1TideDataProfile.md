---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TideDataProfile

## SYNOPSIS
Queries a list of TIDE Data Profiles

## SYNTAX

```
Get-B1TideDataProfile [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of TIDE Data Profiles

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TideDataProfiles -Name "My Profile"
```

### EXAMPLE 2
```powershell
Get-B1TideDataProfile | ft -AutoSize

id                                           name                      description                  policy      default_ttl active rpzfeedname
--                                           ----                      -----------                  ------      ----------- ------ -----------
0014B00014BaC3hQKF:AntiMalware-Profile       AntiMalware-Profile       AntiMalware - Data Profile   default-csp        True   True amfeed
0014B00014BaC3hQKF:KnownBad-Profile          KnownBad-Profile          Known Bad - Data Profile     default-csp        True   True kbfeed
0014B00014BaC3hQKF:Test-Profile              Test-Profile              Test - Data Profile          default-csp        True  False tsfeed
0014B00014BaC3hQKF:Secure-Profile            Secure-Profile            Secure - Data Profile        default-csp        True   True scfeed
...
```

## PARAMETERS

### -Name
Use this parameter to filter by Name.
Supports tab-completion.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
