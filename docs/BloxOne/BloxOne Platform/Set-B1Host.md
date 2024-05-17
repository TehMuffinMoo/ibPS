---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1Host

## SYNOPSIS
Updates an existing BloxOne Host

## SYNTAX

### Default
```
Set-B1Host [-Name <String>] [-IP <String>] [-Space <String>] [-TimeZone <String>] [-Description <String>]
 [-Location <String>] [-Tags <Object>] [<CommonParameters>]
```

### Pipeline
```
Set-B1Host [-Space <String>] [-TimeZone <String>] [-Description <String>] [-Location <String>] -Object <Object>
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing BloxOne Host

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1Host -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.20.11" -TimeZone "Europe/London" -Space "Global"
```

## PARAMETERS

### -Name
The name of the BloxOne Host to update.
If -IP is specified, the Name parameter will overwrite the existing display name.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IP
The IP of the BloxOne Host to update.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
The name of the IP Space to assign the BloxOne Host to

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
The TimeZone to set the BloxOne Host to, i.e "Europe/London"

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
The description to update the BloxOne Host to

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

### -Location
The updated Location for the specific BloxOne Host.
Using the value 'None' will set it to Empty

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

### -Tags
A list of tags to apply to this BloxOne Host.
This will overwrite existing tags.

```yaml
Type: Object
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
The host object to update.
Accepts pipeline input from Get-B1Host

```yaml
Type: Object
Parameter Sets: Pipeline
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
