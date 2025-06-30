---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1DTCLBDN

## SYNOPSIS
Updates a LBDN object within Universal DDI DTC

## SYNTAX

### Default (Default)
```
Set-B1DTCLBDN -Name <String> [-NewName <String>] [-Description <String>] [-DNSView <String>] [-Policy <String>]
 [-Precedence <Int32>] [-TTL <Int32>] [-State <String>] [-Tags <Object>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### With ID
```
Set-B1DTCLBDN [-NewName <String>] [-Description <String>] [-DNSView <String>] [-Policy <String>]
 [-Precedence <Int32>] [-TTL <Int32>] [-State <String>] [-Tags <Object>] -Object <Object> [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to updates a LBDN object within Universal DDI DTC

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1DTCLBDN -Name 'exchange.company.corp' -Description 'Exchange Servers LBDN' -DNSView 'Corporate' -Policy Exchange-Policy -Precedence 10 -TTL 10

id                  : dtc/lbdn/17fgt5ge-g5v5-5yhh-cvbg-dfcwef9f4h8
 name                : exchange.company.corp.
 view                : dns/view/cs8f4833-4c44-4c4v-fgvd-jfggdfsta90
 dtc_policy          : @{policy_id=dtc/policy/vduvr743-vcfr-jh9g-vcr3-fdbsv7bcd7; name=Exchange-Policy}
 precedence          : 10
 comment             : Exchange Servers LBDN
 disabled            : False
 ttl                 : 10
 tags                :
 inheritance_sources :
```

### EXAMPLE 2
```powershell
Get-B1DTCLBDN -Name 'exchange.company.corp' | Set-B1DTCLBDN -Description 'NEW LBDN' -DNSView 'Corporate' -Policy Exchange-Policy -Precedence 100 -TTL 60 -State Disabled

id                  : dtc/lbdn/17fgt5ge-g5v5-5yhh-cvbg-dfcwef9f4h8
 name                : exchange.company.corp.
 view                : dns/view/cs8f4833-4c44-4c4v-fgvd-jfggdfsta90
 dtc_policy          : @{policy_id=dtc/policy/vduvr743-vcfr-jh9g-vcr3-fdbsv7bcd7; name=Exchange-Policy}
 precedence          : 100
 comment             : NEW LBDN
 disabled            : True
 ttl                 : 60
 tags                :
 inheritance_sources :
```

## PARAMETERS

### -Name
The name of the DTC LBDN object to update

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

### -NewName
Use -NewName to update the name of the DTC LBDN object

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The new description for the DTC LBDN object

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSView
The new DNS View to assign to the DTC LBDN object

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Policy
The new Load Balancing Policy to assign to the DTC LBDN object

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Precedence
The new LBDN Precedence value

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Whether or not the new LBDN is enabled or disabled.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
The DTC LBDN Object(s) to update.
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
