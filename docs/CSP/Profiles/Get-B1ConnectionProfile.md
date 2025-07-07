---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1ConnectionProfile

## SYNOPSIS
This function is used to retrieved saved Infoblox Portalconnection profiles.
By default, the active profile is returned.

## SYNTAX

```
Get-B1ConnectionProfile [[-Name] <String>] [-List] [-IncludeAPIKey]
```

## DESCRIPTION
Connection profiles provide a convenient way of saving API Keys for multiple Infoblox Portal Accounts.
These can then easily be switched between by using [`Switch-B1ConnectionProfile`](../Switch-B1ConnectionProfile/).

## EXAMPLES

### EXAMPLE 1
```powershell
Get-BCP | ft

Active  Name   CSP User   CSP Account    API Key
------  ----   --------   -----------    -------
True    Prod   svc-ps     ACME Corp      ********
```

### EXAMPLE 2
```powershell
Get-B1ConnectionProfile -List | ft

Active  Name   CSP User   CSP Account                API Key
------  ----   --------   -----------                -------
True    Prod   svc-ps     ACME Corp                  ********
False   Dev    svc-ps     ACME Corp | Sandbox (Dev)  ********
False   Test   svc-ps     ACME Corp | Sandbox (Test) ********
```

## PARAMETERS

### -Name
Return a specific connection profile based on its name

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

### -List
Return a list of all saved connection profiles.

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

### -IncludeAPIKey
The -IncludeAPIKey indicates whether the API Key(s) should be returned in the response

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
