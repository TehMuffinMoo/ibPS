---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Optimize-B1ServerTokens

## SYNOPSIS
Checks and optionally applies optimizations to NIOS-X Server Token Consumption

## SYNTAX

```
Optimize-B1ServerTokens [[-Action] <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to check and optionally apply optimizations to NIOS-X Server Token Consumption by right-sizing the Server SKUs

## EXAMPLES

### EXAMPLE 1
```powershell
Optimize-B1ServerTokens -Action Check | ft * -AutoSize

Current Token Count: 191980 (Token Packs: 383.96)
Expected Token Count: 194240 (Token Packs: 388.48)
Token Delta: > 2260 (Token Packs: > 4.52)

display_name    size should_be_size needs_right_sizing tokens_current tokens_should_be objects_current objects_peak objects_percentage qps_current qps_peak qps_percentage lps_current lps_peak lps_percentage
------------    ---- -------------- ------------------ -------------- ---------------- --------------- ------------ ------------------ ----------- -------- -------------- ----------- -------- --------------
vmniosx-001     XXS  XS                           True            130              250            4548         4730            157.667      87.200   98.030          1.961       0.470    0.630          0.840
vmniosx-002     XXS  XS                           True            130              250            3198         3201            106.700      17.500   40.630          0.813       0.600    1.100          1.467
vmniosx-004     XXS  XS                           True            130              250            2988         3005            100.167      18.520   34.350          0.687       0.700    0.870          1.160
vmniosx-010     XXS  S                            True            130              470            6500         7824            260.800     835.750 1369.680         27.394       1.900    2.830          3.773
vmniosx-014     XXS  XS                           True            130              250            3419         3480            116.000      63.470   95.800          1.916       0.470    0.770          1.027
vmniosx-019     XXS  XS                           True            130              250            3654         3735            124.500      28.970   37.500          0.750       0.600    0.630          0.840
```

## PARAMETERS

### -Action
The action to perform.
Use 'Check' to check for right-sizing opportunities, or 'Apply' to apply right-sizing to any NIOS-X Servers that are not optimally sized.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Check
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
{{ Fill Force Description }}

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
