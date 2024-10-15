---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1SecurityPolicyIPAMNetwork

## SYNOPSIS
This function is used to simplify the creation of the list of Subnets/Address Blocks/Ranges to append or remove to/from an existing or a New Security Policy, using Set-B1SecurityPolicy / New-B1SecurityPolicy.

## SYNTAX

```
New-B1SecurityPolicyIPAMNetwork -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to simplify the creation of the list of Subnets/Address Blocks/Ranges to append or remove to/from an existing or a New Security Policy, using Set-B1SecurityPolicy / New-B1SecurityPolicy.

## EXAMPLES

### EXAMPLE 1
```powershell
$PolicyNetworks = @()
$PolicyNetworks += Get-B1Subnet 10.10.0.0/16 -Space 'My IP Space' | New-B1SecurityPolicyIPAMNetwork
$PolicyNetworks += Get-B1Subnet 10.15.0.0/16 -Space 'My IP Space' | New-B1SecurityPolicyIPAMNetwork
$PolicyNetworks += Get-B1Range 10.0.1.200 -Space 'My IP Space' | New-B1SecurityPolicyIPAMNetwork
$PolicyNetworks | ConvertTo-Json | ConvertFrom-Json | ft

addr_net        start         end        external_scope_id                    ip_space_id                          scope_type
--------        -----         ---        -----------------                    -----------                          ----------
10.10.0.0/16                             00011234-7b54-f4gf-gfgv-g4gh5h6rhrdg fdsjvf98-489j-v8rj-g54t-gefsffsdf34d SUBNET
10.15.0.0/16                             00015644-7t55-fsrg-g564-dfgbdrg48gdo fdsjvf98-489j-v8rj-g54t-gefsffsdf34d SUBNET
                10.0.1.200  10.0.1.240   00015644-7t55-fsrg-g564-dfgbdrg48gdo fdsjvf98-489j-v8rj-g54t-gefsffsdf34d RANGE
```

## PARAMETERS

### -Object
The Address Block, Subnet or Range object

```yaml
Type: Object
Parameter Sets: (All)
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
