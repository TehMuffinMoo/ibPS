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

### notid (Default)
```
Get-B1PoPRegion [-Region <String>] [-Location <String>] [<CommonParameters>]
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

addresses                   id location             region
---------                   -- --------             ------
{52.119.41.51, 103.80.6.51}  1 California, US       us-west-1
{52.119.41.52, 103.80.6.52}  2 Virginia, US         us-east-1
{52.119.41.53, 103.80.6.53}  3 London, UK           eu-west-2
{52.119.41.54, 103.80.6.54}  4 Frankfurt, Germany   eu-central-1
{52.119.41.55, 103.80.6.55}  5 Mumbai, India        ap-south-1
{52.119.41.56, 103.80.6.56}  6 Tokyo, Japan         ap-northeast-1
{52.119.41.57, 103.80.6.57}  7 Singapore            ap-southeast-1
{52.119.41.58, 103.80.6.58}  8 Toronto, Canada      ca-central-1
{52.119.41.59, 103.80.6.59}  9 Sydney, Australia    ap-southeast-2
{52.119.41.60, 103.80.6.60} 10 Sao Paulo, Brazil    sa-east-1
{52.119.41.61, 103.80.6.61} 11 Manama, Bahrain      me-south-1
{52.119.41.62, 103.80.6.62} 12 Cape Town, S. Africa af-south-1
```

## PARAMETERS

### -Region
Filter results by Region

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

### -Location
Filter results by Location

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
