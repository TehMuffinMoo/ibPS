## Get Dossier Results

This is a example of how to return related information from a Dossier Search. This example shows retrieiving data related to tasks for PDNS (Related Domains) and DNS (Current DNS)

```powershell
## Initiate New Search & Wait for completion
$Search = Start-B1DossierLookup -Type host -Value 'ibps.app' -Wait
## Get Results for each associated task
$TaskResults = $Search | Get-B1DossierLookup -TaskResults
```

### Get DNS Results (Current DNS)
```powershell
($TaskResults.results | Where-Object {$_.params.source -eq 'dns'}).data

A     : {@{ip=104.16.253.120; reverse=Failed; ttl=300}, @{ip=104.16.254.120; reverse=Failed; ttl=300}}
AAAA  : {2606:4700::6810:fd78, 2606:4700::6810:fe78}
CERT  : {}
CNAME : {}
HTTPS : {1 . alpn=h3,h2 ipv4hint=104.16.253.120,104.16.254.120 ipv6hint=2606:4700::6810:fd78,2606:4700::6810:fe78}
MX    : {}
NS    : {bayan.ns.cloudflare.com., amber.ns.cloudflare.com.}
SOA   : {amber.ns.cloudflare.com. dns.cloudflare.com. 2342420385 10000 2400 604800 1800}
SVCB  : {}
TSIG  : {}
TXT   : {}
rcode : NOERROR
```

### Get PDNS Results (Related Domains)
```powershell
($TaskResults.results | Where-Object {$_.params.source -eq 'pdns'}).data.items

Hostname       IP                                            Last_Seen Record_Type
--------       --                                            --------- -----------
ibps.app.      {50.63.202.32}                               1534748994 A
ibps.app.      {50.63.202.33}                               1554394447 A
ibps.app.      {50.63.202.35}                               1556240228 A
ibps.app.      {50.63.202.36}                               1555595101 A
ibps.app.      {50.63.202.37}                               1528676776 A
ibps.app.      {50.63.202.38}                               1533236310 A
ibps.app.      {50.63.202.39}                               1545650539 A
ibps.app.      {50.63.202.40}                               1539612040 A
...
```