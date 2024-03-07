## 1.9.2.8
- Remove mandatory flag in the `New-B1Subnet` & `New-B1Space` cmdlets for the `-Name` parameter
- Split BloxOne DDI & BloxOne Threat Defense functions to aid better documentation separation
- Updated most of the BloxOne Threat Defense Help Information/Documentation
> [!WARNING]  
> Breaking Change to Get-B1DFPLog cmdlet!
>
> The `-Source` parameter has been renamed to `-IP` to make it consistent with `Get-B1DNSLog`
>
> A new `-Source` parameter has been created. This is used to specify the Source of the DNS Event (i.e DFP, External Network or Endpoint) and allows multiple values to be inputted
>
> See the <a href="https://ibps.readthedocs.io/en/dev/Functions/BloxOne%20DDI/Get-B1DFPLog/">Documentation</a> for further details

## 1.9.2.6
- New documentation available at <a href="https://ibps.readthedocs.io/">ibPS</a>
- Update comment-based help of various cmdlets
- Create new provisioning workflow for future updates, including full change and release history in the RELEASE.md and CHANGELOG.md files


## 1.9.2.5
- Add New-B1Object cmdlet to the generic cmdlet offering. This now includes all Get, Set, New & Remove cmdlets.


## 1.9.2.4
- Update New-B1Service & Get-B1Service to replace service specific parameters to a dynamically generated -Type parameter.

> [!WARNING]  
> Breaking Change!
>
> The -DNS, -DHCP & -NTP parameters have been removed from New-B1Service in favour of a -Type parameter where the options are generated automatically.
>
> The syntax would now be something like;
> 
> `New-B1Service -Type dns -Name "dns_myb1host -OnPremHost "myb1host"`


## 1.9.2.3
- Fix issue deploying BloxOne OVA with Infoblox self-signed certificate


## 1.9.2.2
- Add support for secondary zones when using Get-B1AuthoritativeZone & New-B1AuthoritativeZone


## 1.9.2.1
- Fix to Set-B1HAGroup on Windows devices


## 1.9.2
- Fixes to Set-B1Object, creds for VMware deployments, introduce a new Set-B1HAGroup cmdlet and an optional -Associations parameter to list associated subnets/ranges when querying Get-B1DHCPHost


## 1.9.1.9
- Update Start-B1Export with latest version control + some minor enhancement


## 1.9.1.8
- Add -Branch parameter to Get-ibPSVersion to support changing between main/dev branches


## 1.9.1.7
- Introduce -DownloadLatestImage and -ImagesPath for automatically obtaining latest image and providing local cache to avoid duplicate downloads


## 1.9.1.6
- Hyper-V deployment integration using Deploy-B1Appliance


## 1.9.1.1
- Add -Fields parameter on all supported Get- cmdlets


## 1.9.1.0
- Minor updates & begin testing -CustomFilters parameter


## 1.9.0.108
- Improve multiple version checking


## 1.9.0.107
- Cleanup misc functions


## 1.9.0.106
- Add warning when multiple versions of ibPS are present on the computer


## 1.9.0.105
- Import Miscellaneous Functions


## 1.9.0.104
- Cleanup Miscellaneous Functions


## 1.9.0.103
- Fix issue with version being displayed when using Get-ibPSVersion on Windows


## 1.9.0.99
- Initial Gallery Publication


