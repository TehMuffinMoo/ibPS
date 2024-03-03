---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1Host

## SYNOPSIS
Updates an existing BloxOneDDI Host

## SYNTAX

### noID
```
Set-B1Host [-Name <String>] [-IP <String>] [-Space <String>] [-TimeZone <String>] [-Description <String>]
 [-NoIPSpace] [-Tags <Object>] [<CommonParameters>]
```

### ID
```
Set-B1Host [-Space <String>] [-TimeZone <String>] [-Description <String>] [-Tags <Object>] -id <String>
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing BloxOneDDI Host

## EXAMPLES

### EXAMPLE 1
```
Set-B1Host -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.20.11" -TimeZone "Europe/London" -Space "Global"
```

## PARAMETERS

### -Name
The name of the BloxOneDDI host to update.
If -IP is specified, the Name parameter will overwrite the existing display name.

```yaml
Type: String
Parameter Sets: noID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IP
The IP of the BloxOneDDI host to update.

```yaml
Type: String
Parameter Sets: noID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
The IPAM space where the BloxOneDDI host is located

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

### -TimeZone
The TimeZone to set the BloxOneDDI host to, i.e "Europe/London"

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

### -Description
The description to update the BloxOneDDI Host to

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

### -NoIPSpace
This parameter is required when applying changes to BloxOneDDI Hosts which are not assigned to an IPAM Space

```yaml
Type: SwitchParameter
Parameter Sets: noID
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
A list of tags to apply to this BloxOneDDI Host.
This will overwrite existing tags.

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
The id of the host to update.
Accepts pipeline input

```yaml
Type: String
Parameter Sets: ID
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
