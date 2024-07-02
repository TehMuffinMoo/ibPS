## Get Dossier Results

This is a example of how to return related information from a Dossier Search. This example shows retrieiving data related to tasks for PDNS (Related Domains) and DNS (Current DNS)

```powershell
## Initiate New Search & Wait for completion
$Search = Start-B1DossierLookup -Type host -Value 'google.com' -Wait
## Get Results for each associated task
$TaskResults = $Search | Get-B1DossierLookup -TaskResults

## Get PDNS Results (Related Domains)
($TaskResults.results | Where-Object {$_.params.source -eq 'pdns'}).data.items

## Get DNS Results (Current DNS)
($TaskResults.results | Where-Object {$_.params.source -eq 'dns'}).data
```