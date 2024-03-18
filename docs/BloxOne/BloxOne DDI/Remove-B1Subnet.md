---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version: https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
schema: 2.0.0
---

# Remove-B1Subnet

## SYNOPSIS
Removes a subnet from BloxOneDDI IPAM

## SYNTAX

### Default
```
Remove-B1Subnet -Subnet <String> -CIDR <Int32> [-Name <String>] -Space <String> [<CommonParameters>]
```

### With ID
```
Remove-B1Subnet [-Name <String>] -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to remove a subnet from BloxOneDDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-B1Subnet -Subnet 10.0.0.0 -CIDR 24 -Space "Global"
```

### EXAMPLE 2
```powershell
Get-B1Subnet -Subnet 10.0.0.0 -CIDR 24 -Space "Global" | Remove-B1Subnet
```

## PARAMETERS

### -Subnet
The network address of the subnet you want to remove

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

### -CIDR
The CIDR suffix of the subnet you want to remove

```yaml
Type: Int32
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the subnet to remove

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

### -Space
The IPAM space where the subnet is located

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

### -id
The id of the subnet.
Accepts pipeline input

```yaml
Type: String
Parameter Sets: With ID
Aliases:

Required: True
Position: Named
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
