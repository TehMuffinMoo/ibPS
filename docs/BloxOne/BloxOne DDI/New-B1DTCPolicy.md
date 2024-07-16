---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1DTCPolicy

## SYNOPSIS
Creates a new policy object within BloxOne DTC

## SYNTAX

```
New-B1DTCPolicy [-Name] <String> [[-Description] <String>] [-LoadBalancingType] <String> [[-Pools] <Object>]
 [[-Rules] <Object>] [[-TTL] <Int32>] [[-State] <String>] [[-Tags] <Object>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new policy object within BloxOne DTC

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1DTCPolicy -Name 'Exchange-Policy' -Description 'Exchange Policy' -LoadBalancingType GlobalAvailability -Pools 'Exchange Pool' -TTL 10 -Tags @{'Owner' = 'Network Team'}

id                  : dtc/policy/cgg5h6tgfs-dfg7-t5rf-f4tg-edgfre45g0
 name                : Exchange-Policy
 comment             : Exchange Policy
 tags                : @{Owner=Network Team}
 disabled            : False
 method              : global_availability
 ttl                 : 10
 pools               : {@{pool_id=dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f; name=Exchange Pool; weight=1}}
 inheritance_sources :
 rules               : {}
 metadata            :
```

### EXAMPLE 2
```powershell
New-B1DTCPolicy -Name 'Exchange-Policy' -Description 'Exchange Policy' -LoadBalancingType Topology -Pools 'Exchange Pool' -TTL 10

id                  : dtc/policy/cgg5h6tgfs-dfg7-t5rf-f4tg-edgfre45g0
 name                : Exchange-Policy
 comment             : Exchange Policy
 tags                :
 disabled            : False
 method              : topology
 ttl                 : 10
 pools               : {@{pool_id=dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f; name=Exchange Pool; weight=1}}
 inheritance_sources :
 rules               : {}
 metadata            :
```

### EXAMPLE 3
```powershell
$TopologyRules = @()
$TopologyRules += New-B1DTCTopologyRule -Name 'Rule 1' -Type 'Subnet' -Destination NXDOMAIN -Subnets '10.10.10.0/24','10.20.0.0/24'
$TopologyRules += New-B1DTCTopologyRule -Name 'Rule 2' -Type 'Default' -Destination Pool -Pool Exchange-Pool -Subnets '10.25.0.0/16','10.30.0.0/16'

New-B1DTCPolicy -Name 'Exchange-Policy' -Description 'Exchange Policy' -LoadBalancingType Topology -Pools Exchange-Pool -TTL 10 -Rules $TopologyRules

id                  : dtc/policy/vduvr743-vcfr-jh9g-vcr3-fdbsv7bcd7
name                : Exchange-Policy
comment             : Exchange Policy
tags                :
disabled            : False
method              : topology
ttl                 : 10
pools               : {@{pool_id=dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f; name=Exchange-Pool; weight=1}}
inheritance_sources :
rules               : {@{name=Rule 1; source=subnet; subnets=System.Object[]; destination=code; code=nxdomain; pool_id=}, @{name=Default; source=default; subnets=System.Object[]; destination=pool; code=; pool_id=dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f}}
metadata
```

## PARAMETERS

### -Name
The name of the DTC policy object to create

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
The description for the new policy object

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

### -LoadBalancingType
The Load Balancing Type to use (Round Robin / Ratio / Global Availability)

If Ratio is selected, the -Pools parameter must include both the Pool Name and Weight separated by a colon.
( -Servers "POOL-A:1","POOL-B:2" )

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

### -Pools
The list of DTC Pools to assign to the policy.
This supports tab-completion to list available DTC pools.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
Default value: Enabled
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
Position: 8
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
