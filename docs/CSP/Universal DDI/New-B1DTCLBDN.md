---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1DTCLBDN

## SYNOPSIS
Creates a new LBDN object within Universal DDI DTC

## SYNTAX

```
New-B1DTCLBDN [-Name] <String> [[-Description] <String>] [-DNSView] <String> [[-Policy] <String>]
 [[-Precedence] <Int32>] [[-TTL] <Int32>] [[-State] <String>] [[-Tags] <Object>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new LBDN object within Universal DDI DTC

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1DTCLBDN -Name 'exchange.company.corp' -Description 'Exchange Servers LBDN' -DNSView 'Corporate' -Policy Exchange-Policy -Precedence 100 -TTL 10

id                  : dtc/lbdn/17fgt5ge-g5v5-5yhh-cvbg-dfcwef9f4h8
 name                : exchange.company.corp.
 view                : dns/view/cs8f4833-4c44-4c4v-fgvd-jfggdfsta90
 dtc_policy          : @{policy_id=dtc/policy/vduvr743-vcfr-jh9g-vcr3-fdbsv7bcd7; name=Exchange-Policy}
 precedence          : 100
 comment             : Exchange Servers LBDN
 disabled            : False
 ttl                 : 10
 tags                :
 inheritance_sources :
```

## PARAMETERS

### -Name
The name of the DTC LBDN object to create

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

### -Description
The description for the new LBDN object

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

### -DNSView
The DNS View to assign the new LBDN to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Policy
The Load Balancing Policy to use

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Precedence
The LBDN Precedence value

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -TTL
The TTL to use for the DTC LBDN.
This will override inheritance.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Whether or not the new LBDN is created as enabled or disabled.
Defaults to enabled

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: Enabled
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Any tags you want to apply to the DTC LBDN

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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
