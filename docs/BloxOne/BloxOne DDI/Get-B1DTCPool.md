---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DTCPool

## SYNOPSIS
Retrieves a list BloxOne DTC Pools

## SYNTAX

```
Get-B1DTCPool [[-Name] <String>] [[-Description] <String>] [-Strict] [[-Limit] <Int32>] [[-Offset] <Int32>]
 [[-tfilter] <String>] [[-Fields] <String[]>] [[-OrderBy] <String>] [[-OrderByTag] <String>]
 [[-CustomFilters] <Object>] [[-id] <String>]
```

## DESCRIPTION
This function is used to query a list BloxOne DTC Pools

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DTCPool -Name 'DTC-Exchange'

id                          : dtc/pool/656yhrft-gdf5-4gfs-tfg5-gg5ghbtg44d9
name                        : DTC-Exchange
comment                     : 
tags                        : 
disabled                    : False
method                      : ratio
servers                     : {@{server_id=dtc/server/vdr5g5t-fgfg-gds4-svsv-f44gdbdbfbvbxv; name=EXCHANGE-MAIL01; weight=2}, @{server_id=dtc/server/348t54gg8-r3f4-g455-g4vr-sdvre545g3; name=EXCHANGE-MAIL02; weight=1}}
ttl                         : 0
inheritance_sources         : 
pool_availability           : any
pool_servers_quorum         : 0
server_availability         : all
server_health_checks_quorum : 0
health_checks               : {@{health_check_id=dtc/health_check_icmp/ac9fcsvf1-ggjh-fdbg-adfd-h56hnbtjyngv; name=ICMP health check}, @{health_check_id=dtc/health_check_http/dgferhg5-ge5e-g455-gb45-muymkfdsdfcf; name=Exchange - HTTPS}}
metadata                    :
```

## PARAMETERS

### -Name
The name of the DTC Pool to filter by

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

### -Description
The description of the DTC Pool to filter by

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

### -Strict
Use strict filter matching.
By default, filters are searched using wildcards where possible.
Using strict matching will only return results matching exactly what is entered in the applicable parameters.

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

### -Limit
Use this parameter to limit the quantity of results.
The default number of results is 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
Use this parameter to offset the results by the value entered for the purpose of pagination

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -tfilter
Use this parameter to filter the results returned by tag.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fields
Specify a list of fields to return.
The default is to return all fields.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderBy
Optionally return the list ordered by a particular value.
If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy.
Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderByTag
Optionally return the list ordered by a particular tag value.
Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomFilters
Accepts either an Object, ArrayList or String containing one or more custom filters.
See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
Return results based on Pool id

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
