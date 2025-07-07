---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1TideThreats

## SYNOPSIS
Queries active threats from the TIDE API

## SYNTAX

### host (Default)
```
Get-B1TideThreats [-Hostname <String>] [-Limit <Int32>] [<CommonParameters>]
```

### ip
```
Get-B1TideThreats [-IP <String>] [-Limit <Int32>] [<CommonParameters>]
```

### url
```
Get-B1TideThreats [-URL <String>] [-Limit <Int32>] [<CommonParameters>]
```

### email
```
Get-B1TideThreats [-Email <String>] [-Limit <Int32>] [<CommonParameters>]
```

### hash
```
Get-B1TideThreats [-Hash <String>] [-Limit <Int32>] [<CommonParameters>]
```

### type
```
Get-B1TideThreats [-Type <String>] [-Value <String>] [-Age <String>] [-Distinct <String>] [-Limit <Int32>]
 [<CommonParameters>]
```

### With ID
```
Get-B1TideThreats [-Id <String>] [-Limit <Int32>] [<CommonParameters>]
```

## DESCRIPTION
This function will query the active threats from the TIDE API

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1TideThreats -Hostname "google.com"
```

### EXAMPLE 2
```powershell
Get-B1TideThreats -IP "1.1.1.1"
```

### EXAMPLE 3
```powershell
Get-B1TideThreats -Hostname eicar.co -Limit 10
```

### EXAMPLE 4
```powershell
Get-B1TideThreats -Type Host -Value eicar.co -Distinct Profile

id                      : d123456-f9d4-11ed-9fe7-123456789
type                    : HOST
host                    : eicar.co
domain                  : eicar.co
tld                     : co
profile                 : IID
property                : MaliciousNameserver_Generic
class                   : MaliciousNameserver
threat_level            : 100
confidence              : 100
detected                : 5/24/2023 1:45:30AM
received                : 5/24/2023 1:46:36AM
imported                : 5/24/2023 1:46:36AM
expiration              : 5/24/2043 1:45:30AM
dga                     : false
up                      : true
batch_id                : d123456-f9d4-11ed-9fe7-123456789
threat_score            : 6.3
threat_score_rating     : Medium
threat_score_vector     : TSIS:1.0/AV:N/AC:L/PR:L/UI:N/EX:L/MOD:L/AVL:L/CI:N/ASN:N/TLD:N/DOP:N/P:F
confidence_score        : 8
confidence_score_rating : High
confidence_score_vector : COSIS:1.0/SR:H/POP:N/TLD:N/CP:F
risk_score              : 7.9
risk_score_rating       : High
risk_score_vector       : RSIS:1.0/TSS:M/TLD:N/CVSS:M/EX:L/MOD:L/AVL:L/T:M/DT:M
extended                : @{cyberint_guid=0718b50d524c42a70eb459c28d9891bf; notes=This is an artificial indicator created by Infoblox for monitoring and testing the health of Infoblox managed services. It is also used in security demonstrations by the Infoblox sales and tech support
                        teams. The "EICAR" name was inspired by the European Institute for Computer Antivirus Research (EICAR) antivirus test file called EICAR. This is not an inherently malicious domain.}
```

### EXAMPLE 5
```powershell
Get-B1TideThreats -Type URL -Age Hourly | ft detected,type,host,threat_level,tld,url -AutoSize

detected            type host                                                                      threat_level tld             url
--------            ---- ----                                                                      ------------ ---             ---
3/6/2024 6:56:10AM  URL  themes-app.netlify.app                                                              80 netlify.app     http://themes-app.netlify.app/img/yt.png
3/6/2024 3:55:10AM  URL  trsfr.com                                                                           80 com             https://trsfr.com/PDF/paid.exe
3/6/2024 4:56:10AM  URL  dev-zimba.pantheonsite.io                                                           80 pantheonsite.io https://dev-zimba.pantheonsite.io/loginpage/Epdf.php
3/6/2024 6:56:10AM  URL  themes-app.netlify.app                                                              80 netlify.app     https://themes-app.netlify.app/img/yt.png
3/5/2024 9:55:10PM  URL  bafkreih7azguzaxjuphwrbrak4r2cv4gvz3mkh2uxrj3aaddfisglbi3t4.ipfs.w3s.link           80 link            https://bafkreih7azguzaxjuphwrbrak4r2cv4gvz3mkh2uxrj3aaddfisglbi3t4.ipfs.w3s.link/?filename=save.js
3/6/2024 6:56:10AM  URL  themes-app.netlify.app                                                              80 netlify.app     https://themes-app.netlify.app/img/tw.png
...
```

## PARAMETERS

### -Hostname
Use -Hostname to retrieve threats based on a hostname indicator

```yaml
Type: String
Parameter Sets: host
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IP
Use -IP to retrieve threats based on a IP indicator

```yaml
Type: String
Parameter Sets: ip
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -URL
Use -URL to retrieve threats based on a URL indicator

```yaml
Type: String
Parameter Sets: url
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
Use -Email to retrieve threats based on a Email indicator

```yaml
Type: String
Parameter Sets: email
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hash
Use -Hash to retrieve threats based on a Hash indicator

```yaml
Type: String
Parameter Sets: hash
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Use the -Type parameter to search by threat type and optionally indicator.
Must be used in conjunction with the -Value parameter

```yaml
Type: String
Parameter Sets: type
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
The value to search based on the -Type selected

```yaml
Type: String
Parameter Sets: type
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Age
Filter the results by the age of the threat

```yaml
Type: String
Parameter Sets: type
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Distinct
Threats may be considered separately by profile and property, depending on the value of the "distinct" query parameter.
For example, assume an IP has been most recently submitted by an organization as Bot_Sality and Bot_Virut.
If the "distinct" parameter is "property", both records will be returned.
If the "distinct" parameter is "profile", only the most recently detected record from the organization will be returned.
The default is "Property"

```yaml
Type: String
Parameter Sets: type
Aliases:

Required: False
Position: Named
Default value: Property
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Filter the results by Threat ID

```yaml
Type: String
Parameter Sets: With ID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Used to set the maximum number of records to be returned (default is 100)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
