---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1Location

## SYNOPSIS
Creates a new Location within BloxOne Cloud

## SYNTAX

```
New-B1Location [-Name] <String> [[-Description] <String>] [-Address] <String> [[-City] <String>]
 [[-State] <String>] [[-PostCode] <String>] [-Country] <String> [[-ContactEmail] <String>]
 [[-ContactName] <String>] [[-ContactPhone] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new Location within BloxOne Cloud

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1Location -Name "Madrid" -Description "Real Madrid Museum" -Address "Estadio Santiago Bernabeu Avenida Concha Espina" -PostCode "28036" -State "Madrid" -Country "Spain" -ContactName "Curator" -ContactEmail "Curator@realmadrid.com"

# Address                                                                           City   Country PostCode State               longitude latitude
    - -------                                                                           ----   ------- -------- -----               --------- --------
    Santiago Bernabeu Stadium, 1, Avenida de Concha Espina, Hispanoamérica, Chamartín Madrid Spain   28036    Community of Madrid    -3.687   40.453

    Do you want to replace the address information with those listed? (Yes/No): Yes

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
The name of the location to create

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
The description of the new location

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
The first line of the address for the new location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -City
The city for the new location

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
The state/county for the new location

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
The zip/postal code for the new location

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
The country for the new location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContactEmail
The contact email address for the new location

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
The contact name for the new location

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

### -ContactPhone
The contact phone number for the new location

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
