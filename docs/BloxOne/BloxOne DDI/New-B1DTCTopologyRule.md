---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1DTCTopologyRule

## SYNOPSIS
Creates a new DTC Toplogy rule

## SYNTAX

```
New-B1DTCTopologyRule [-Name] <String> [-Type] <String> [-Destination] <String> [[-Pool] <String>]
 [[-Subnets] <Object>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to creates a new DTC Toplogy rule to be used with DTC Policies

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1DTCTopologyRule -Name 'Subnet Rule' -Type 'Subnet' -Destination NXDOMAIN -Subnets '10.10.10.0/24','10.20.0.0/24'

code        : nxdomain
 destination : code
 name        : Subnet Rule
 source      : subnet
 subnets     : {10.10.10.0/24, 10.20.0.0/24}
```

## PARAMETERS

### -Name
The name of the DTC Topology Rule to create

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

### -Type
The Topology Rule Type (Default / Subnet)

If Default is selected, the -Name parameter will be set to 'Default'

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

### -Destination
The type of response to send based on the rule criteria (Pool / NOERROR / NXDOMAIN)

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

### -Pool
The Pool name when selecting -Destination Pool

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

### -Subnets
The list of subnets in CIDR format to use when selecting -Type Subnet.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
