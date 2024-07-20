---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1DTCPool

## SYNOPSIS
Creates a new pool object within BloxOne DTC

## SYNTAX

```
New-B1DTCPool [-Name] <String> [[-Description] <String>] [-LoadBalancingType] <String> [[-Servers] <Object>]
 [[-HealthChecks] <Object>] [[-PoolHealthyWhen] <String>] [[-PoolHealthyCount] <Int32>]
 [[-ServersHealthyWhen] <String>] [[-ServersHealthyCount] <Int32>] [[-TTL] <Int32>] [[-State] <String>]
 [[-Tags] <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new pool object within BloxOne DTC

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1DTCPool -Name 'Exchange Pool' -Description 'Pool of Exchange Servers' -LoadBalancingType Ratio -Servers MAILSERVER-01:10,MAILSERVER-02:20 -HealthChecks 'ICMP health check','Exchange HTTPS Check' -TTL 10

id                          : dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f
 name                        : Exchange Pool
 comment                     : Pool of Exchange Servers
 tags                        :
 disabled                    : False
 method                      : ratio
 servers                     : {@{server_id=dtc/server/23404tg-gt54-g4vg-c442-cw4vw3v4f; name=MAILSERVER-01; weight=10}, @{server_id=dtc/server/8vdsrnv8-vnnu-777g-gdvd-sdrghjj3b2; name=MAILSERVER-02; weight=20}}
 ttl                         : 10
 inheritance_sources         :
 pool_availability           : any
 pool_servers_quorum         : 0
 server_availability         : any
 server_health_checks_quorum : 0
 health_checks               : {@{health_check_id=dtc/health_check_icmp/vdsg4g4-vdg4-4g43-b3d8-c55xseve5b; name=ICMP health check}, @{health_check_id=dtc/health_check_icmp/fset4g4fg-h6hg-878f-ssw3-cdfu894d32; name=Exchange HTTPS Check}}
 metadata
```

## PARAMETERS

### -Name
The name of the DTC pool object to create

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
The description for the new pool object

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

If Ratio is selected, the -Servers parameter must include both the Server Name and Weight separated by a colon.
( -Servers "SERVER-PRIMARY:1","SERVER-BACKUP:2" )

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

### -Servers
The list of DTC Servers to assign to the pool.
This supports tab-completion to list available DTC servers.

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

### -HealthChecks
The list of DTC Health Checks to assign to the pool.
This supports tab-completion to list available DTC Health Checks.

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

### -PoolHealthyWhen
Report the Pool Health Status as Healthy when (Any/All/AtLeast) Servers are healthy

If At Least is selected, this must be used in conjunction with -PoolHealthyCount to set the number of required healthy servers

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Any
Accept pipeline input: False
Accept wildcard characters: False
```

### -PoolHealthyCount
The number of DTC Servers within the pool that are required for the pool to be reported as healthy.
This is used in conjunction with: -PoolHealthyWhen AtLeast

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServersHealthyWhen
Report the Server Health Status as Healthy when (Any/All/At Least) Health Checks are healthy

If At Least is selected, this must be used in conjunction with -ServerHealthyCount to set the number of required health checks

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: Any
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServersHealthyCount
The number of DTC Health Checks assigned to the server that are required for the server to be reported as healthy.
This is used in conjunction with: -ServerHealthyWhen AtLeast

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -TTL
The TTL to use for the DTC pool.
This will override inheritance.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Whether or not the new pool is created as enabled or disabled.
Defaults to enabled

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: Enabled
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Any tags you want to apply to the DTC Pool

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
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
