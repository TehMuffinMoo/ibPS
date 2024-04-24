---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1DTCPool

## SYNOPSIS
Updates a pool object within BloxOne DTC

## SYNTAX

### Default
```
Set-B1DTCPool -Name <String> [-NewName <String>] [-Description <String>] [-LoadBalancingType <String>]
 [-Servers <Object>] [-HealthChecks <Object>] [-PoolHealthyWhen <String>] [-PoolHealthyCount <Int32>]
 [-ServersHealthyWhen <String>] [-ServersHealthyCount <Int32>] [-TTL <Int32>] [-State <String>]
 [-Tags <Object>] [<CommonParameters>]
```

### With ID
```
Set-B1DTCPool [-NewName <String>] [-Description <String>] [-LoadBalancingType <String>] [-Servers <Object>]
 [-HealthChecks <Object>] [-PoolHealthyWhen <String>] [-PoolHealthyCount <Int32>]
 [-ServersHealthyWhen <String>] [-ServersHealthyCount <Int32>] [-TTL <Int32>] [-State <String>]
 [-Tags <Object>] -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to update a pool object within BloxOne DTC

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1DTCPool
```

### EXAMPLE 2
```powershell
Get-B1DTCPool -Name 'Exchange Pool' | Set-B1DTCPool -State Disabled
```

## PARAMETERS

### -Name
The name of the DTC pool object to update

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
Use -NewName to update the name of the DTC Pool object

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
The new description for the DTC pool

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
The new Load Balancing Type to use (Round Robin / Ratio / Global Availability)

If Ratio is selected, the -Servers parameter must include both the Server Name and Weight separated by a colon.
( -Servers "SERVER-PRIMARY:1","SERVER-BACKUP:2" )

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

### -Servers
The list of DTC Servers to assign to the pool.
This supports tab-completion to list available DTC servers.

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

### -HealthChecks
The list of DTC Health Checks to assign to the pool.
This supports tab-completion to list available DTC Health Checks.

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

### -PoolHealthyWhen
Report the Pool Health Status as Healthy when (Any/All/AtLeast) Servers are healthy

If At Least is selected, this must be used in conjunction with -PoolHealthyCount to set the number of required healthy servers

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

### -PoolHealthyCount
The number of DTC Servers within the pool that are required for the pool to be reported as healthy.
This is used in conjunction with: -PoolHealthyWhen AtLeast

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

### -ServersHealthyWhen
Report the Server Health Status as Healthy when (Any/All/At Least) Health Checks are healthy

If At Least is selected, this must be used in conjunction with -ServerHealthyCount to set the number of required health checks

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

### -ServersHealthyCount
The number of DTC Health Checks assigned to the server that are required for the server to be reported as healthy.
This is used in conjunction with: -ServerHealthyWhen AtLeast

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
The TTL to use for the DTC pool.
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
Whether or not the new pool is created as enabled or disabled.
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
Any tags you want to apply to the DTC Pool

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
The DTC Pool Object(s) to update.
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS