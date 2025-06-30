---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1LookalikeDomains

## SYNOPSIS
Queries a list of detected Lookalike Domain objects with target domains specified by the account.

## SYNTAX

```
Get-B1LookalikeDomains [[-Domain] <String[]>] [[-LookalikeHost] <String>] [[-Reason] <String>]
 [[-Limit] <Int32>] [[-Offset] <Int32>] [[-Fields] <String[]>] [-Strict] [[-CustomFilters] <Object>]
 [-CaseSensitive] [<CommonParameters>]
```

## DESCRIPTION
This function is used to retrieve information on all detected Lookalike Domain objects with target domains specified by the account.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1LookalikeDomains -Domain google.com | ft detected_at,lookalike_domain,reason -AutoSize

detected_at         lookalike_domain                                               reason
-----------         ----------------                                               ------
2/6/2024 6:40:48PM  googletah.shop                                                 Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2023-11-09.
2/6/2024 6:41:09PM  cdn-google-tag.info                                            Domain is a lookalike to google.com and has suspicious registration, behavior, or associations with known threats. The creation or first seen date is 2024-01-16.
2/6/2024 6:41:09PM  comgoogle.email                                                Domain is a lookalike to google.com and has suspicious registration, behavior, or associations with known threats. The creation or first seen date is 2023-11-12.
2/6/2024 6:41:09PM  geminigoogle.xyz                                               Domain is a lookalike to google.com and has suspicious registration, behavior, or associations with known threats. The creation or first seen date is 2023-12-08.
2/6/2024 6:41:36PM  123googleplaykarte.de                                          Domain is a lookalike to google.com. The creation date is unknown.
2/6/2024 6:41:36PM  adsgoogle.gt                                                   Domain is a lookalike to google.com. The creation date is unknown.
2/6/2024 6:41:36PM  a-googleseo.com                                                Domain is a lookalike to google.com. The creation date is 2023-10-27.
2/6/2024 6:41:36PM  app-google.de                                                  Domain is a lookalike to google.com. The creation date is unknown.
2/6/2024 6:41:36PM  bardgoogler.com                                                Domain is a lookalike to google.com. The creation date is 2023-04-02.
2/6/2024 6:41:36PM  bestgoogles.shop                                               Domain is a lookalike to google.com. The creation date is 2023-11-09.
2/6/2024 6:41:36PM  brightcastweightlossttgoogleuk.today                           Domain is a lookalike to google.com. The creation date is 2023-06-18.
...
```

## PARAMETERS

### -Domain
Filter the results by target domain

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

### -CustomFilters
Accepts either an Object, ArrayList or String containing one or more custom filters.
See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CaseSensitive
Use Case Sensitive matching.
By default, case-insensitive matching both for -Strict matching and regex matching.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
