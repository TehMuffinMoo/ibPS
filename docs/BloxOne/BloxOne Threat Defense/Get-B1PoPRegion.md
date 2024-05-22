---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1PoPRegion

## SYNOPSIS
Retrieves a list of BloxOne Threat Defense PoP Regions

## SYNTAX

### Default (Default)
```
Get-B1PoPRegion [-Region <String>] [-Location <String>] [-Limit <Int32>] [-Offset <Int32>] [-Fields <String[]>]
 [<CommonParameters>]
```

### With ID
```
Get-B1PoPRegion [-id <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of BloxOne Threat Defense Point of Presence (PoP) Regions

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1PoPRegion

addresses                       id location             region
---------                       -- --------             ------
{52.119.41.51, 103.80.6.51}      1 California, US       us-west-1
{52.119.41.52, 103.80.6.52}      2 Virginia, US         us-east-1
{52.119.41.53, 103.80.6.53}      3 London, UK           eu-west-2
{52.119.41.54, 103.80.6.54}      4 Frankfurt, Germany   eu-central-1
{52.119.41.55, 103.80.6.55}      5 Mumbai, India        ap-south-1
{52.119.41.56, 103.80.6.56}      6 Tokyo, Japan         ap-northeast-1
{52.119.41.57, 103.80.6.57}      7 Singapore            ap-southeast-1
{52.119.41.58, 103.80.6.58}      8 Toronto, Canada      ca-central-1
{52.119.41.59, 103.80.6.59}      9 Sydney, Australia    ap-southeast-2
{52.119.41.60, 103.80.6.60}     10 Sao Paulo, Brazil    sa-east-1
{52.119.41.61, 103.80.6.61}     11 Manama, Bahrain      me-south-1
{52.119.41.62, 103.80.6.62}     12 Cape Town, S. Africa af-south-1
{52.119.41.63, 103.80.6.63}     13 Ohio, US             us-east-2
{52.119.41.100, 103.80.6.100}  100 Global AnyCast       Global
```

## PARAMETERS

### -Region
Filter results by Region.
Whilst this is here, the API does not currently support filtering by region.
22/05/24

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
Filter results by Location.
Whilst this is here, the API does not currently support filtering by region.
22/05/24

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Use this parameter to limit the quantity of results.

```yaml
Type: Int32
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
Use this parameter to offset the results by the value entered for the purpose of pagination

```yaml
Type: Int32
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fields
Specify a list of fields to return.
The default is to return all fields.

```yaml
Type: String[]
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
Filter the results by id

```yaml
Type: String
Parameter Sets: With ID
Aliases:

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
