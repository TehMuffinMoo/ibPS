---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1TDTideDataProfile

## SYNOPSIS
Updates an existing TIDE Data Profile

## SYNTAX

```
Set-B1TDTideDataProfile [-Name] <String> [[-Description] <String>] [[-RPZFeed] <String>] [[-State] <String>]
 [[-DefaultTTL] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing TIDE Data Profile from BloxOne Threat Defense.

## EXAMPLES

### EXAMPLE 1
```
Set-B1TDTideDataProfile -Name "My Profile" -Description "New Description" -RPZFeed "New RPZ Feed" -Active $true -DefaultTTL $false
```

## PARAMETERS

### -Name
The name of the TIDE Data Profile to update

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
The description to apply to the data profile

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Notset
Accept pipeline input: False
Accept wildcard characters: False
```

### -RPZFeed
The name of the BYOF RPZ Feed that this data profile will be included in

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Notset
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
This value indicates if the Data Profile is activated or deactivated.

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

### -DefaultTTL
{{ Fill DefaultTTL Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
