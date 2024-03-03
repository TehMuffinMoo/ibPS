---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1AuthoritativeNSG

## SYNOPSIS
Retrieves a list of Authoritative DNS Server Groups from BloxOneDDI

## SYNTAX

```
Get-B1AuthoritativeNSG [[-Name] <String>] [-Strict] [[-tfilter] <String>] [[-Fields] <String[]>]
 [[-id] <String>]
```

## DESCRIPTION
This function is used to query a list Authoritative DNS Server Groups from BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```
Get-B1AuthoritativeNSG -Name "Data Centre" -Strict
```

## PARAMETERS

### -Name
The name of the Authoritative DNS Server Group

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

### -tfilter
Use this parameter to filter the results returned by tag.

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

### -Fields
Specify a list of fields to return.
The default is to return all fields.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
Return results based on the authoritative NSG id

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
