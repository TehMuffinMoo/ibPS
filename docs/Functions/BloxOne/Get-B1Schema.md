---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1Schema

## SYNOPSIS
Used for obtaining API Schema information for use with generic wrapper cmdlets

## SYNTAX

```
Get-B1Schema [[-Product] <String>] [[-App] <String>] [[-Endpoint] <String>] [[-Method] <String>]
 [-ListParameters]
```

## DESCRIPTION
This is used for obtaining API Schema information for use with generic wrapper cmdlets

## EXAMPLES

### EXAMPLE 1
```
Get-B1Schema -Product 'BloxOne DDI'
```

### EXAMPLE 2
```
Get-B1Schema -Product 'BloxOne DDI' -App DnsConfig
```

### EXAMPLE 3
```
Get-B1Schema -Product 'BloxOne Cloud' -App 'CDC' -Endpoint /v2/flows/data -Method get -ListParameters
```

## PARAMETERS

### -Product
Specify the product to use

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

### -App
Specify the App to use

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

### -Endpoint
Specify the API Endpoint to use, such as "/ipam/record".

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

### -Method
Specify the endpoint method to view the schema information for

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

### -ListParameters
Specify this switch to list information relating to available parameters for the particular endpoint

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
