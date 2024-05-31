---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Resolve-DoHQuery

## SYNOPSIS
Used to query a DNS over HTTPS Server to verify connectivity and responses

## SYNTAX

### Default
```
Resolve-DoHQuery [[-Query] <String>] [[-Type] <String>] [[-DoHServer] <String>] [-Section <String[]>] [-DNSSEC]
 [-SourceIP <String>] [-SourceMAC <String>] [-SourceView <String>] [-OutDig] [<CommonParameters>]
```

### Pipeline
```
Resolve-DoHQuery [[-Query] <String>] [[-Type] <String>] [-Section <String[]>] [-DNSSEC] [-SourceIP <String>]
 [-SourceMAC <String>] [-SourceView <String>] [-OutDig] -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a DNS over HTTPS Server to verify connectivity and responses.
This has no dependency on the client, so will work regardless of if DoH is configured on the Network Adapter(s).

## EXAMPLES

### EXAMPLE 1
```powershell
Resolve-DoHQuery -Query google.com -Type TXT -DoHServer cloudflare-dns.com
                                                                                                                
QNAME         : google.com
QTYPE         : TXT
QCLASS        : IN
AnswerRRs     : {@{RDATA=docusign=05958488-4752-4ef2-95eb-aa7ba8a3bd0e; RNAME=google.com; RTYPE=TXT; RCLASS=IN; TTL=3600; LENGTH=46; TXT_LENGTH=45}, @{RDATA=v=spf1 include:_spf.google.com ~all; RNAME=google.com; RTYPE=TXT; RCLASS=IN; TTL=3600; LENGTH=36; TXT_LENGTH=35}, 
                @{RDATA=google-site-verification=TV9-DBe4R80X4v0M4U_bd_J9cpOJM0nikft0jAgjmsQ; RNAME=google.com; RTYPE=TXT; RCLASS=IN; TTL=3600; LENGTH=69; TXT_LENGTH=68}, @{RDATA=globalsign-smime-dv=CDYX+XFHUw2wml6/Gb8+59BsH31KzUr6c1l2BPvqKX8=; RNAME=google.com; RTYPE=TXT; RCLASS=IN; TTL=3600; 
                LENGTH=65; TXT_LENGTH=64}…}
AuthorityRRs  : {}
AdditionalRRs : {}
Headers       : {[AnswerRRs, 11], [AdditionalRRs, 0], [Questions, 1], [TransactionID, 0]…}
```

### EXAMPLE 2
```powershell
Resolve-DoHQuery -Query google.com -Type TXT | Select-Object -ExpandProperty AnswerRRs | ft -AutoSize
                                                                                                                        
RDATA                                                                RNAME      RTYPE RCLASS  TTL LENGTH TXT_LENGTH
-----                                                                -----      ----- ------  --- ------ ----------
google-site-verification=TV9-DBe4R80X4v0M4U_bd_J9cpOJM0nikft0jAgjmsQ google.com TXT   IN     3600     69         68
docusign=1b0a6754-49b1-4db5-8540-d2c12664b289                        google.com TXT   IN     3600     46         45
facebook-domain-verification=22rm551cu4k0ab0bxsw536tlds4h95          google.com TXT   IN     3600     60         59
globalsign-smime-dv=CDYX+XFHUw2wml6/Gb8+59BsH31KzUr6c1l2BPvqKX8=     google.com TXT   IN     3600     65         64
webexdomainverification.8YX6G=6e6922db-e3e6-4a36-904e-a805c28087fa   google.com TXT   IN     3600     67         66
apple-domain-verification=30afIBcvSuDV2PLX                           google.com TXT   IN     3600     43         42
v=spf1 include:_spf.google.com ~all                                  google.com TXT   IN     3600     36         35
docusign=05958488-4752-4ef2-95eb-aa7ba8a3bd0e                        google.com TXT   IN     3600     46         45
google-site-verification=wD8N7i1JTNTkezJ49swvWW48f8_9xveREV4oB-0Hf5o google.com TXT   IN     3600     69         68
MS=E4A68B9AB2BB9670BCE15412F62916164C0B20BB                          google.com TXT   IN     3600     44         43
onetrust-domain-verification=de01ed21f2fa4d8781cbc3ffb89cf4ef        google.com TXT   IN     3600     62         61
```

### EXAMPLE 3
```powershell
Resolve-DoHQuery -Query bbc.co.uk -Type SOA -OutDig
                                                                                                                
; <<>> ibPS v1.9.6.0 <<>> bbc.co.uk
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id 25075
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
bbc.co.uk.                IN    SOA

;; ANSWER SECTION
bbc.co.uk.         900    IN    SOA     ns.bbc.co.uk. hostmaster.bbc.co.uk. 2024052301 1800 600 864000 900

;; Query time: 117 msec
;; SERVER: 1234-a431-a12b-1234-a0b2-12345678901ab.doh.threatdefense.infoblox.com
;; WHEN: Fri May 24 03:19:30
;; MSG SIZE  rcvd: 104
```

### EXAMPLE 4
```powershell
Resolve-DoHQuery -Query bbc.co.uk -Type A | Select-Object -ExpandProperty AnswerRRs | ft -AutoSize
                                                                                                                
RDATA          RNAME     RTYPE RCLASS TTL LENGTH
-----          -----     ----- ------ --- ------
151.101.192.81 bbc.co.uk A     IN     163      4
151.101.0.81   bbc.co.uk A     IN     163      4
151.101.64.81  bbc.co.uk A     IN     163      4
151.101.128.81 bbc.co.uk A     IN     163      4
```

### EXAMPLE 5
```powershell
Get-B1SecurityPolicy -Name 'My Policy' | Resolve-DoHQuery -Query 'google.com' -Type A
                                                                                                                
QNAME         : google.com
QTYPE         : A
QCLASS        : IN
AnswerRRs     : {@{RDATA=172.217.169.14; RNAME=google.com; RTYPE=A; RCLASS=IN; TTL=300; LENGTH=4}}
AuthorityRRs  : {}
AdditionalRRs : {}
Headers       : {[AnswerRRs, 1], [AdditionalRRs, 0], [Questions, 1], [TransactionID, 0]…}
```

## PARAMETERS

### -Query
Specify the DNS Query to send to the selected DoH Server

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

### -Type
Optionally specify the DNS request type

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: A
Accept pipeline input: False
Accept wildcard characters: False
```

### -DoHServer
Optionally specify a DNS over HTTPS Server for this specific query.

This field is mandatory, unless the DoH Server has been pre-configured using: Set-ibPSConfiguration -DoHServer 'fqdn.infoblox.com' -Persist

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: 4
Default value: $(if ($ENV:IBPSDoH) { $ENV:IBPSDoH })
Accept pipeline input: False
Accept wildcard characters: False
```

### -Section
Optionally specify one or more sections to return (Answer/Authority/Additional)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSSEC
Optionally validate DNSSEC

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

### -SourceIP
Specify the Source IP to spoof using EDNS OPT 65523.
This only works when using BloxOne Threat Defense.

WORK IN PROGRESS

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

### -SourceMAC
Specify the Source MAC Address to spoof using EDNS OPT 65524.
This only works when using BloxOne Threat Defense.

WORK IN PROGRESS

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

### -SourceView
Specify the Source DNS View Name to spoof using EDNS OPT 65526.
This only works when using BloxOne Threat Defense.

WORK IN PROGRESS

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

### -OutDig
Use the -OutDig parameter to output the response in a format similar to dig

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

### -Object
The Object parameter is used when passing a security policy as pipeline.
This will use the 'doh_fqdn' defined as part of the Security Policy.
If DoH is not configured the function will error.
See Example #5

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
