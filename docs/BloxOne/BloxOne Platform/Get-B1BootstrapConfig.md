---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1BootstrapConfig

## SYNOPSIS
Retrieves the bootstrap configuration for a BloxOneDDI Host

## SYNTAX

```
Get-B1BootstrapConfig [[-B1Host] <String>] [[-Limit] <Int32>] [[-Offset] <Int32>] [[-Fields] <String[]>]
 [-GetConfig] [-Strict]
```

## DESCRIPTION
This function is used to retrieve the bootstrap configuration for a BloxOneDDI Host

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1BootstrapConfig -B1Host "myonpremhost.corp.domain.com"
```

## PARAMETERS

### -B1Host
The name of the BloxOneDDI host to query the bootstrap config for

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

### -Limit
Use this parameter to limit the quantity of results.
The default number of results is 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 100
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
Position: 3
Default value: 0
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
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GetConfig
Specify the -GetConfig parameter to return only the BloxOne Hosts current config

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
