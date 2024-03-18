---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version: https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
schema: 2.0.0
---

# Set-NIOSConfiguration

## SYNOPSIS
Stores NIOS Server Address & API Version to the local user/machine

## SYNTAX

```
Set-NIOSConfiguration [[-Server] <String>] [[-APIVersion] <String>] [-Persist]
```

## DESCRIPTION
This function will store NIOS Server Address & API Version for the current user on the local machine.
If previous configuration exists, it will be overwritten.

## EXAMPLES

### EXAMPLE 1
```powershell
Set-NIOSConfiguration -Server gm.mydomain.corp -APIVersion 2.13 -Persist
```

## PARAMETERS

### -Server
The FQDN of the Grid Master

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

### -APIVersion
The WAPI API Version.
Defaults to v2.12

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

### -Persist
Using the -Persist switch will save the NIOS Credentials across powershell sessions.
Without using this switch, they will only be stored for the current powershell session.

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
