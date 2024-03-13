- Add `New-B1TDLookalikeTarget`, `Remove-B1TDLookalikeTarget`, `Set-B1TDLookalikeTarget` cmdlets
- Add `Get-B1Licenses` cmdlet to retrieve license information
- Add `Get-B1TDLookalikeTargetSummary` cmdlet for lookalike summary, the same as the Activity page within the CSP.
- Split BloxOne Platform cmdlets into separate directory for better documentation structure
- Update all parameter set names to something more friendly
> [!WARNING]  
> (Another) Breaking Change to Get-B1DFPLog cmdlet!
>
> The new `-Source` parameter has been renamed to `-Network` to make it consistent with `Get-B1DNSEvent` and the underlying API naming scheme
>
> See the <a href="https://ibps.readthedocs.io/en/dev/Functions/BloxOne%20DDI/Get-B1DFPLog/">Documentation</a> for further details