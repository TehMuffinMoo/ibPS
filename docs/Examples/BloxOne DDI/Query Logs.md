Here are some examples of retrieving various logs from the BloxOne CSP

### Service Log
This example showcases retrieving the last 10,000 events for the `DNS` container located on a specific BloxOne Host.

It shows how you can use the -Start & -End parameters to limit the search window to specific dates/times.

It also shows how you can post-filter the `msg` response to find specific messages, such as those related to DNS Zone Transfer.

```powershell
PS> Get-B1ServiceLog -B1Host "my-host.corp.local" -Container DNS -Start (Get-Date).AddHours(-12) -Limit 10000 | where {$_.msg -like "*xfer*"} | ft -AutoSize

timestamp                      onpremhost         container_name msg
---------                      ----------         -------------- ---
2024-03-07T10:56:57.006946304Z my-host.corp.local ns:dns          07-Mar-2024 10:56:57.035 xfer-in: info: transfer of '1.168.192.in-addr.arpa/IN/dsfwef4344-0e02-1532-b33a-fwefkndsfg4u' from 127.0.0.1#1853: Transfer completed: 1 messages, 6 records, 681 bytes, 0.111 secs…
2024-03-07T10:56:57.006946303Z my-host.corp.local ns:dns          07-Mar-2024 10:56:57.035 xfer-in: info: transfer of '1.168.192.in-addr.arpa/IN/dsfwef4344-0e02-1532-b33a-fwefkndsfg4u' from 127.0.0.1#1853: Transfer status: success
2024-03-07T10:56:57.006946302Z my-host.corp.local ns:dns          07-Mar-2024 10:56:57.035 xfer-in: info: zone 1.168.192.in-addr.arpa/IN/dsfwef4344-0e02-1532-b33a-fwefkndsfg4u: transferred serial 393944
2024-03-07T10:56:56.006946301Z my-host.corp.local ns:dns          07-Mar-2024 10:56:56.923 xfer-in: info: transfer of '1.168.192.in-addr.arpa/IN/dsfwef4344-0e02-1532-b33a-fwefkndsfg4u' from 127.0.0.1#1853: connected using 127.0.0.1#1853
2024-03-07T10:56:56.006946300Z my-host.corp.local ns:dns          07-Mar-2024 10:56:56.923 xfer-in: info: zone 1.168.192.in-addr.arpa/IN/dsfwef4344-0e02-1532-b33a-fwefkndsfg4u: Transfer started.
2024-03-07T10:56:49.006946286Z my-host.corp.local ns:dns          07-Mar-2024 10:56:49.975 xfer-in: info: transfer of 'corp.local/IN/dsfwef4344-0e02-1532-b33a-fwefkndsfg4u' from 127.0.0.1#1853: Transfer completed: 1 messages, 12 records, 1019 bytes, 0.135 secs (7548 bytes…
2024-03-07T10:56:49.006946285Z my-host.corp.local ns:dns          07-Mar-2024 10:56:49.975 xfer-in: info: transfer of 'corp.local/IN/dsfwef4344-0e02-1532-b33a-fwefkndsfg4u' from 127.0.0.1#1853: Transfer status: success
2024-03-07T10:56:49.006946284Z my-host.corp.local ns:dns          07-Mar-2024 10:56:49.975 xfer-in: info: zone corp.local/IN/dsfwef4344-0e02-1532-b33a-fwefkndsfg4u: transferred serial 618609
2024-03-07T10:56:49.006946283Z my-host.corp.local ns:dns          07-Mar-2024 10:56:49.839 xfer-in: info: transfer of 'corp.local/IN/dsfwef4344-0e02-1532-b33a-fwefkndsfg4u' from 127.0.0.1#1853: connected using 127.0.0.1#1853
2024-03-07T10:56:49.006946282Z my-host.corp.local ns:dns          07-Mar-2024 10:56:49.839 xfer-in: info: zone corp.local/IN/dsfwef4344-0e02-1532-b33a-fwefkndsfg4u: Transfer started.
```


### DNS Log
This example shows querying the DNS Log to identify requests from two specific source IPs for the last 30minutes

```powershell
PS> Get-B1DNSLog -IP 10.172.19.1,10.172.19.5 -Start (Get-Date).AddMinutes(-30) | ft timestamp,query_type,ip,query,response,mac_address,dns_server,query_nanosec -AutoSize

timestamp           query_type ip          query                  response          mac_address       dns_server      query_nanosec
---------           ---------- --          -----                  --------          -----------       ----------      -------------
3/7/2024 11:24:31AM A          10.172.19.5 ucsd.edu.              99.83.137.54      dc:a6:32:b6:31:3a host-b1-02      2.08250944e+08
3/7/2024 11:24:31AM A          10.172.19.5 cam.ac.uk.             128.232.132.8     dc:a6:32:b6:31:3a host-b1-01      5.76233227e+08
3/7/2024 11:24:31AM A          10.172.19.5 google.com.            172.217.16.238    dc:a6:32:b6:31:3a host-b1-02      7.32225717e+08
3/7/2024 11:24:31AM A          10.172.19.5 www.github.com.        140.82.121.4      dc:a6:32:b6:31:3a host-b1-01      2.04251136e+08
3/7/2024 11:24:31AM A          10.172.19.5 www.indiana.edu.       129.79.123.142    dc:a6:32:b6:31:3a host-b1-02      5.76233227e+08
3/7/2024 11:24:31AM A          10.172.19.5 www.berkeley.edu.      141.193.213.20    dc:a6:32:b6:31:3a host-b1-01      5.72233419e+08
3/7/2024 11:24:31AM A          10.172.19.5 osuosl.org.            140.211.9.53      dc:a6:32:b6:31:3a host-b1-01      7.28225909e+08
...
```


### DNS Forwarding Proxy (DFP) Log
The DFP log shows all DNS queries which have been resolved via a BloxOne or NIOS DFP, or via the Secure Infoblox Portal Resolver.

```powershell
PS> Get-B1DFPLog -Start (Get-Date).AddMinutes(-30) -Limit 5

timestamp                     query_type device_ip      device_name   user      network            query                                                               response       mac_address       device_region
---------                     ---------- ---------      -----------   ----      -------            -----                                                               --------       -----------       -------------
2024-03-07 11:29:44 +0000 UTC A          10.120.170.10  Laptop-12345  bbloggs   BloxOne Endpoint   outlook.office365.com.                                              52.97.211.242  58:ce:2a:7e:b9:09 England       
2024-03-07 11:29:42 +0000 UTC A          10.11.34.53    10.11.34.53   unknown   Corporate          ooc-g2.tm-4.office.com.                                             52.98.152.178  00:0c:29:0e:a9:df Île-de-France 
2024-03-07 11:29:41 +0000 UTC HTTPS      10.47.9.102    Laptop-54321  mcox      BloxOne Endpoint   waa-pa.clients6.google.com.                                         NOERROR        c8:89:f3:bc:a1:4e England       
2024-03-07 11:29:41 +0000 UTC A          10.172.19.12   10.172.19.12  unknown   Corporate          fls-eu.amazon.es.                                                   54.154.77.19   00:0c:29:0e:a9:df Île-de-France 
2024-03-07 11:29:40 +0000 UTC A          10.23.11.11    Laptop-98765  jbloggs   BloxOne Endpoint   gem-pa.googleapis.com.                                              142.250.180.10 c8:89:f3:bd:11:e8 England
```


### DNS Security Log
The DNS Security Log shows all DNS queries which have triggered a defined security policy rule.

The example below shows querying the events for those triggering a specific Feed, within the last 7 days and returning only desired fields.

```powershell
PS> Get-B1DNSEvent -FeedName Suspicious_Domains -Start (Get-Date).AddDays(-7) -Fields device,dhcp_fingerprint,dns_view,qname,tclass,tfamily,threat_indicator,feed_name,confidence,country,policy_action,network | ft -AutoSize

device                      dhcp_fingerprint                dns_view                             qname                   tclass     tfamily    threat_indicator       feed_name          confidence country       policy_action network
------                      ----------------                --------                             -----                   ------     -------    ----------------       ---------          ---------- -------       ------------- -------
nb-heraplast-26.hera.local. Fujitsu:LIFEBOOK E5512A:Windows Default                              ossis.industrystock.cn. Suspicious Generic    industrystock.cn       Suspicious_Domains HIGH       United States Block         Corporate Network (DFP)
10.172.19.5                                                 fdfr44t4-f34r-ftgd-g4tg-sfsewfg43rdv natsuyaoi.com.          Suspicious Nameserver natsuyaoi.com          Suspicious_Domains HIGH       United States Log           Guest Network (DFP)
10.172.19.5                                                 fdfr44t4-f34r-ftgd-g4tg-sfsewfg43rdv whatihaveit.com.        Suspicious Nameserver whatihaveit.com        Suspicious_Domains HIGH       United States Redirect      Guest Network (DFP)
10.172.19.5                                                 fdfr44t4-f34r-ftgd-g4tg-sfsewfg43rdv vedazone.com.           Suspicious Nameserver vedazone.com           Suspicious_Domains HIGH       United States Redirect      Guest Network (DFP)
...
```


### DHCP Log
The DHCP Log details all lease issuance, expirations, etc.

The example below shows querying the DHCP Log for those which have been assigned/issued by a pair of DHCP Servers in the last 6 hours.

```powershell
PS> Get-B1DHCPLog -State Assignments -Start (Get-Date).AddHours(-6) | ft -AutoSize

timestamp           dhcp_server              protocol     state       lease_ip        mac_address       client_hostname                     lease_start         lease_end            dhcp_fingerprint
---------           -----------              --------     -----       --------        -----------       ---------------                     -----------         ---------            ----------------
3/7/2024 11:51:01AM dc-b101                  IPv4 Address Assignments 192.168.1.110   BE:03:71:B6:07:7A                                     3/7/2024 11:51:01AM 3/14/2024 11:51:01AM Apple OS
3/7/2024 11:49:41AM dc-b102                  IPv4 Address Assignments 192.168.1.132   00:68:EB:D3:02:EB hpd302eb                            3/7/2024 11:49:41AM 3/7/2024 1:49:41PM   HP Printer
3/7/2024 11:49:11AM dc-b101                  IPv4 Address Assignments 192.168.1.42    F0:70:4F:6D:85:50 samsung                             3/7/2024 11:49:11AM 3/7/2024 1:49:11PM   Samsung
3/7/2024 11:46:57AM dc-b102                  IPv4 Address Assignments 192.168.1.74    04:5D:4B:33:FC:C3 myhost-192-168-0-200                3/7/2024 11:46:57AM 3/7/2024 1:46:57PM   Android OS
...
```


### Audit Log
This example showcases retrieving the last 100 events from the Audit Log, where the action was `DELETE` and was performed within the last 36 Hours.

```powershell
PS> Get-B1AuditLog -Method DELETE -Start (Get-Date).AddHours(-36) -End (Get-Date) | ft created_at,user_name,message

created_at          user_name              message
----------          ---------              -------
3/7/2024 11:02:13AM jbloggs@my.company     Infra-service is deleted
3/7/2024 9:56:05AM  pbloggs@my.company     Service API Key deleted
3/4/2024 11:59:22PM sbloggs@my.company     {"request":{"id":"ipam/ip_space/ferg54ty-da82-11ee-833c-f44v5e4gsr4"}}
3/4/2024 11:54:47PM bbloggs@my.company     {"request":{"id":"ipam/subnet/f54tg45g6-da82-11ee-9983-i7768ikyfd4"}}
```


### Security (Web Server) Log
The Security Log is the CSP Web Server log, allowing you to view all requests for the associated CSP Account.

```powershell
PS> Get-B1SecurityLog | ft remote_addr,user_email,app,request

remote_addr  user_email                        app      request
-----------  ----------                        ---      -------
1.2.3.4      userA@domain.corp                 nginx    GET /licensing/v1/entitlements?services=tide HTTP/2.0
1.2.3.4      userA@domain.corp                 nginx    GET /licensing/v1/entitlements?services=tide HTTP/2.0
88.88.88.88  userB@domain.corp                 nginx    GET /atlas-jobs-tasks/v1/jobs?_filter=origin%3D%3D%270%27&_order_by=created_at%20desc&_limit=1000 HTTP/2.0
88.88.88.88  userB@domain.corp                 nginx    GET /atlas-jobs-tasks/v1/jobs?_filter=origin%3D%3D%270%27&_order_by=created_at%20desc&_limit=1000 HTTP/2.0
88.88.88.88  userB@domain.corp                 nginx    GET /atlas-notifications-mailbox/v1/user_alerts?_order_by=created_at%20desc&_filter=state%3D%3D%27posted%27%20or%20state%3D%3D%27shown%27 HTTP/2.0
88.88.88.88  userB@domain.corp                 nginx    GET /api/atlas-tagging/v2/tags?_limit=4000&_offset=0&_fields=key%2Ctype%2Cregexp%2Cstatus%2Cnamespace.name%2Cnamespace.type%2Cvalues.value HTTP/2.0
...
```