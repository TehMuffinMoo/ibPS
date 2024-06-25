---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-NIOSConnectionProfile

## SYNOPSIS
This function is used to retrieved saved connection profiles.
By default, the active profile is returned.

## SYNTAX

```
Get-NIOSConnectionProfile [[-Name] <String>] [-List]
```

## DESCRIPTION
Connection profiles provide a convenient way of saving connection details to local or federated NIOS Grids.

These can easily be switched between by using [`Switch-NIOSConnectionProfile`](https://ibps.readthedocs.io/en/latest/NIOS/Profiles/Switch-NIOSConnectionProfile/).

## EXAMPLES

### EXAMPLE 1
```powershell
Get-NCP | ft

Active   Name          Type        APIVersion   GridName                              GridUID                           Server  Username  SkipCertificateCheck
------   ----          ----        ----------   --------                              -------                           ------  --------  --------------------
True     BloxOne-GM1   Federated   2.12         Infoblox_infoblox.localdomain_A9E9CF  adsudas09dus0fu4rsf8yfsyysfd8fu9  -       -         -
```

### EXAMPLE 2
```powershell
Get-NIOSConnectionProfile -List | ft

Active  Name          Type      APIVersion GridName                             GridUID                          Server                   Username  SkipCertificateCheck
------  ----          ----      ---------- --------                             -------                          ------                   --------  --------------------
True    BloxOne-GM1   Federated 2.12.3     Infoblox_infoblox.localdomain_A9E9CF adsudas09dus0fu4rsf8yfsyysfd8fu9 -                        -         -
False   Corp-GM1      Local     2.12       -                                    -                                10.10.175.225            admin     True
False   DMZ-GM1       Local     2.12       -                                    -                                172.26.21.22             infoblox  False
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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
