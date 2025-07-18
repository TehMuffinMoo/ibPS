---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DossierSupportedSources

## SYNOPSIS
Queries a list of available dossier sources

## SYNTAX

```
Get-B1DossierSupportedSources [[-Target] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Dossier Sources cmdlet returns a list of all Dossier (sometimes referred to as Intel Lookup) sources and whether or not they are available for the caller.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DossierSupportedSources -Target ip
```

### EXAMPLE 2
```powershell
Get-B1DossierSupportedSources

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
Get-B1DossierSupportedSources -Target ip

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
List the supported sources relating to the target type (ip/host/url/email/hash)

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
