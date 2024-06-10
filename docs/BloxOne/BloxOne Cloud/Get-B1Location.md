---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1Location

## SYNOPSIS
Retrieves a list of Locations defined within BloxOne Cloud

## SYNTAX

```
Get-B1Location [[-Name] <String>] [[-Description] <String>] [[-Address] <String>] [[-City] <String>]
 [[-State] <String>] [[-PostCode] <String>] [[-Country] <String>] [[-ContactEmail] <String>]
 [[-ContactName] <String>] [[-Limit] <Int32>] [[-Offset] <Int32>] [-Strict] [[-Fields] <String[]>]
 [[-OrderBy] <String>] [[-OrderByTag] <String>] [[-CustomFilters] <Object>] [[-id] <String>]
```

## DESCRIPTION
This function is used to retrieve a list of Locations defined within BloxOne Cloud

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Location -Name "Madrid"

address      : @{address=Santiago Bernabeu Stadium, 1, Avenida de Concha Espina, Hispanoamérica, Chamartín; city=Madrid; country=Spain; postal_code=28036; state=Community of Madrid}
contact_info : @{email=Curator@realmadrid.com; name=Curator}
created_at   : 2024-05-01T12:22:09.849259517Z
description  : Real Madrid Museum
id           : infra/location/fsf44f43g45gh45h4g34tgvgrdh6jtrhbcx
latitude     : 40.4530225
longitude    : -3.68742195874704
name         : Madrid
updated_at   : 2024-05-01T12:22:09.849259517Z
```

## PARAMETERS

### -Name
Filter the results by the name of the Location

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
Filter the results by the description of the Location

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

### -Address
Filter the results by the location address

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

### -City
Filter the results by the location city

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
Filter the results by the location state/county

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

### -PostCode
Filter the results by the location zip/postal code

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

### -Country
Filter the results by the location country

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

### -ContactEmail
Filter the results by the location contact email address

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

### -ContactName
Filter the results by the location contact name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
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
Position: 10
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
Position: 11
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
Position: 12
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
Position: 13
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
Position: 14
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
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the Location to filter by

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
