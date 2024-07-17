- Add `New-B1ConnectionProfile`, `Get-B1ConnectionProfile`, `Remove-B1ConnectionProfile` & `Switch-B1ConnectionProfile` functions to enable configuring multiple CSP Accounts which can be easily switched between.
- Add `Get-B1RPZFeed` function
- Add new CubeJS wrapper functions for interacting with the BloxOne CubeJS API
- Add `-VMHost` parameter to `Deploy-B1Appliance` when using `-Type VMware`. This is used both to specify a specific host on a Cluster, or on its own to enable support for deploying to standalone hosts.
- Various minor code improvements & fixes
- Refactored all code to remove unneccessary whitespace and unused variables
- Add auto-complete to `-Source` parameter on `Start-B1DossierLookup`

### Breaking Changes
Support for `ShouldProcess` is being added for all functions, which enables three new parameters. `-Confirm`, `-WhatIf` & `-Force`.  
The default PowerShell configuration has `$ConfirmPreference` set to **High**. Unless you have changed this, only `Remove` operations will be impacted by this change.

- All `Get` and equivilent read commands are set to `ConfirmImpact=Low`.
  - These commands will not prompt for confirmation if `$ConfirmPreference` is None, Medium or High.
- All `Set` and equivilent update commands are set to `ConfirmImpact=Medium`.
  - These commands will not prompt for confirmation if `$ConfirmPreference` is None or High.
- All `New` and equivilent new commands are set to `ConfirmImpact=Medium`.
  - These commands will not prompt for confirmation if `$ConfirmPreference` is None or High.
- All `Remove` and equivilent destroy commands are set to `ConfirmImpact=High`
  - These commands **will** prompt for confirmation unless `$ConfirmPreference` is set to None.
- All `Grant` & `Revoke` commands are set to `ConfirmImpact=High`
  - These commands **will** prompt for confirmation unless `$ConfirmPreference` is set to None.
 
A handy reference table has been included below;

|       Operation Type       |       Confirm Impact       |       No Prompt When       |
|:---------------------------|:---------------------------|:---------------------------|
| `Get`                      | `Low`                      | `None`, `Medium`, `High`   |
| `Set`                      | `Medium`                   | `None`, `High`             |
| `New`                      | `Medium`                   | `None`, `High`             |
| `Remove`                   | `High`                     | `None`                     |
| `Grant`                    | `High`                     | `None`                     |
| `Revoke`                   | `High`                     | `None`                     |

You can check your current preference by running `$ConfirmPreference` in your terminal.  
See here for more information on [Preference Variables](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.4#confirmpreference)