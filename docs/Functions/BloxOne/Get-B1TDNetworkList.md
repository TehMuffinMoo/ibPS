---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDNetworkList

## SYNOPSIS
Retrieves network lists from BloxOne Threat Defense

## SYNTAX

### notid (Default)
```
Get-B1TDNetworkList [-Name <String>] [-Description <String>] [-PolicyID <Int32>] [-DefaultSecurityPolicy]
 [-Strict] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### id
```
Get-B1TDNetworkList [-id <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to retrieve network lists from BloxOne Threat Defense

## EXAMPLES

### EXAMPLE 1
```
Get-B1TDNetworkList -Name "something"
```

## PARAMETERS

### -Name
Filter results by Name

```yaml
Type: String
Parameter Sets: notid
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Filter results by Description

```yaml
Type: String
Parameter Sets: notid
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PolicyID
Filter results by policy_id

```yaml
Type: Int32
Parameter Sets: notid
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultSecurityPolicy
Filter results by those assigned to the default security policy

```yaml
Type: SwitchParameter
Parameter Sets: notid
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
Filter the results by id

```yaml
Type: Int32
Parameter Sets: id
Aliases:

Required: False
Position: Named
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
Parameter Sets: notid
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
