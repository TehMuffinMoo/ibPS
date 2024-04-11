# Custom Functions

You can create custom functions by using the generic wrapper cmdlets.

## GET

This is a generic wrapper function which allows you to create custom calls to retrieve objects from the BloxOne APIs.  
It supports auto-complete of required fields based on the API Schema using double-tab  

```powershell
Get-B1Object -Product 'BloxOne DDI' -App DnsConfig -Endpoint /dns/record -Filters @('name_in_zone~"webserver" or absolute_zone_name=="mydomain.corp." and type=="caa"') -tfilter '("Site"=="New York")' -Limit 100
```

List DNS A Records for Domain
Example getting a list of DNS A records from a particular domain, and using Splat for re-usable parameters

```powershell
$splat = @{                   
  "Product" = "BloxOne DDI"
  "App" = "DnsConfig"
  "Endpoint" = "/dns/record"
}

Get-B1Object @splat -filter @('absolute_zone_name=="mydomain.corp." and type=="a"') | ft absolute_name_spec,comment,rdata -AutoSize
```

Another example of getting a list of CNAMEs, with the same Splat parameters
```powershell
Get-B1Object @splat -filter @('absolute_zone_name=="mydomain.corp." and type=="cname"') | ft absolute_name_spec,comment,rdata -AutoSize
```

## SET
This is a generic wrapper function which allows you to create custom calls to update objects from the BloxOne APIs.  
It supports pipeline input from Get-B1Object  
Be mindful that read-only fields may be returned and will need removing prior to submitting the data. You can use the -Fields parameter on Get-B1Object to specify the fields to return to avoid having to strip them out.  

```powershell
Set-B1Object -id {Object ID} -_ref {Object Ref} -Data {Data to Submit}
```

Example for adding a new tag to multiple DNS A records
```powershell
$Records = Get-B1Object -Product 'BloxOne DDI' -App DnsConfig -Endpoint /dns/record -Filters @('absolute_zone_name~"mydomain.corp." and type=="a"') -Fields tags
foreach ($Record in $Records) {
    if (!($Record.tags)) {
        $Record.tags = @{}
    }
    $Record.tags.NewTag = "New Tag Value"
}
$Records | Set-B1Object
```

This example will update the multiple DHCP Options against multiple Subnets

```powershell
$Subnets = Get-B1Object -product 'BloxOne DDI' -App Ipamsvc -Endpoint /ipam/subnet -tfilter '("BuiltWith"=="ibPS")' -Fields name,dhcp_options,tags
foreach ($Subnet in $Subnets) {
    $Subnet.dhcp_options = @(
        @{
            "type"="option"
            "option_code"=(Get-B1DHCPOptionCode -Name "routers").id
            "option_value"="10.10.100.254"
        }
        @{
            "type"="option"
            "option_code"=(Get-B1DHCPOptionCode -Name "domain-name-servers").id
            "option_value"="10.1.1.100,10.3.1.100"
        }
    )
}
$Subnets | Set-B1Object
```

## NEW
This is a generic wrapper function which allows you to create custom calls to add new objects via the BloxOne APIs.  
It supports pipeline input for the -Data parameter  

```powershell
New-B1Object -Product -Product {Product Name} -App {App} -Endpoint {API Endpoint} -Data {Data to Submit}
```
  
This example will create a new DNS Record
```powershell
$Splat = @{
  "name_in_zone" = "MyNewRecord"
  "zone" = "dns/auth_zone/12345678-8989-4833-abcd-12345678" ### The DNS Zone ID
  "type" = "A"
  "rdata" = @{
    "address" = "10.10.10.10"
    }
}
New-B1Object -Product 'BloxOne DDI' -App DnsData -Endpoint /dns/record -Data $Splat
```

## REMOVE
This is a generic wrapper function which allows you to create custom calls to delete objects from the BloxOne APIs.  
It supports pipeline input from Get-B1Object  

```powershell
Remove-B1Object -id {Object ID} -_ref {Object Ref}
```

This example shows deleting multiple address blocks based on tag
```powershell
Get-B1Object -product 'BloxOne DDI' -App Ipamsvc -Endpoint /ipam/address_block -tfilter '("TagName"=="TagValue")' | Remove-B1Object -Force
```

Another example using Splat for parameter input
```powershell
Get-B1Object @splat -tfilter '("TagName"=="TagValue")' | Remove-B1Object -Force
```

## SCHEMA
Used for obtaining API Schema information for use with generic wrapper cmdlets

```powershell
Get-B1Schema -Product {Product Name} -App {App} -Endpoint {API Endpoint} -Method {Method Type} {Switch}-ListParameters
```

An example of retrieving all available apps for BloxOne DDI    
```powershell
Get-B1Schema -Product 'BloxOne DDI'

  Available Apps: 

  app                 label
  ---                 -----
  Ipamsvc             IP Address Management
  DnsConfig           DNS Configuration
  DnsData             DNS Data
  DhcpLeases          DHCP Leases
  DDIKeys             DDI Keys
  ThirdPartyProviders Third Party Providers
```

An example of retrieving all available API endpoints for BloxOne DDI DnsConfig App
```powershell
Get-B1Schema -Product 'BloxOne DDI' -App 'DnsConfig'

  Endpoint                               Description
  --------                               -----------
  /dns/global                            Use this method to read the Global configuration object.…
  /dns/forward_zone/{id}                 Use this method to read a Forward Zone object.…
  /dns/auth_zone/copy                    Use this method to copy an __AuthZone__ object to a different __View__.…
  /dns/forward_nsg/{id}                  Use this method to read a ForwardNSG object.…
  /dns/convert_domain_name/{domain_name} Use this method to convert between Internationalized Domain Name (IDN) and ASCII domain name (Punycode).
  /dns/cache_flush                       Use this method to create a Cache Flush object.…
  /dns/delegation/{id}                   Use this method to read a Delegation object.…
  /dns/acl                               Use this method to list ACL objects.…
  /dns/view/bulk_copy                    Use this method to bulk copy __AuthZone__ and __ForwardZone__ objects from one __View__ object to another __View__ object.…
  /dns/forward_nsg                       Use this method to list ForwardNSG objects.…
  ...
```

An example of retrieving available methods for the CDC API endpoint
```powershell
Get-B1Schema -Product 'BloxOne Cloud' -App 'CDC' -Endpoint /v1/applications

  Name                           Value
  ----                           -----
  get                            Use this method to retrieve collection of applications.
  delete                         Use this method to delete a collection of application configurations in data connector.
  post                           Use this method to create application configurations in data connector.
```

## INVOKE
The `Invoke-CSP` cmdlet can be used as a barebones wrapper for the Cloud Services Portal. This is a core function and is used by every other cmdlet within the ibPS Module.

```powershell
Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/record?_limit=10"
```