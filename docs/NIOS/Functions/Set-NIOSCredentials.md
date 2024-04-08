---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-NIOSCredentials

## SYNOPSIS
Stores NIOS Credentials to the local user/machine

## SYNTAX

```
Set-NIOSCredentials [[-Credentials] <Object>] [-Persist]
```

## DESCRIPTION
This function will store NIOS Credentials for the current user on the local machine.
If previous NIOS Credentials exist, they will be overwritten.

## EXAMPLES

### EXAMPLE 1
```powershell
Set-NIOSCredentials -Credentials ${CredentialObject} -Persist
```

## PARAMETERS

### -Credentials
Credentials object for NIOS Username/Password

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
