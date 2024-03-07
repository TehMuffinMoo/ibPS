---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1ForwardNSG

## SYNOPSIS
Updates a Forward DNS Server Group in BloxOneDDI

## SYNTAX

### Default
```
Set-B1ForwardNSG -Name <String> [-AddHosts] [-RemoveHosts] [-Hosts <Object>] [<CommonParameters>]
```

### With ID
```
Set-B1ForwardNSG [-AddHosts] [-RemoveHosts] [-Hosts <Object>] -id <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to update a Forward DNS Server Group in BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1ForwardNSG -Name "InfoBlox DTC" -AddHosts -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
```

## PARAMETERS

### -Name
The name of the Forward DNS Server Group

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

### -AddHosts
This switch indicates you are adding hosts to the Forward NSG using the -Hosts parameter

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

### -RemoveHosts
This switch indicates you are removing hosts to the Forward NSG using the -Hosts parameter

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

### -Hosts
This is a list of hosts to be added or removed from the Forward NSG, indicated by the -AddHosts & -RemoveHosts parameters

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
The id of the forward DNS server group to update.
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
