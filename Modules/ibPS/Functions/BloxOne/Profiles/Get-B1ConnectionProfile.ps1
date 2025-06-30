function Get-B1ConnectionProfile {
    <#
    .SYNOPSIS
        This function is used to retrieved saved Infoblox Portal connection profiles. By default, the active profile is returned.

    .DESCRIPTION
        Connection profiles provide a convenient way of saving API Keys for multiple Infoblox Portal Accounts. These can then easily be switched between by using [Switch-B1ConnectionProfile](https://ibps.readthedocs.io/en/latest/BloxOne/Profiles/Switch-B1ConnectionProfile/).

    .PARAMETER Name
        Return a specific connection profile based on its name

    .PARAMETER List
        Return a list of all saved connection profiles.

    .PARAMETER IncludeAPIKey
        The -IncludeAPIKey indicates whether the API Key(s) should be returned in the response

    .EXAMPLE
        PS> Get-BCP | ft

        Active  Name   CSP User   CSP Account    API Key
        ------  ----   --------   -----------    -------
        True    Prod   svc-ps     ACME Corp      ********


    .EXAMPLE
        PS> Get-B1ConnectionProfile -List | ft

        Active  Name   CSP User   CSP Account                API Key
        ------  ----   --------   -----------                -------
        True    Prod   svc-ps     ACME Corp                  ********
        False   Dev    svc-ps     ACME Corp | Sandbox (Dev)  ********
        False   Test   svc-ps     ACME Corp | Sandbox (Test) ********

    .FUNCTIONALITY
        BloxOne

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    [Alias('Get-BCP')]
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'IncludeAPIKey', Justification = 'False positive as rule does not scan child scopes')]
    param(
        [String]$Name,
        [Switch]$List,
        [Switch]$IncludeAPIKey
    )
    $Configs = Get-B1Context

    function GetCurrentAccountInfo($ProfileName) {
        if (-not $Script:B1AI) {
            $Script:B1AI = @{}
        }
        if (-not $Script:B1AI."$ProfileName") {
            $B1CU = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl -ProfileName $ProfileName)/v2/current_user" -APIKey (Get-B1CSPAPIKey -ProfileName $ProfileName) -ProfileName $ProfileName | Select-Object -ExpandProperty result
            $B1CA = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl -ProfileName $ProfileName)/v2/current_user/accounts" -APIKey (Get-B1CSPAPIKey -ProfileName $ProfileName) -ProfileName $ProfileName | Select-Object -ExpandProperty results | Where-Object {$_.id -eq $B1CU.account_id}
            $Script:B1AI."$ProfileName" = @{
                'User' = $(if ($B1CU.Name) {$B1CU.Name} else { 'Invalid or Expired API Key' })
                'Account' = $(if ($B1CA.Name) {$B1CA.Name} else { 'Invalid or Expired API Key' })
            }
        }
        return $Script:B1AI."$ProfileName"
    }

    $ReturnProperties = @{
        Property =  @{n="Active";e={if ($_.Name -eq $Configs.CurrentContext) { $True } else { $False } }},
                    @{n="Name";e={$_.Name}},
                    @{n="CSP URL";e={$_.URL}},
                    @{n="CSP User";e={(GetCurrentAccountInfo -ProfileName $_.Name).User}},
                    @{n="CSP Account";e={(GetCurrentAccountInfo -ProfileName $_.Name).Account}},
                    @{n="API Key";e={if ($IncludeAPIKey) {Get-B1CSPAPIKey -ProfileName $_.Name} else { "********" }}}
    }
    if ($Name) {
        if ($Configs.Contexts."$($Name)") {
            return $Configs.Contexts | Select-Object -ExpandProperty $Name | Select-Object @ReturnProperties
        }
    } elseif ($List) {
        $ReturnList = @()
        $Configs.Contexts.PSObject.Properties.Name | ForEach-Object {
            $ReturnList += $Configs.Contexts."$($_)" | Select-Object @ReturnProperties
        }
        return $ReturnList
    } else {
        if ($Configs.CurrentContext) {
            return $Configs.Contexts."$($Configs.CurrentContext)" | Select-Object @ReturnProperties
        }
    }
}