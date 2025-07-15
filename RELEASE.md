- Fix bug with `Install.ps1` file encoding, preventing automated install from working.
- Add `Connect-B1Account`, `Disconnect-B1Account` & `Switch-B1Account` to enable support for interactive based authentication and account switching.
- Move JWT & API based connections to new class, including moving Global API Key usage to `Connect-B1Account -APIKey`

### Breaking Changes

|  **Deprecate old Environment Variables**  |
|:-------------------------|
| As part of some cleanup and ongoing improvements, old environment variables such as `B1APIKEY` & `IBPSB1APIKEY` are being deprecated. |
| If scripts are currently configured to use `Set-ibPSConfiguration -CSPAPIKey <apikey>` or inject API Keys via Environment Variables, these will no longer work. |
| This should be replaced with `Connect-B1Account` or `New-B1ConnectionProfile` for non-persistent/persistent connections respectively. |