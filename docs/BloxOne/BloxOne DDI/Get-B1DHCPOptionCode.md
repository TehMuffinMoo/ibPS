---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DHCPOptionCode

## SYNOPSIS
Retrieves a list of DHCP option codes from BloxOneDDI

## SYNTAX

```
Get-B1DHCPOptionCode [[-Name] <String>] [[-Code] <Int32>] [[-Source] <String>] [[-Fields] <String[]>] [-Strict]
```

## DESCRIPTION
This function is used to query a list DHCP option codes from BloxOneDDI.
This is useful for determining the option code required when submitting options via the -DHCPOptions parameter on other cmdlets.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DHCPOptionCode -Name "routers"
```

## PARAMETERS

### -Name
The name of the DHCP option to filter by

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

### -Code
The code of the DHCP option to filter by

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Source
The source parameter is used to filter by the DHCP option source

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

### -Fields
Specify a list of fields to return.
The default is to return all fields.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Strict
Use strict filter matching.
By default, filters are searched using wildcards where possible.
Using strict matching will only return results matching exactly what is entered in the applicable parameters.

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
