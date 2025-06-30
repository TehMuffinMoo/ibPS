---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1AssetSummary

## SYNOPSIS
Summerise a list of Assets discovered by Universal DDI

## SYNTAX

```
Get-B1AssetSummary [[-Type] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to summerise a list of Assets discovered by Universal DDI

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Asset ByRegion

assets doc_asset_region doc_asset_vendor
------ ---------------- ----------------
140    us-east-1        aws
121    us-east-2        aws
68     us-west-1        aws
42     us-west-2        aws
23     eu-north-1       aws
18     ap-southeast-2   aws
18     eu-west-1        aws
10                      azure
7                       aws
17     ap-northeast-1   aws
14     ap-northeast-2   aws
13     westeurope       azure
12     ap-northeast-3   aws
12     ap-south-1       aws
12     ap-southeast-1   aws
12     ca-central-1     aws
12     eu-west-2        aws
12     eu-west-3        aws
12     sa-east-1        aws
7      global           azure
6      eu-central-1     aws
1      uksouth          azure
```

## PARAMETERS

### -Type
The type of summary report to return

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
