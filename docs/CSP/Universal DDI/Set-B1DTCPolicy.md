---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1DTCPolicy

## SYNOPSIS
Updates a policy object within Universal DDI DTC

## SYNTAX

### Default (Default)
```
Set-B1DTCPolicy -Name <String> [-NewName <String>] [-Description <String>] [-LoadBalancingType <String>]
 [-Pools <Object>] [-Rules <Object>] [-TTL <Int32>] [-State <String>] [-Tags <Object>] [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### With ID
```
Set-B1DTCPolicy [-NewName <String>] [-Description <String>] [-LoadBalancingType <String>] [-Pools <Object>]
 [-Rules <Object>] [-TTL <Int32>] [-State <String>] [-Tags <Object>] -Object <Object> [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update a policy object within Universal DDI DTC

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1DTCPolicy -Name 'Exchange-Policy' -LoadBalancingType Ratio -Pools Exchange-Pool:5,Exchange-Pool-Backup:10 -TTL 10

id                  : dtc/policy/cgg5h6tgfs-dfg7-t5rf-f4tg-edgfre45g0
 name                : Exchange-Policy
 comment             :
 tags                :
 disabled            : False
 method              : global_availability
 ttl                 : 10
 pools               : {@{pool_id=dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f; name=Exchange-Pool; weight=1}, ${pool_id=dtc/pool/23404tg-gt54-g4vg-c442-cw4vw3v4f; name=Exchange-Pool-Backup; weight=10}}
 inheritance_sources :
 rules               : {@{name=Default; source=default; subnets=System.Object[]; destination=code; code=nodata; pool_id=}}
 metadata            :
```

### EXAMPLE 2
```powershell
Get-B1DTCPolicy -Name 'Exchange-Policy' | Set-B1DTCPolicy -LoadBalancingType GlobalAvailability -Pools Exchange-Pool -TTL 10

id                  : dtc/policy/cgg5h6tgfs-dfg7-t5rf-f4tg-edgfre45g0
 name                : Exchange-Policy
 comment             :
 tags                :
 disabled            : False
 method              : global_availability
 ttl                 : 10
 pools               : {@{pool_id=dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f; name=Exchange-Pool; weight=1}}
 inheritance_sources :
 rules               : {@{name=Default; source=default; subnets=System.Object[]; destination=code; code=nodata; pool_id=}}
 metadata            :
```

## PARAMETERS

### -Name
The name of the DTC policy object to update

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
Use -NewName to update the name of the DTC Policy object

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
The new description for the policy object

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

### -LoadBalancingType
The Load Balancing Type to use (Round Robin / Ratio / Global Availability)

If Ratio is selected, the -Pools parameter must include both the Pool Name and Weight separated by a colon.
( -Servers "POOL-A:1","POOL-B:2" )

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

### -Pools
The list of DTC Pools to assign to the policy.
This supports tab-completion to list available DTC pools.

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

### -Rules
The list of rules to apply when using the Topology Load Balancing Type

You can generate the list of rules using New-B1DTCTopologyRule.
See Example #3

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

### -TTL
The TTL to use for the DTC Policy.
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
Whether or not the new policy is created as enabled or disabled.
Defaults to enabled

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
Any tags you want to apply to the DTC policy

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
The DTC Policy Object(s) to update.
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
