---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1APIKey

## SYNOPSIS
Retrieves a list of BloxOne Cloud API Keys

## SYNTAX

```
Get-B1APIKey [[-User] <String>] [[-CreatedBy] <String>] [[-Name] <String>] [[-Type] <String>]
 [[-State] <String>] [[-Limit] <Int32>] [[-Offset] <Int32>] [-Strict] [[-Fields] <String[]>]
 [[-CustomFilters] <Object>] [[-id] <String>]
```

## DESCRIPTION
This function is used to retrieve a list of API Keys from the BloxOne Cloud
The actual API Key is only available during initial creation and cannot be retrieved afterwards via this API, except for Legacy Keys which are being deprecated.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1APIKey -User "user@domain.corp" -Name "somename" -Type "interactive" -State Enabled
```

## PARAMETERS

### -User
Filter the results by user_email

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

### -CreatedBy
Filter the results by the original creator of the API Key

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

### -Name
Filter the results by the name of the API Key

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

### -Type
Filter the results by the API Key Type

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 5
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
Position: 6
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
Position: 7
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

### -Fields
Specify a list of fields to return.
The default is to return all fields.

```yaml
Type: String[]
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
The id of the API Key to filter by

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
