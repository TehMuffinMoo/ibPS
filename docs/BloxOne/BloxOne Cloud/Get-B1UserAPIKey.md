---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1UserAPIKey

## SYNOPSIS
Retrieves a list of Interactive BloxOne Cloud API Keys for your user

## SYNTAX

```
Get-B1UserAPIKey [[-Name] <String>] [[-State] <String>] [[-Limit] <Int32>] [[-Offset] <Int32>] [-Strict]
 [[-id] <String>]
```

## DESCRIPTION
This function is used to retrieve a list of Interactive BloxOne Cloud API Keys for your user
The actual API Key is only available during initial creation and cannot be retrieved afterwards via this API.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1UserAPIKey -Name "somename" -State Enabled
```

### EXAMPLE 2
```powershell
Get-B1UserAPIKey -Name "apikeyname" -Strict
```

## PARAMETERS

### -Name
Filter the results by the name of the API Key

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
Filter the results by the state of the API Key

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

### -Limit
Use this parameter to limit the quantity of results.
The default and maximum number of results is 101.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 101
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
The id of the authoritative zone to filter by

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
