---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DFP

## SYNOPSIS
Queries a list of BloxOneDDI DFPs (DNS Forwarding Proxies)

## SYNTAX

```
Get-B1DFP [[-Name] <String[]>] [[-SiteID] <String>] [[-OPHID] <String>] [[-PolicyID] <Int32>]
 [-DefaultSecurityPolicy] [-Strict] [[-Fields] <String[]>] [[-id] <String>]
```

## DESCRIPTION
Use this method query a list of BloxOneDDI DFPs (DNS Forwarding Proxies)

## EXAMPLES

### EXAMPLE 1
```
Get-B1DFP -Name "My DFP" -Strict
```

### EXAMPLE 2
```
Get-B1DFP -DefaultSecurityPolicy
```

## PARAMETERS

### -Name
Filter the results by name

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SiteID
Filter the results by site_id

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

### -OPHID
Filter the results by ophid

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PolicyID
Filter the results by policy_id

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

### -DefaultSecurityPolicy
Switch value to filter by default security policy

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

### -Fields
Specify a list of fields to return.
The default is to return all fields.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
Filter the results by id

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
