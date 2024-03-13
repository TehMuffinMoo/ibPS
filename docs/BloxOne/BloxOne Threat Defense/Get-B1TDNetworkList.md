---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDNetworkList

## SYNOPSIS
Retrieves network lists (External Networks) from BloxOne Threat Defense

## SYNTAX

### notid (Default)
```
Get-B1TDNetworkList [-Name <String>] [-Description <String>] [-PolicyID <Int32>] [-DefaultSecurityPolicy]
 [-Strict] [<CommonParameters>]
```

### With ID
```
Get-B1TDNetworkList [-id <Int32>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to retrieve network lists from BloxOne Threat Defense.
These are referred to and displayed as "External Networks" within the CSP.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDNetworkList -Name "something"

created_time : 12/23/2021 9:29:20AM
description  : something
id           : 123456
items        : {88.88.88.88/32}
name         : something
policy_id    : 654321
updated_time : 9/6/2023 9:49:10PM
```

### EXAMPLE 2
```powershell
Get-B1TDNetworkList | ft -AutoSize

created_time          description                                            id items                                                                     name                               policy_id updated_time
------------          -----------                                            -- -----                                                                     ----                               --------- ------------
7/5/2020 5:02:01PM    Site A Network List                                123456 {1.2.3.4/32, 1.0.0.0/29, 134.1.2.3/32…}                                   site-a-network                         12345 1/27/2024 2:23:21PM
7/21/2020 10:36:16AM  Site B Network List                                234567 {9.4.2.6/32}                                                              site-b-network                         23456 10/13/2023 11:26:51AM
10/7/2020 6:37:33PM   Site C Network List                                345678 {123.234.123.234}                                                         site-c-network                         34567 9/6/2023 9:53:51PM
...
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
Parameter Sets: With ID
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
