## Custom NIOS Functions
You can create custom functions by using the `Query-NIOS` cmdlet.

This is a core function used by all NIOS cmdlets when querying an Infoblox NIOS Grid Manager, required when interacting with the NIOS APIs.

`-Server`, `-ApiVersion` & `-Creds` can all be ommitted if you have pre-configured them using `Set-NIOSConfiguration` & `Store-NIOSCredentials` cmdlets

```powershell
Query-NIOS -Method <String> -Server <String> -Uri <String> -ApiVersion <String> -Creds <PSCredential> -Data <String> -SkipCertificateCheck <Switch>
```