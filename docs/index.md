
<h1 align="center">
  <br>
  <!--<a href=""><img src="" alt="Markdownify" width="200"></a>-->
  <br>
  InfoBlox BloxOneDDI & BloxOne Threat Defense Powershell Module
  <br>
</h1>

<h4 align="center">A series of PowerShell Cmdlets used to interact with the InfoBlox BloxOne APIs.</h4>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#cmdlets">Cmdlets</a> •
  <a href="#resources">Resources</a> •
  <a href="#license">License</a> •
  <a href="https://www.powershellgallery.com/packages/ibPS/" target="_blank">Powershell Gallery</a>
</p>

## Key Features

* Automate end-to-end deployments of BloxOne
* Create, Edit & Remove objects from BloxOne Cloud (Records, Subnets, Ranges, Zones, HAGroups, etc.)
* Apply DNS/DHCP Configuration Policies to On-Prem hosts
* Deploy VMware & Hyper-V BloxOne Appliances
* Deploy / Configure / Manage Hosts & Services
* Query DNS/DHCP/Host/Audit/Security logs
* Interact with the TIDE API
* Build custom scripts/functions leveraging the [Generic Wrapper Cmdlets](https://github.com/TehMuffinMoo/ibPS?tab=readme-ov-file#custom-bloxone-functions-generic-wrapper).
* Automate the world!

## Limitations

* Cmdlets have not yet been created for all BloxOne API endpoints. This is still being actively developed with the aim to have most, if not all api endpoints integrated eventually.  
  * You can however also use this module as a generic wrapper by leveraging these [Wrapper Cmdlets](https://github.com/TehMuffinMoo/ibPS?tab=readme-ov-file#custom-bloxone-functions-generic-wrapper).
* A [PowerShell module already exists for InfoBlox NIOS](https://www.powershellgallery.com/packages/Posh-IBWAPI/3.2.2) and so limited Cmdlets will be built into this module. Any NIOS cmdlets built in are primarily for the purpose of migration to BloxOneDDI and may be deprecated.

## How To Use

To clone and run this PowerShell Module, you'll be best off with Git. This can be downloaded/extracted and run locally without an issue, but Git is preferred as updates to the Modules can be received with far less effort.

### Loading ibPS Module
You can either load the cmdlets directly, or Import/Install it as a PowerShell Module.

#### Installing from Powershell Gallery
```powershell
Install-Module -Name ibPS
```

#### Installing/Updating with Install.ps1
You can install with the Install.ps1 script, allowing you to install the latest 'bleeding edge' version.
```powershell
# Clone this repository on Windows
$ git clone https://github.com/TehMuffinMoo/ibPS/

# Go into the repository
$ cd ibPS/

# Install Module
. .\Install.ps1

# Non-Interactive Install Module
. .\Install.ps1 -Selection i
```

#### Updating ibPS automatically
```powershell
# You can upgrade ibPS directly from the module by using the following cmdlet
Get-ibPSVersion -Update
```

#### Explicitly Import Module
```powershell
# You can import the module directly by using;
Import-Module -Name ".\Modules\ibPS\BloxOne-Main.psm1" -DisableNameChecking
```

#### Explicitly Import Functions
```powershell
# You can load the functions directly by using;
. .\Modules\BloxOne-Main.ps1
```

### Authentication
#### BloxOne API Key
In order to authenticate against the BloxOne CSP (Cloud Services Portal), you must first set your API Key. You can do this for either your current powershell session or save the API Key as persistent for your current user.

##### Persistent
To store your API Key permenantly for your user, you can specify the <b>-Persist</b> option as shown below.
```powershell
Set-B1CSPAPIKey -ApiKey "<ApiKeyFromCSP>" -Persist
```

##### Single Session
Alternatively, you can simply store your API Key for the current powershell session only.
```powershell
Set-B1CSPAPIKey -ApiKey "<ApiKeyFromCSP>"
```

## BloxOne Cmdlets
All Cmdlets are listed in the left-hand menu. You can also use the `Get-Help` cmdlet to get detailed information on usage. Example;

```powershell
Get-Help New-B1AddressBlock -Detailed
```

Supported `Get-*` cmdlets have `-Strict`, `-tfilter`, `-Fields`, `-Limit` & `-Offset` parameters. Their use is described below.

<table>
  <tr>
    <th>
      Parameter
    </th>
    <th>
      Description
    </th>
  </tr>
  <tr>
    <td>
      -Strict
    </td>
    <td>
This is used to apply strict name checking when querying objects.  
The default is to perform wildcard/lazy matches based on submitted query parameters.
    </td>
  </tr>
  <tr>
    <td>
      -tfilter
    </td>
    <td>
This is used to filter results of your query by tags.
<pre>Get-B1Record -tfilter '("myTag"=="val1" or "myOtherTag"~"partvalue")'</pre>
    </td>
  </tr>
  <tr>
    <td>
      -Fields
    </td>
    <td>
This is used to filter the fields returned by the API
<pre>Get-B1Record -Fields name_in_zone,absolute_zone_name,rdata </pre>
    </td>
  </tr>
  <tr>
    <td>
      -Limit
    </td>
    <td>
This is used to specify the number of results to return from the API.
<pre>Get-B1ServiceLog -OnPremHost MyB1Host -Start (Get-Date).AddHours(-6) -Limit 1000</pre>
    </td>
  </tr>
  <tr>
    <td>
      -Offset
    </td>
    <td>
The -Offset parameter will offset the results returned by the amount specified. This is used in combination with -Limit to achieve pagination of API results.
<pre>Get-B1ServiceLog -OnPremHost MyB1Host -Start (Get-Date).AddHours(-6) -Limit 1000 -Offset 1000</pre>
    </td>
  </tr>
</table>

### Custom BloxOne Functions (Generic Wrapper)
You can also create custom functions by using the generic wrapper cmdlets.
```powershell
Get-B1Object -Product 'BloxOne DDI' -App DnsConfig -Endpoint /dns/record -Filters @('name_in_zone~"webserver" or absolute_zone_name=="mydomain.corp." and type=="caa"') -tfilter '("Site"=="New York")' -Limit 100
  # This is a generic wrapper function which allows you to create custom calls to retrieve objects from the BloxOne APIs.
  # It supports auto-complete of required fields based on the API Schema using double-tab

    # Here's an example getting a list of DNS A records from a particular domain, and using Splat for re-usable parameters

        $splat = @{                   
          "Product" = "BloxOne DDI"
          "App" = "DnsConfig"
          "Endpoint" = "/dns/record"
        }

        Get-B1Object @splat -filter @('absolute_zone_name=="mydomain.corp." and type=="a"') | ft absolute_name_spec,comment,rdata -AutoSize

        # Another example of getting a list of CNAMEs, with the same Splat parameters
        Get-B1Object @splat -filter @('absolute_zone_name=="mydomain.corp." and type=="cname"') | ft absolute_name_spec,comment,rdata -AutoSize



Set-B1Object -id {Object ID} -_ref {Object Ref} -Data {Data to Submit}
  # This is a generic wrapper function which allows you to create custom calls to update objects from the BloxOne APIs.
  # It supports pipeline input from Get-B1Object
  # Be mindful that read-only fields may be returned and will need removing prior to submitting the data. You can use the -Fields parameter on Get-B1Object to specify the fields to return to avoid having to strip them out.
  
  # See example below for adding a new tag to multiple DNS A records
        $Records = Get-B1Object -Product 'BloxOne DDI' -App DnsConfig -Endpoint /dns/record -Filters @('absolute_zone_name~"mydomain.corp." and type=="a"') -Fields tags
        foreach ($Record in $Records) {
            if (!($Record.tags)) {
                $Record.tags = @{}
            }
            $Record.tags.NewTag = "New Tag Value"
        }
        $Records | Set-B1Object

  # This example will update the multiple DHCP Options against multiple Subnets

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



New-B1Object -Product -Product {Product Name} -App {App} -Endpoint {API Endpoint} -Data {Data to Submit}
  # This is a generic wrapper function which allows you to create custom calls to add new objects via the BloxOne APIs.
  # It supports pipeline input for the -Data parameter
  
        # This example will create a new DNS Record

        $Splat = @{
	        "name_in_zone" = "MyNewRecord"
	        "zone" = "dns/auth_zone/12345678-8989-4833-abcd-12345678" ### The DNS Zone ID
	        "type" = "A"
	        "rdata" = @{
	     	    "address" = "10.10.10.10"
            }
		}
    New-B1Object -Product 'BloxOne DDI' -App DnsData -Endpoint /dns/record -Data $Splat



Remove-B1Object -id {Object ID} -_ref {Object Ref}
  # This is a generic wrapper function which allows you to create custom calls to delete objects from the BloxOne APIs.
  # It supports pipeline input from Get-B1Object
  
  # This example shows deleting multiple address blocks based on tag

        Get-B1Object -product 'BloxOne DDI' -App Ipamsvc -Endpoint /ipam/address_block -tfilter '("TagName"=="TagValue")' | Remove-B1Object -Force

  # Another example using Splat for parameter input
        Get-B1Object @splat -tfilter '("TagName"=="TagValue")' | Remove-B1Object -Force



Get-B1Schema -Product {Product Name} -App {App} -Endpoint {API Endpoint} -Method {Method Type} {Switch}-ListParameters

    ## An example of retrieving all available apps for BloxOne DDI
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

    ## An example of retrieving all available API endpoints for BloxOne DDI DnsConfig App
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

    ## An example of retrieving available methods for the CDC API endpoint
    Get-B1Schema -Product 'BloxOne Cloud' -App 'CDC' -Endpoint /v1/applications

      Name                           Value
      ----                           -----
      get                            Use this method to retrieve collection of applications.
      delete                         Use this method to delete a collection of application configurations in data connector.
      post                           Use this method to create application configurations in data connector.
```

### Custom NIOS Functions
You can also create custom functions by using the `Query-NIOS` cmdlet.
```bash
Query-NIOS -Method <String> -Server <String> -Uri <String> -ApiVersion <String> -Creds <PSCredential> -Data <String> -SkipCertificateCheck <Switch>
  # This is a core function used by all NIOS cmdlets when querying an Infoblox NIOS Grid Manager, required when interacting with the NIOS APIs.
  # This allows creating custom functions which are not yet built into native ibPS cmdlets
  # -Server, -ApiVersion & -Creds can all be ommitted if you have pre-configured them using Set-NIOSConfiguration & Store-NIOSCredentials cmdlets
```

## General Cmdlets
```powershell
Get-ibPSVersion -CheckForUpdates
  # Gets the ibPS Module Version.
  # Using -CheckForUpdates optionally checks if ibPS is up to date
  # Using -Update will optionally perform an in place upgrade of the ibPS module
  # Using -Force will force the update/replacement of ibPS, regardless of the current version
```

## To-Do

All work below will be committed to the [dev branch](https://github.com/TehMuffinMoo/ibPS/tree/dev) until updates are posted to main.

### Implement pipeline input for all Set- & Remove- cmdlets
Pipeline input for Set- & Remove- cmdlets is being developed, to allow more flexible usage of ibPS. The table below shows the current support for this feature.

Cmdlet                           | Pipeline Input Supported                                           | Supported Input Cmdlets
-------------------------------- | ------------------------------------------------------------------ | ----------------------------
Reboot-B1Host                    | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Host
Remove-B1DNSView                 | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1DNSView
Remove-B1Space                   | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Space
Remove-B1AddressBlock            | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1AddressBlock
Remove-B1AddressReservation      | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Address
Remove-B1AuthoritativeZone       | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1AuthoritativeZone
Remove-B1ForwardZone             | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1ForwardZone
Remove-B1FixedAddress            | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1FixedAddress
Remove-B1Host                    | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Host
Remove-B1Range                   | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Range
Remove-B1Record                  | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Record
Remove-B1Service                 | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Service
Remove-B1Subnet                  | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Subnet
Remove-B1APIKey                  | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1APIKey
Remove-B1HAGroup                 | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1HAGroup
Remove-B1DHCPConfigProfile       | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1DHCPConfigProfile
Remove-B1DNSConfigProfile        | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1DNSConfigProfile
Set-B1AddressBlock               | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1AddressBlock
Set-B1AuthoritativeZone          | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1AuthoritativeZone
Set-B1DHCPConfigProfile          | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1DHCPConfigProfile
Set-B1FixedAddress               | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1FixedAddress
Set-B1ForwardNSG                 | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1ForwardNSG
Set-B1ForwardZone                | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1ForwardZone
Set-B1Host                       | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Host
Set-B1Range                      | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Range
Set-B1Record                     | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Record
Set-B1Subnet                     | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Subnet
Set-B1APIKey                     | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1APIKey
Set-B1HAGroup                    | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1HAGroup
Start-B1DiagnosticTask           | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Host
Start-B1Service                  | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Service
Stop-B1Service                   | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Service
Set-B1TDTideDataProfile          | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1TDTideDataProfile
Remove-B1TDSecurityPolicy        | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1TDSecurityPolicy
Remove-B1TDNetworkList           | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1TDNetworkList
Get-B1TDDossierLookup            | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Start-B1TTDDossierLookup
Set-B1Object                     | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Object



### Replace old for new APIs
This is a work in progress.

Old Cmdlet           | New Cmdlet        | Old API Endpoint     | New API Endpoint    | Status
---------------------|------------------ | -------------------- | ------------------- | --------
Get-B1DNSHost        | Get-B1DNSService  | /dns/host            | /dns/service        | ![Not Implemented](https://badgen.net/badge/Status/Not%20Implemented/orange)
Set-B1DNSHost        | Set-B1DNSService  | /dns/host            | /dns/service        | ![Not Implemented](https://badgen.net/badge/Status/Not%20Implemented/orange)
Get-B1DHCPHost       | Get-B1DHCPService | /dhcp/host           | /dhcp/service       | ![Not Implemented](https://badgen.net/badge/Status/Not%20Implemented/orange)
Get-B1DHCPHost       | Set-B1DHCPService | /dhcp/host           | /dhcp/service       | ![Not Implemented](https://badgen.net/badge/Status/Not%20Implemented/orange)


## Resources
This PowerShell Module makes use of the following InfoBlox APIs;

- [CSP Cloud](https://csp.infoblox.com/apidoc)
- [NIOS](https://www.infoblox.com/wp-content/uploads/infoblox-deployment-infoblox-rest-api.pdf)

## License

MIT

---

> [Mat Cox]()
