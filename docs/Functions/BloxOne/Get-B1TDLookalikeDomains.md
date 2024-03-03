---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDLookalikeDomains

## SYNOPSIS
Queries a list of detected Lookalike Domain objects with target domains specified by the account.

## SYNTAX

```
Get-B1TDLookalikeDomains [[-Domain] <String>] [[-LookalikeHost] <String>] [[-Reason] <String>]
 [[-Limit] <Int32>] [[-Offset] <Int32>] [-Strict]
```

## DESCRIPTION
This function is used to retrieve information on all detected Lookalike Domain objects with target domains specified by the account.

## EXAMPLES

### EXAMPLE 1
```
Get-B1TDLookalikeDomains -Domain google.com
```

## PARAMETERS

### -Domain
Filter the results by target domain

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

### -LookalikeHost
Filter the results by lookalike domain

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

### -Reason
Filter the results by reason

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

### -Limit
Use this parameter to limit the quantity of results.
The default number of results is 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
Default value: 0
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
