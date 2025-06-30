## Top Metrics
A handy cmdlet was built for the purpose of retrieving top metrics, including DNS/DHCP clients, DNS Servers & Top Queries.

### Get Top DNS Clients
This example will retrieve 10 DNS clients with the highest query count

```powershell
PS> Get-B1TopMetrics -TopClients -TopClientLogType DNS -TopCount 10 | ft device_ip,queryCount -AutoSize

device_ip         queryCount
---------         ----------
192.168.122.14    5357      
10.127.43.142     5788      
192.168.1.12      9213      
192.168.1.43      9429      
192.168.0.79      9940      
192.168.1.24      10128     
172.16.43.14      10396     
192.168.1.100     11453     
172.12.35.68      29947     
172.16.35.32      214013    
```


### Get Top DFP Clients
This example will retrieve 10 DNS Forwarding Proxy (DFP) clients with the highest query count

```powershell
PS> Get-B1TopMetrics -TopClients -TopClientLogType DFP -TopCount 10 | ft -AutoSize                     

device_name                count
-----------                -----
192.168.1.12                5716
10.127.43.147               8890
172.16.35.32               13174
mac-dfnbrb.corp.domain     16453
10.10.100.12               16869
mac-ferdge.corp.domain     20618
mac-khjkgh.corp.domain     24877
mac-cvxhyt.corp.domain     29147
mat-iphone.corp.domain     31122
10.12.46.63                73128
```


### Get Top DNS Queries
This example returns a list of the top 10 queried domains in the last 24 hours

```powershell
PS> Get-B1TopMetrics -TopQueries -QueryType DNS -TopCount 10 -Start (Get-Date).AddDays(-24)    

query                            queryCount
-----                            ----------
clients3.google.com.               38847
www.gstatic.com.                   45985
captive.apple.com.                 46426
www.google.com.                    48280
csp.infoblox.com.                  53424
www.msftncsi.com.                  67467
portal.azure.com.                  95782
www.github.com.                    95892
lh3.googleusercontent.com.        198020
cdn.samsungcloudsolution.com.     209268
```


### Get Top NXDOMAINs
This example will return a list of the top 10 most queried domains which have returned NXDOMAIN in the last 12 hours

This is a really useful option when troubleshooting or performing proactive checks, as it can highlight resolution issues to key services.

```powershell
PS> Get-B1TopMetrics -TopQueries -QueryType NXDOMAIN -TopCount 10 -Start (Get-Date).AddDays(-12)

query                                   queryCount
-----                                   ----------
cm.g.doubleclick.net.                         4314
h30494.www3.hp.com.                           4838
rtb.openx.net.                                5256
pubads.g.doubleclick.net.                     5480
htlb.casalemedia.com.                         5976
prg.smartadserver.com.                        6473
securepubads.g.doubleclick.net.               6582
stats.g.doubleclick.net.                      7968
_grpc_config.uswest-comms.dgsecure.com.      12765
googleads.g.doubleclick.net.                 15462
```


### Get Top DFP Queries
This example will retrieve the top 10 most queried domains via the DNS Forwarding Proxies (DFPs) for the last 12 hours

```powershell
PS> Get-B1TopMetrics -TopQueries -QueryType DFP -TopCount 10 -Start (Get-Date).AddDays(-12)

query                                                               queryCount
-----                                                               ----------
outlook.office365.com.                                                   40173
ssl.gstatic.com.                                                         37151
spclient.wg.spotify.com.                                                 30361
ooc-g2.tm-4.office.com.                                                  29721
play.google.com.                                                         28058
noam.presence.teams.microsoft.com.                                       25028
teams.events.data.microsoft.com.                                         24463
slack.com.                                                               23185
sinkhole.paloaltonetworks.com.                                           21275
googleads.g.doubleclick.net.                                             20626
```


### Get Top DNS Servers
This example will retrieve the top 10 most queried DNS Servers

```powershell
PS> Get-B1TopMetrics -TopDNSServers -TopCount 10 | ft Count,DNS-Server 

 Count DNS-Server
------ ----------
262586 site-a-b101
 40569 site-b-b101
 24167 site-a-b102
 16566 site-b-b102
 10676 site-c-b101
  6711 site-c-b102
  4704 site-d-b101
  1842 site-d-b102
```


### Get Top DNS Server by Day
This example will retrieve the top DNS Server by query count by day.

The `-Granularity` parameter can be used to modify the aggregation of the counts.

```powershell
PS> Get-B1TopMetrics -TopDNSServers -Start (Get-Date).AddDays(-7) -Granularity day -TopCount 1

Timestamp             Count DNS-Server      SiteID
---------             ----- ----------      ------
2/29/2024 12:00:00AM  22273 corp-a-b101     fsjnf398fs9wefnjh984w3fvnd8hvfvd
3/1/2024 12:00:00AM   47211 corp-b-b102     fsjnf398fs9wefnjh984w3fvnd8hvfvd
3/2/2024 12:00:00AM   41539 site-a-b101     cfsdhf9832wrferg998durgt43ge8m8f
3/3/2024 12:00:00AM   74070 site-a-b101     cfsdhf9832wrferg998durgt43ge8m8f
3/4/2024 12:00:00AM  149620 site-a-b101     cfsdhf9832wrferg998durgt43ge8m8f
3/5/2024 12:00:00AM  402430 site-a-b101     cfsdhf9832wrferg998durgt43ge8m8f
3/6/2024 12:00:00AM  280958 site-a-b101     cfsdhf9832wrferg998durgt43ge8m8f
3/7/2024 12:00:00AM  144899 site-a-b101     cfsdhf9832wrferg998durgt43ge8m8f
```