---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TDDossierSupportedSources

## SYNOPSIS
Queries a list of available dossier sources

## SYNTAX

```
Get-B1TDDossierSupportedSources [[-Target] <String>]
```

## DESCRIPTION
The Dossier Sources cmdlet returns a list of all Dossier (sometimes referred to as Intel Lookup) sources and whether or not they are available for the caller.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TDDossierSupportedSources -Target ip
```

### EXAMPLE 2
```powershell
Get-B1TDDossierSupportedSources

acs                 : True
activity            : True
atp                 : True
ccb                 : True
custom_lists        : True
dns                 : True
gcs                 : True
geo                 : True
gsb                 : True
infoblox_web_cat    : True
inforank            : True
isight              : False
malware_analysis    : True
malware_analysis_v3 : True
pdns                : True
ptr                 : True
rlabs               : False
rpz_feeds           : True
rwhois              : False
whitelist           : True
whois               : True
ssl_cert            : True
urlhaus             : True
nameserver          : True
threatfox           : True
tld_risk            : True
mandiant            : True
screenshot          : True
threat_actor        : True
```

### EXAMPLE 3
```powershell
Get-B1TDDossierSupportedSources -Target ip

acs                 : True
activity            : True
atp                 : True
ccb                 : True
custom_lists        : True
gcs                 : True
geo                 : True
isight              : True
malware_analysis    : True
malware_analysis_v3 : True
mandiant            : True
pdns                : True
ptr                 : True
rpz_feeds           : True
threatfox           : True
urlhaus             : True
whitelist           : True
whois               : True
```

## PARAMETERS

### -Target
{{ Fill Target Description }}

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

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
