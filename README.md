
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
  <a href="https://www.powershellgallery.com/packages/ibPS"><img src="https://img.shields.io/powershellgallery/p/ibPS?label=Supported Platforms&style=flat-square"></a>
  <a href="https://raw.githubusercontent.com/TehMuffinMoo/ibPS/main/LICENSE"><img src="https://img.shields.io/github/license/TehMuffinMoo/ibPS?label=License&style=flat-square"></a>
</p>

<h4 align="center">A series of PowerShell Cmdlets used to interact with the InfoBlox BloxOne APIs.</h4>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="https://ibps.readthedocs.io" target="_blank">Documentation</a> •
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

## Documentation
All documentation is now available here: [ibPS Documentation](https://ibps.readthedocs.io)

You can also use the `Get-Help` cmdlet to get the same detailed information on usage. Example;

```powershell
Get-Help New-B1AddressBlock -Detailed
```

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

## Resources
This PowerShell Module makes use of the following InfoBlox APIs;

- [CSP Cloud](https://csp.infoblox.com/apidoc)
- [NIOS](https://www.infoblox.com/wp-content/uploads/infoblox-deployment-infoblox-rest-api.pdf)

## License

MIT

---

> [Mat Cox]()
