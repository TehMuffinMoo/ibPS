---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1SecurityPolicyRule

## SYNOPSIS
This function is used to create new Security Policy Rules to append or remove to/from an existing or a New Security Policy, using Set-B1SecurityPolicy / New-B1SecurityPolicy.

## SYNTAX

```
New-B1SecurityPolicyRule [[-Action] <Object>] [[-Log] <Object>] [[-Type] <Object>] [[-Object] <Object>]
 [[-Redirect] <Object>]
```

## DESCRIPTION
This function is used to create new Security Policy Rules to append or remove to/from an existing or a New Security Policy, using Set-B1SecurityPolicy / New-B1SecurityPolicy.

## EXAMPLES

### EXAMPLE 1
```powershell

```

### EXAMPLE 2
```powershell

```

## PARAMETERS

### -Action
The security policy rule action to use for this list item

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Log
The security policy rule log action to use for this list item.
Defaults to Log.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Log
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of security policy rule to apply (Custom List / Named Feed (Threat Insight) / Application Filter / Category Filter)

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
The security policy rule name (Either Custom List, Named Feed, Application Filter or Category Filter depending on Type selected)

When using Custom List, the auto-complete works based on the Key, not the Name.
This can be found using Get-B1CustomList

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Redirect
The name of the redirect to apply.
If 'Default' is specified, the default redirect configuration will be used.

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
