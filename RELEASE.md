- Add `New-B1TDLookalikeTarget`, `Remove-B1TDLookalikeTarget`, `Set-B1TDLookalikeTarget` cmdlets
- Add `Get-B1Licenses` cmdlet to retrieve license information
- Add `Get-B1TDLookalikeTargetSummary` cmdlet for lookalike summary, the same as the Activity page within the CSP.
- Add `Enable-B1TDLookalikeTargetCandidate` & `Disable-B1TDLookalikeTargetCandidate` cmdlets. The -Domain parameter auto-completes based on available domains.
- Add `Enable-B1TDLookalike` and `Disable-B1TDLookalike` for Unmuting/Muting lookalike domains
- Add `Submit-B1TDTideData` for submitting TIDE data either as individual records, or from CSV/TSV/PSV, JSON & XML files. The ThreatClass and `-ThreatProperty` parameters support tab-completion.
- Added tab-completion to the `-ThreatClass` and `-ThreatProperty` parameters on `Get-B1DNSEvent` 
- Split BloxOne Platform cmdlets into separate directory for better documentation structure
- Update all parameter set names to something more friendly

| :warning: Breaking Changes - **`Get-B1DFPLog`**     |
|:--------------------------------------------------|
| The new `-Source` parameter has been renamed to `-Network` to make it consistent with `Get-B1DNSEvent` and the underlying API naming scheme |
| See the <a href="https://ibps.readthedocs.io/en/dev/Functions/BloxOne%20DDI/Get-B1DFPLog/">Documentation</a> for further details |