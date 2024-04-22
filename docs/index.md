
<style>
  .paramName {
    white-space: nowrap;
  }
</style>

<h1 align="center">
  <br>
  <!--<a href=""><img src="" alt="Markdownify" width="200"></a>-->
  <br>
  InfoBlox BloxOneDDI & BloxOne Threat Defense Powershell Module
  <br>
</h1>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/ibPS"><img src="https://img.shields.io/powershellgallery/v/ibPS?label=Powershell%20Gallery&style=flat-square"></a>
  <a href="https://github.com/TehMuffinMoo/ibPS"><img src="https://img.shields.io/github/v/release/TehMuffinMoo/ibPS.svg?label=Github Release&size=flat-square"></a>
  <a href="https://github.com/TehMuffinMoo/ibPS"><img src="https://img.shields.io/github/languages/code-size/TehMuffinMoo/ibPS.svg?label=Code%20Size&style=flat-square"></a>
  <a href="https://www.powershellgallery.com/packages/ibPS"><img src="https://img.shields.io/powershellgallery/dt/ibPS?label=Downloads&style=flat-square"></a>
  <a href="https://raw.githubusercontent.com/TehMuffinMoo/ibPS/main/LICENSE"><img src="https://img.shields.io/github/license/TehMuffinMoo/ibPS?label=License&style=flat-square"></a>
  <a href="https://www.powershellgallery.com/packages/ibPS"><img src="https://img.shields.io/powershellgallery/p/ibPS?label=Supported Platforms&style=flat-square&color=%236600bf"></a>
  <a href="https://github.com/TehMuffinMoo/ibPS/releases"><img src="https://img.shields.io/github/release-date/tehmuffinmoo/ibps?label=Latest%20Release"></a>
  <a href="https://ibps.readthedocs.io"><img src="https://img.shields.io/readthedocs/ibps?label=Docs&style=flat-square"></a>
</p>

<h4 align="center">A series of PowerShell Cmdlets used to interact with the InfoBlox BloxOne APIs.</h4>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="https://github.com/TehMuffinMoo/ibPS" target="_blank">Github</a> •
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
* Build custom scripts/functions leveraging the [Generic Wrapper Cmdlets](BloxOne/Generic%20Wrapper/).
* Automate the world!

## Limitations

* If the cmdlet you are looking for is not yet built into the Module, you can raise a feature request via Github Issues. You can also use this module as a generic wrapper by leveraging these [Wrapper Cmdlets](BloxOne/Generic%20Wrapper/).
* A [PowerShell module already exists for InfoBlox NIOS](https://www.powershellgallery.com/packages/Posh-IBWAPI/3.2.2) and so limited Cmdlets will be built into this module. Any NIOS cmdlets built in are primarily for the purpose of migration to BloxOneDDI and may be deprecated.

## How To Use

The easiest option to install the ibPS Module is to use the PowerShell Gallery.

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
Set-ibPSConfiguration -CSPAPIKey "<ApiKeyFromCSP>" -Persist
```

##### Single Session
Alternatively, you can simply store your API Key for the current powershell session only.
```powershell
Set-ibPSConfiguration -CSPAPIKey "<ApiKeyFromCSP>"
```

## BloxOne Cmdlets
All Cmdlets are listed in the left-hand menu. You can also use the `Get-Help` cmdlet to get detailed information on usage. Example;

```powershell
Get-Help New-B1AddressBlock -Detailed
```

### Common Parameters
Supported `Get-*` cmdlets have `-Strict`, `-tfilter`, `-Fields`, `-OrderBy`, `-OrderByTag`, `-Limit` & `-Offset` parameters. Their use is described below.

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
    <td class="paramName">
      -Strict
    </td>
    <td>
This is used to apply strict name checking when querying objects.  
The default is to perform wildcard/lazy matches based on submitted query parameters.
    </td>
  </tr>
  <tr>
    <td class="paramName">
      -tfilter
    </td>
    <td>
This is used to filter results of your query by tags.
<pre>Get-B1Record -tfilter '("myTag"=="val1" or "myOtherTag"~"partvalue")'</pre>
    </td>
  </tr>
  <tr>
    <td class="paramName">
      -Fields
    </td>
    <td>
This is used to filter the fields returned by the API
<pre>Get-B1Record -Fields name_in_zone,absolute_zone_name,rdata </pre>
    </td>
  </tr>
  <tr>
    <td class="paramName">
      -OrderBy
    </td>
    <td>
This is used to order the results returned from the API. It defaults to ascending if no suffix is set, but can be set using 'asc' or 'desc' as shown below.
<pre>Get-B1Host -OrderBy 'display_name asc'</pre>
    </td>
  </tr>
  <tr>
    <td class="paramName">
      -OrderByTag
    </td>
    <td>
This is used to order the results returned from the API based on tag. It defaults to ascending if no suffix is set, but can be set using 'asc' or 'desc' as shown below.
<pre>Get-B1Host -OrderByTag 'nios/grid_name desc'</pre>
    </td>
  </tr>
  <tr>
    <td class="paramName">
      -Limit
    </td>
    <td>
This is used to specify the number of results to return from the API.
<pre>Get-B1ServiceLog -B1Host MyB1Host -Start (Get-Date).AddHours(-6) -Limit 1000</pre>
    </td>
  </tr>
  <tr>
    <td class="paramName">
      -Offset
    </td>
    <td>
The -Offset parameter will offset the results returned by the amount specified. This is used in combination with -Limit to achieve pagination of API results.
<pre>Get-B1ServiceLog -B1Host MyB1Host -Start (Get-Date).AddHours(-6) -Limit 1000 -Offset 1000</pre>
    </td>
  </tr>
  <tr>
    <td class="paramName">
      -CustomFilters
    </td>
    <td>
The -CustomFilters parameter allows you to use custom filters when interacting with the API and supports inputs as String, Object or ArrayList. See the <a href="#-customfilters">Custom Filters</a> section for usage information.
    </td>
  </tr>
</table>

#### -CustomFilters
The `-CustomFilters` parameter can be used to apply custom filtering to API calls. It supports inputs as either String, Object or ArrayList as shown below;

##### String
```powershell
$CustomFilters = 'name~"10.1.2.3" and state=="enabled"'
```

##### Object
```powershell
$CustomFilters = @(
  @{
    "Property"="name"
    "Operator"="~"
    "Value"="postman"
  }
  @{
    "Property"="state"
    "Operator"="=="
    "Value"="enabled"
  }
)
```

##### ArrayList
```powershell
[System.Collections.ArrayList]$CustomFilters = @()
$CustomFilters.Add('name~"postman"') | Out-Null
$CustomFilters.Add('state=="enabled"') | Out-Null
```

## General Cmdlets
```powershell
Get-ibPSVersion -CheckForUpdates
  # Gets the ibPS Module Version.
  # Using -CheckForUpdates optionally checks if ibPS is up to date
  # Using -Update will optionally perform an in place upgrade of the ibPS module
  # Using -Force will force the update/replacement of ibPS, regardless of the current version
```

## Pipeline Support
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
Remove-B1InternalDomainList      | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1InternalDomainList
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
Set-B1TideDataProfile            | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1TideDataProfile
Set-B1InternalDomainList         | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1InternalDomainList
Remove-B1SecurityPolicy          | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1SecurityPolicy
Remove-B1NetworkList             | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1NetworkList
Get-B1DossierLookup              | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Start-B1DossierLookup
Set-B1Object                     | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Object
Get-B1ZoneChild                  | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1DNSView<br>Get-B1AuthoritativeZone<br>Get-B1ForwardZone
Get-B1IPAMChild                  | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Space<br>Get-B1AddressBlock<br>Get-B1Subnet<br>Get-B1Range
Get-B1AddressBlockNextAvailable  | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1AddressBlock
Get-B1AddressNextAvailable       | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1Address<br>Get-B1Subnet<br>Get-B1Range
Get-B1SubnetNextAvailable        | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1AddressBlock
Get-NetworkInfo                  | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1AddressBlock<br>Get-B1Subnet<br>Get-B1AddressBlockNextAvailable<br>Get-B1SubnetNextAvailable
Get-B1SecurityPolicyRules        | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1SecurityPolicy
Get-B1SOCInsightAssets           | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1SOCInsight
Get-B1SOCInsightComments         | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1SOCInsight
Get-B1SOCInsightEvents           | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1SOCInsight
Get-B1SOCInsightIndicators       | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1SOCInsight
Set-B1SOCInsight                 | ![Implemented](https://badgen.net/badge/Status/Implemented/green)  | Get-B1SOCInsight




## To-Do
All new commits will first be made to the [dev branch](https://github.com/TehMuffinMoo/ibPS/tree/dev) until tested, where updates are then posted to main.


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
