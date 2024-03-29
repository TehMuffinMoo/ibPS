---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1LookalikeTargetCandidates

## SYNOPSIS
Queries a list of all lookalike target candidates

## SYNTAX

```
Get-B1LookalikeTargetCandidates [-AccountSpecific]
```

## DESCRIPTION
Use this method to retrieve information on all Lookalike Target Candidates.
The Lookalike Target Candidates are second-level domains BloxOne uses to detect lookalike FQDNs against.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1LookalikeTargetCandidates

name                             description    items_described                                                                                                                     item_count
----                             -----------    ---------------                                                                                                                     ----------
Global Lookalike Candidates List Auto-generated {@{item=accuweather.com; selected=True}, @{item=active.aero}, @{item=adobe.com; selected=True}, @{item=airbnb.com; selected=True}…}        123
```

### EXAMPLE 2
```powershell
Get-B1LookalikeTargetCandidates | Select-Object -ExpandProperty items_described

item                        selected
----                        --------
accuweather.com                 True
active.aero                         
adobe.com                       True
airbnb.com                      True
alibaba.com                         
aliexpress.com                  True
amazonaws.com                   True
amazon.com                      True
americafirst.com                True
americanexpressbusiness.com         
...
```

### EXAMPLE 3
```powershell
Get-B1LookalikeTargetCandidates -AccountSpecific

name                                      description    items_described                                                item_count
----                                      -----------    ---------------                                                ----------
Account Specific Lookalike Candidate List Auto-generated {@{item=infoblox.com; selected=True; query_count_daily=28350}}          1
```

## PARAMETERS

### -AccountSpecific
Determines whether to return account_specific or common candidates.
Default value is false, i.e.
returns common candidates.

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
