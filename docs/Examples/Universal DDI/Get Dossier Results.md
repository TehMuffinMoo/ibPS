## Get Dossier Results

This is a example of how to return related information from a Dossier Search. This example shows two ways for retrieiving data related to tasks for PDNS (Related Domains) and DNS (Current DNS)

### Search and return results
```powershell
## Initiate New Search & Wait for completion using the -Wait parameter
$Search = Start-B1DossierLookup -Type host -Value 'sita.aero' -Wait
```

#### Get DNS Results (Current DNS)
```powershell
($Search.results | Where-Object {$_.params.source -eq 'dns'}).data | Select-Object *

A     : {@{ip=142.251.16.138; reverse=bl-in-f138.1e100.net.; ttl=294}, @{ip=142.251.16.102; reverse=bl-in-f102.1e100.net.; ttl=294}, @{ip=142.251.16.101; 
        reverse=bl-in-f101.1e100.net.; ttl=294}, @{ip=142.251.16.139; reverse=bl-in-f139.1e100.net.; ttl=294}…}
AAAA  : {2607:f8b0:4004:c1f::8a, 2607:f8b0:4004:c1f::8b, 2607:f8b0:4004:c1f::64, 2607:f8b0:4004:c1f::66}
CERT  : {}
CNAME : {}
HTTPS : {1 . alpn=h2,h3}
MX    : {10 smtp.google.com.}
NS    : {ns4.google.com., ns1.google.com., ns2.google.com., ns3.google.com.}
SOA   : {ns1.google.com. dns-admin.google.com. 648302543 900 900 1800 60}
SVCB  : {}
TSIG  : {}
TXT   : {cisco-ci-domain-verification=479146de172eb01ddee38b1a455ab9e8bb51542ddd7f1fa298557dfa7b22d963, 
        globalsign-smime-dv=CDYX+XFHUw2wml6/Gb8+59BsH31KzUr6c1l2BPvqKX8=, facebook-domain-verification=22rm551cu4k0ab0bxsw536tlds4h95, 
        google-site-verification=TV9-DBe4R80X4v0M4U_bd_J9cpOJM0nikft0jAgjmsQ…}
rcode : NOERROR
```

#### Get PDNS Results (Related Domains)
```powershell
($Search.results | Where-Object {$_.params.source -eq 'pdns'}).data.items | Select-Object *

Hostname        IP                                                                 Last_Seen Record_Type
--------        --                                                                 --------- -----------
ns.google.com.  {216.239.32.11}                                                   1719615020 A
ns1.google.com. {216.239.32.10}                                                   1719615020 A
ns1.google.com. {2001:4860:4802:32::a}                                            1719615020 AAAA
ns2.google.com. {216.239.34.10}                                                   1719615020 A
ns2.google.com. {2001:4860:4802:34::a}                                            1719615020 AAAA
ns3.google.com. {216.239.36.10}                                                   1719615020 A
ns3.google.com. {2001:4860:4802:36::a}                                            1719615020 AAAA
ns4.google.com. {216.239.38.10}                                                   1719615020 A
ns4.google.com. {2001:4860:4802:38::a}                                            1719615020 AAAA
a.l.google.com. {74.125.53.9}                                                     1318263406 A
b.l.google.com. {74.125.45.9}                                                     1342196198 A
f.l.google.com. {72.14.203.9}                                                     1342196198 A
google.com.     {64.233.161.100, 64.233.161.101, 64.233.161.102, 64.233.161.113…} 1594197706 A
google.com.     {64.233.161.100, 64.233.161.101, 64.233.161.102, 64.233.161.113…} 1594957617 A
google.com.     {74.125.128.100, 74.125.128.101, 74.125.128.102, 74.125.128.113…} 1358896630 A
google.com.     {74.125.205.100, 74.125.205.101, 74.125.205.102, 74.125.205.113…} 1594192837 A
...
```

### Return results for previous search

```powershell
## Retrieve existing search and get task results
$TaskResults = Get-B1DossierLookup -job_id 21e7ff46-be16-461a-b975-5c111f242a46 -TaskResults
```

#### Get DNS Results (Current DNS)
```powershell
($TaskResults.results | Where-Object {$_.params.source -eq 'dns'}).data

A     : {@{ip=142.251.16.138; reverse=bl-in-f138.1e100.net.; ttl=294}, @{ip=142.251.16.102; reverse=bl-in-f102.1e100.net.; ttl=294}, @{ip=142.251.16.101; 
        reverse=bl-in-f101.1e100.net.; ttl=294}, @{ip=142.251.16.139; reverse=bl-in-f139.1e100.net.; ttl=294}…}
AAAA  : {2607:f8b0:4004:c1f::8a, 2607:f8b0:4004:c1f::8b, 2607:f8b0:4004:c1f::64, 2607:f8b0:4004:c1f::66}
CERT  : {}
CNAME : {}
HTTPS : {1 . alpn=h2,h3}
MX    : {10 smtp.google.com.}
NS    : {ns4.google.com., ns1.google.com., ns2.google.com., ns3.google.com.}
SOA   : {ns1.google.com. dns-admin.google.com. 648302543 900 900 1800 60}
SVCB  : {}
TSIG  : {}
TXT   : {cisco-ci-domain-verification=479146de172eb01ddee38b1a455ab9e8bb51542ddd7f1fa298557dfa7b22d963, 
        globalsign-smime-dv=CDYX+XFHUw2wml6/Gb8+59BsH31KzUr6c1l2BPvqKX8=, facebook-domain-verification=22rm551cu4k0ab0bxsw536tlds4h95, 
        google-site-verification=TV9-DBe4R80X4v0M4U_bd_J9cpOJM0nikft0jAgjmsQ…}
rcode : NOERROR
```

#### Get PDNS Results (Related Domains)
```powershell
($TaskResults.results | Where-Object {$_.params.source -eq 'pdns'}).data.items

Hostname        IP                                                                 Last_Seen Record_Type
--------        --                                                                 --------- -----------
ns.google.com.  {216.239.32.11}                                                   1719615020 A
ns1.google.com. {216.239.32.10}                                                   1719615020 A
ns1.google.com. {2001:4860:4802:32::a}                                            1719615020 AAAA
ns2.google.com. {216.239.34.10}                                                   1719615020 A
ns2.google.com. {2001:4860:4802:34::a}                                            1719615020 AAAA
ns3.google.com. {216.239.36.10}                                                   1719615020 A
ns3.google.com. {2001:4860:4802:36::a}                                            1719615020 AAAA
ns4.google.com. {216.239.38.10}                                                   1719615020 A
ns4.google.com. {2001:4860:4802:38::a}                                            1719615020 AAAA
a.l.google.com. {74.125.53.9}                                                     1318263406 A
b.l.google.com. {74.125.45.9}                                                     1342196198 A
f.l.google.com. {72.14.203.9}                                                     1342196198 A
google.com.     {64.233.161.100, 64.233.161.101, 64.233.161.102, 64.233.161.113…} 1594197706 A
google.com.     {64.233.161.100, 64.233.161.101, 64.233.161.102, 64.233.161.113…} 1594957617 A
google.com.     {74.125.128.100, 74.125.128.101, 74.125.128.102, 74.125.128.113…} 1358896630 A
google.com.     {74.125.205.100, 74.125.205.101, 74.125.205.102, 74.125.205.113…} 1594192837 A
...
```