## Automate GSLB Creation
This example will show how you can automate the creation of GSLB objects using Universal DDI Dynamic Traffic Control (DTC)

```powershell
## Create DTC Servers
New-B1DTCServer -Name 'Exchange Server A' -Description 'Exchange Server - Active Node' -FQDN 'exchange-1.company.corp' -AutoCreateResponses Enabled
New-B1DTCServer -Name 'Exchange Server B' -Description 'Exchange Server - Passive Node' -FQDN 'exchange-2.company.corp' -AutoCreateResponses Enabled

## Create DTC Health Check
New-B1DTCHealthCheck -Name 'Exchange HTTPS Check' -Type HTTP -UseHTTPS -Port 443 -HTTPRequest "GET /owa/auth/logon.aspx HTTP/1.1`nHost: webmail.company.corp"

## Create DTC Pool
New-B1DTCPool -Name 'Exchange Pool' -Description 'Pool of Exchange Servers' -LoadBalancingType GlobalAvailability -Servers 'Exchange Server A','Exchange Server B' -HealthChecks 'ICMP health check','Exchange HTTPS Check' -TTL 10

## Create DTC Policy
New-B1DTCPolicy -Name 'Exchange-Policy' -Description 'Exchange Policy' -LoadBalancingType GlobalAvailability -Pools 'Exchange Pool' -TTL 10

## Create DTC LBDN
New-B1DTCLBDN -Name 'exchange.company.corp' -Description 'Exchange Servers LBDN' -DNSView 'Corporate' -Policy 'Exchange-Policy' -Precedence 10 -TTL 10
```