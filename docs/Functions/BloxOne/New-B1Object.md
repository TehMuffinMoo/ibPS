---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1Object

## SYNOPSIS
Generic Wrapper for creating new objects within the CSP (Cloud Services Portal)

## SYNTAX

```
New-B1Object [-Product] <String> [-App] <String> [-Endpoint] <String> [-Data] <PSObject> [-JSON]
 [[-Method] <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This is a Generic Wrapper for creating new objects within the CSP (Cloud Services Portal).

## EXAMPLES

### EXAMPLE 1
```powershell
##This example will create a new DNS Record

PS> $Splat = @{
        "name_in_zone" = "MyNewRecord"
        "zone" = "dns/auth_zone/12345678-8989-4833-abcd-12345678" ### The DNS Zone ID
        "type" = "A"
        "rdata" = @{
            "address" = "10.10.10.10"
        }
    }
PS> New-B1Object -Product 'BloxOne DDI' -App DnsData -Endpoint /dns/record -Data $Splat
```

## PARAMETERS

### -Product
Specify the product to use, such as 'BloxOne DDI'.
This parameter is auto-populated when using tab

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

### -App
Specify the App to use, such as 'DnsConfig'
This parameter is auto-populated when using tab

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

### -Endpoint
Specify the API Endpoint to use, such as "/ipam/record".
This parameter is auto-populated when using tab

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

### -Data
The data to submit

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -JSON
Use this switch if the -Data parameter contains JSON data instead of a PSObject

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

### -Method
The method to use when creating new object.
Defaults to POST

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: POST
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
