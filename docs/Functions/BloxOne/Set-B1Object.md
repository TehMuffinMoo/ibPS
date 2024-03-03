---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1Object

## SYNOPSIS
Generic Wrapper for updating existing objects within the CSP (Cloud Services Portal)

## SYNTAX

```
Set-B1Object [-Data] <Object> [-_ref] <String> [-id] <String> [<CommonParameters>]
```

## DESCRIPTION
This is a Generic Wrapper for updating objects within the CSP (Cloud Services Portal).
It is recommended this is used via Pipeline

## EXAMPLES

### EXAMPLE 1
```
This example will update the comment/description against multiple DNS Records
```

$Records = Get-B1Object -Product 'BloxOne DDI' -App DnsConfig -Endpoint /dns/record -Filters @('absolute_zone_name~"mydomain.corp." and type=="a"') -Fields comment
foreach ($Record in $Records) {
    $Record.comment = "Updated Comment"
}
$Records | Set-B1Object

### EXAMPLE 2
```
This example will update the multiple DHCP Options against multiple Subnets
```

$Subnets = Get-B1Object -product 'BloxOne DDI' -App Ipamsvc -Endpoint /ipam/subnet -tfilter '("BuiltWith"=="ibPS")' -Fields name,dhcp_options,tags
foreach ($Subnet in $Subnets) {
    $Subnet.dhcp_options = @(
        @{
            "type"="option"
            "option_code"=(Get-B1DHCPOptionCode -Name "routers").id
            "option_value"="10.10.100.254"
        }
        @{
            "type"="option"
            "option_code"=(Get-B1DHCPOptionCode -Name "domain-name-servers").id
            "option_value"="10.1.1.100,10.3.1.100"
        }
    )
}
$Subnets | Set-B1Object

## PARAMETERS

### -Data
The data to update

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -_ref
The base URL of the object to update

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -id
The id of the object to update

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
