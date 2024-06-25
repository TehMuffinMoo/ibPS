# Custom Functions

You can create custom functions by using the generic wrapper cmdlets.

## GET

This is a generic wrapper function which allows you to calls to retrieve objects from the NIOS APIs.
It supports auto-complete of required fields based on the API Schema using double-tab

```powershell
Get-NIOSObject -ObjectType record:a -Filters 'ipv4addr=172.25.22.12'
```

List DNS A Records for Domain
Example getting a list of DNS A records from a particular domain, and using Splat for re-usable parameters

```powershell
Get-NIOSObject -ObjectType record:a -Filters 'zone=mydomain.corp' -BaseFields -Fields dns_name,zone,ttl,ipv4addr
```

## SET
This is a generic wrapper function which allows you to create custom calls to update objects using the NIOS APIs.
It supports pipeline input from Get-NIOSObject

```powershell
$NIOSObject = Get-NIOSObject -ObjectType record:a -Filters 'name=my.example.com'
$NIOSObject.comment = 'My Example'
$NIOSObject | Set-NIOSObject -ReturnAllFields                                   

_ref               : record:a/ZG5zLmJpbmRfYSQuX2RlZmF1bHQuY29tLmV4YW1wbGUsbXksMTcyLjI1LjIyLjEy:my.example.com/default
cloud_info         : @{authority_type=GM; delegated_scope=NONE; mgmt_platform=; owned_by_adaptor=False}
comment            : My Example
creation_time      : 1719305331
creator            : STATIC
ddns_protected     : False
disable            : False
dns_name           : my.example.com
extattrs           : 
forbid_reclamation : False
ipv4addr           : 172.25.22.12
ms_ad_user_data    : @{active_users_count=0}
name               : my.example.com
reclaimable        : False
use_ttl            : False
view               : default
zone               : example.com
```

## NEW
This is a generic wrapper function which allows you to create custom calls to add new objects using the NIOS APIs. 
It supports pipeline input for the -Object parameter
  
This example will create a new DNS Record
```powershell
@{                                                                                   
    name = 'my.example.com'
    ipv4addr = '172.25.22.12'
    comment = 'My A Record'
} | New-NIOSObject -ObjectType 'record:a'

record:a/ZG5zLmJpbmRfYSQuX2RlZmF1bHQuY29tLmV4YW1wbGUsbXksMTcyLjI1LjIyLjEy:my.example.com/default
```

## REMOVE
This is a generic wrapper function which allows you to create custom calls to delete objects using the NIOS APIs. 
It supports pipeline input from Get-NIOSObject

This example shows deleting all A records from a zone
```powershell
Get-NIOSObject -ObjectType record:a -Filters 'name=my.example.com' | Remove-NIOSObject

record:a/ZG5zLmJpbmRfYSQuX2RlZmF1bHQuY29tLmV4YW1wbGUsbXksMTcyLjI1LjIyLjEy:my.example.com/default
record:a/ZG5zLmJpbmRfYSQuX2RlZmF1bHQuY29tLmV4YW1wbGUsbXksMTcyLjI1LjIyLjEz:my.example.com/default
```

## SCHEMA
Used for obtaining API Schema information from the NIOS APIs

```powershell
Get-NIOSSchema                                                          

requested_version supported_objects                                    supported_versions
----------------- -----------------                                    ------------------
2.12              {ad_auth_service, admingroup, adminrole, adminuser…} {1.0, 1.1, 1.2, 1.2.1…}
```

An example of retrieving all available fields for `dtc:lbdn` objects
```powershell
Get-NIOSSchema -ObjectType dtc:lbdn -Fields | ft -AutoSize

is_array name                       standard_field supports type
-------- ----                       -------------- -------- ----
    True auth_zones                          False rwu      {zone_auth}
   False auto_consolidated_monitors          False rwu      {bool}
   False comment                              True rwus     {string}
   False disable                             False rwu      {bool}
   False extattrs                            False rwu      {extattr}
   False health                              False r        {dtc:health}
   False lb_method                           False rwu      {enum}
   False name                                 True rwus     {string}
    True patterns                            False rwu      {string}
   False persistence                         False rwu      {uint}
    True pools                               False rwu      {dtc:pool:link}
   False priority                            False rwu      {uint}
   False topology                            False rwu      {string}
   False ttl                                 False rwu      {uint}
    True types                               False rwu      {enum}
   False use_ttl                             False rwu      {bool}
```

## INVOKE
The `Invoke-NIOS` cmdlet can be used as a barebones wrapper for the interfacing with NIOS either directly or via BloxOne Federation. This is a core function and is used by every other NIOS cmdlet within the ibPS Module.

```powershell
Invoke-NIOS -Method GET -Uri 'network' -GridName Infoblox_infoblox.localdomain_A438RFFD -ApiVersion 2.12
```