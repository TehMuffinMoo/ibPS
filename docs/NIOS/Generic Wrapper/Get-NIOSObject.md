---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-NIOSObject

## SYNOPSIS
Generic Wrapper for interaction with the NIOS WAPI

## SYNTAX

### Type
```
Get-NIOSObject -ObjectType <String> [-Limit <Int32>] [-PageSize <Int32>] [-Filters <Object>]
 [-Fields <String[]>] [-AllFields] [-BaseFields] [-Server <String>] [-GridUID <String>] [-GridName <String>]
 [-ApiVersion <String>] [-SkipCertificateCheck] [-Creds <PSCredential>] [<CommonParameters>]
```

### Ref
```
Get-NIOSObject -ObjectRef <String> [-Limit <Int32>] [-PageSize <Int32>] [-Filters <Object>]
 [-Fields <String[]>] [-AllFields] [-BaseFields] [-Server <String>] [-GridUID <String>] [-GridName <String>]
 [-ApiVersion <String>] [-SkipCertificateCheck] [-Creds <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
This is a Generic Wrapper for interaction with the NIOS WAPI

## EXAMPLES

### EXAMPLE 1
```powershell
Get-NIOSObject 'network?_max_results=1000&_return_as_object=1'
```

## PARAMETERS

### -ObjectType
{{ Fill ObjectType Description }}

```yaml
Type: String
Parameter Sets: Type
Aliases: type

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ObjectRef
Specify the object URI / API endpoint and query parameters here

```yaml
Type: String
Parameter Sets: Ref
Aliases: ref, _ref

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Limit
{{ Fill Limit Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
{{ Fill PageSize Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filters
{{ Fill Filters Description }}

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

### -Fields
{{ Fill Fields Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: ReturnFields

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllFields
{{ Fill AllFields Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ReturnAllFields

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BaseFields
{{ Fill BaseFields Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ReturnBaseFields

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
{{ Fill Server Description }}

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

### -GridUID
{{ Fill GridUID Description }}

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

### -GridName
{{ Fill GridName Description }}

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

### -ApiVersion
{{ Fill ApiVersion Description }}

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

### -SkipCertificateCheck
{{ Fill SkipCertificateCheck Description }}

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

### -Creds
{{ Fill Creds Description }}

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

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
