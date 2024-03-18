---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version: https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
schema: 2.0.0
---

# New-B1TDTideDataProfile

## SYNOPSIS
Creates a new TIDE Data Profile

## SYNTAX

```
New-B1TDTideDataProfile [-Name] <String> [-Description] <String> [[-RPZFeed] <String>]
 [[-DefaultTTL] <Boolean>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new TIDE Data Profile in BloxOne Threat Defense.

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1TDTideDataProfile -Name "My Profile" -Description "My Data Profile" -RPZFeed "threat_feed_one" -DefaultTTL $true

Successfully created TIDE Data Profile: My Profile

id          : 01234546567563324:My-Profile
name        : My Profile
description : My Data Profile
policy      : default-csp
default_ttl : True
active      : True
rpzfeedname : threat_feed_one
```

## PARAMETERS

### -Name
The name of the TIDE Data Profile to create

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description of the TIDE Data Profile to create

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultTTL
This boolean value indicates if to use the default TTL for threats (default is true)

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
