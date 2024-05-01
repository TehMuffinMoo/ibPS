---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1Location

## SYNOPSIS
Updates a Location within BloxOne Cloud

## SYNTAX

### Default
```
Set-B1Location -Name <String> [-NewName <String>] [-Description <String>] [-Address <String>] [-City <String>]
 [-State <String>] [-PostCode <String>] [-Country <String>] [-ContactEmail <String>] [-ContactName <String>]
 [-ContactPhone <String>] [<CommonParameters>]
```

### Pipeline
```
Set-B1Location [-NewName <String>] [-Description <String>] [-Address <String>] [-City <String>]
 [-State <String>] [-PostCode <String>] [-Country <String>] [-ContactEmail <String>] [-ContactName <String>]
 [-ContactPhone <String>] -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to update a Location within BloxOne Cloud

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Location -Name "Madrid" | Set-B1Location -NewName "Rome" -Description "Rome Office (Moved from Madrid)" -Address "1 Via Cavour" -PostCode "00184" -State "Rome" -Country "Italy" -ContactName "Curator" -ContactEmail "Curator@rome.com"

Multiple addresses found, please select the correct address

    # Address                        City                    Country PostCode State longitude latitude
    - -------                        ----                    ------- -------- ----- --------- --------
    0 1, Via Cavour                  Villanova               Italy   00012    Rome     12.753   41.964
    1 1, Via Cavour                  Mentana                 Italy   00013    Rome     12.697   42.058
    2 1, Via Cavour, Castro Pretorio Rome                    Italy   00184    Rome     12.500   41.901
    3 1, Via Cavour                  Monterotondo            Italy   00015    Rome     12.615   42.053
    4 1, Via Cavour                  Valmontone              Italy   00038    Rome     12.921   41.772
    5 1, Via Cavour                  Fiano Romano            Italy   00065    Rome     12.593   42.172
    6 1, Via Cavour                  Lariano                 Italy   00040    Rome     12.841   41.724
    7 1, Via Cavour                  Frascati                Italy   00044    Rome     12.681   41.806
    8 1, Via Cavour                  Albano                  Italy   00041    Rome     12.661   41.727
    9 1, Via Cavour                  San Gregorio da Sassola Italy   00010    Rome     12.874   41.920

    Select the correct address by entering the # or x to cancel.: 9

    #   Address       City                    Country PostCode State longitude latitude
    -   -------       ----                    ------- -------- ----- --------- --------
    9   1, Via Cavour San Gregorio da Sassola Italy   00010    Rome     12.874   41.920

    Do you want to replace the address information with those listed? (Yes/No): Yes

    address      : @{address=1, Via Cavour; city=San Gregorio da Sassola; country=Italy; postal_code=00010; state=Rome}
    contact_info : @{email=Curator@rome.com; name=Curator}
    description  : Rome Office (Moved from Madrid)
    id           : infra/location/fsf44f43g45gh45h4g34tgvgrdh6jtrhbcx
    latitude     : 41.919847
    longitude    : 12.873967
    name         : Madrid
    updated_at   : 2024-05-01T13:06:44.873541805Z
```

## PARAMETERS

### -Name
The name of the location to update

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
The new name for the specified location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The new description for the specified location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Address
The new address for the specified location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -City
The new city for the specified location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
The new state for the specified location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PostCode
The new zip/post code for the specified location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Country
The new country for the specified location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContactEmail
The new contact email address for the specified location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContactName
The new contact name for the specified location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContactPhone
The new contact phone number for the specified location

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
The Location Object.
Accepts pipeline input from Get-B1Location

```yaml
Type: Object
Parameter Sets: Pipeline
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
