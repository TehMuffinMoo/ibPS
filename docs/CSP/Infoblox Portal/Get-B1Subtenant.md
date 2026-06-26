---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1Subtenant

## SYNOPSIS
Retrieves a list of Subtenant (Sandbox) accounts

## SYNTAX

```
Get-B1Subtenant [[-Name] <String>] [[-State] <String>] [[-Description] <String>] [[-Limit] <Int32>]
 [[-Offset] <Int32>] [-Strict] [[-id] <String>]
```

## DESCRIPTION
This function will retrieve a list of Subtenant (Sandbox) accounts associated with the current account

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Subtenant
```

### EXAMPLE 2
```powershell
Get-B1Subtenant -Name "My Subtenant"
```

## PARAMETERS

### -Name
Filter the list of subtenants by their name

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

### -State
Filter the list of subtenants by their state.
Available states are "active" and "disabled"

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

### -Description
Filter the list of subtenants by their description

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

### -id
Return a subtenant by its id

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
