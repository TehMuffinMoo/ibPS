# Custom Functions

>* A [PowerShell module already exists for InfoBlox NIOS](https://www.powershellgallery.com/packages/Posh-IBWAPI/3.2.2) and so limited Cmdlets will be built into this module. Any NIOS cmdlets built in are primarily for the purpose of migration to BloxOneDDI and may be deprecated.

You can create custom functions for NIOS by using the `Query-NIOS` cmdlet.

This is a core function used by all NIOS cmdlets when querying an Infoblox NIOS Grid Manager, required when interacting with the NIOS APIs.

`-Server`, `-ApiVersion` & `-Creds` can all be ommitted if you have pre-configured them using `Set-NIOSConfiguration` & `Store-NIOSCredentials` cmdlets

```powershell
Query-NIOS -Method <String> -Server <String> -Uri <String> -ApiVersion <String> -Creds <PSCredential> -Data <String> -SkipCertificateCheck <Switch>
```