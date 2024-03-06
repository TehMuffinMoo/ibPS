---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDTideThreatProperty

## SYNOPSIS
Queries a list of threat properties

## SYNTAX

```
Get-B1TDTideThreatProperty [[-id] <String>] [[-Name] <String>] [[-Class] <String>] [[-ThreatLevel] <Int32>]
```

## DESCRIPTION
This function will query a list of threat properties

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDTideThreatProperty -Name "CamelCase" -ThreatLevel 100
```

## PARAMETERS

### -id
Filter the results by property ID

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

### -Name
Filter the results by property name

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

### -Class
Filter the results by property threat class

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

### -ThreatLevel
Filter the results by property threat level

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
