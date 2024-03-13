---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDLookalikes

## SYNOPSIS
Queries a list of lookalike domains

## SYNTAX

```
Get-B1TDLookalikes [[-Domain] <String>] [[-LookalikeDomain] <String>] [[-Reason] <String>] [[-Limit] <Int32>]
 [[-Offset] <Int32>] [-Strict]
```

## DESCRIPTION
This function is used to retrieve information on lookalike domains

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDLookalikes -Domain google.com -Reason "phishing" | ft registration_date,lookalike_domain,type,categories,reason -AutoSize

registration_date lookalike_domain                type   categories       reason
----------------- ----------------                ----   ----------       ------
2024-02-07        adsbygoogle.top                 common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-02-07.
2023-11-27        apps-ai-assist-goo-gle.shop     common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2023-11-27.
2024-03-01        gdgoogle.cn                     common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-03-01.
2024-01-03        gogogle.cn                      common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-01-03.
2024-02-16        googelphotos.life               common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-02-16.
2024-02-21        google-com.top                  common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-02-21.
2024-02-21        googlegames.vip                 common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-02-21.
2024-02-29        googlehop.cn                    common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-02-29.
2024-01-30        googleoglasi.top                common {Uncategorized}  Domain is a lookalike to google.com and likely used for phishing. The creation or first seen date is 2024-01-30.
...
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

### -LookalikeDomain
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