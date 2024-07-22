function New-B1ConnectionProfile {
    <#
    .SYNOPSIS
        This function is used to create new BloxOne connection profiles. By default, the new profile will be set as active.

    .DESCRIPTION
        Connection profiles provide a convenient way of saving API Keys for multiple BloxOne Accounts. These can then easily be switched between by using [Switch-B1ConnectionProfile](https://ibps.readthedocs.io/en/latest/BloxOne/Profiles/Switch-B1ConnectionProfile/).

    .PARAMETER Name
        Specify the name for the new connection profile

    .PARAMETER CSPRegion
        Optionally configure the the CSP Region to use (i.e EU for the EMEA instance). You only need to use -CSPRegion OR -CSPUrl.

    .PARAMETER CSPUrl
        Optionally configure the the CSP URL to use manually. You only need to use -CSPUrl OR -CSPRegion.

    .PARAMETER APIKey
        Specify the BloxOne API Key to save as part of this profile

    .PARAMETER NoSwitchProfile
        Do not make this profile active upon creation

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-BCP

    .EXAMPLE
        PS> New-B1ConnectionProfile

    .FUNCTIONALITY
        BloxOne

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    [Alias('New-BCP')]
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification='Required to obtain API Key')]
    param (
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [ValidateSet("US","EU")]
        [Parameter(
            Mandatory=$true,
            ParameterSetName='Region'
        )]
        [String]$CSPRegion,
        [Parameter(
            Mandatory=$true,
            ParameterSetName='URL'
        )]
        [String]$CSPUrl,
        [Parameter(Mandatory=$true)]
        [String]$APIKey,
        [Switch]$NoSwitchProfile
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    if ($CSPRegion) {
        switch ($CSPRegion) {
            "US" {
                $CSPUrl = "https://csp.infoblox.com"
            }
            "EU" {
                $CSPUrl = "https://csp.eu.infoblox.com"
            }
        }
    }

    $Config = @{
       "Name" = $Name
       "URL" = $CSPUrl
       "API Key" = $([Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($($APIKey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString))))
    }
    if($PSCmdlet.ShouldProcess("Create new BloxOne Connection Profile:`n$($Config | ConvertTo-Json)","Create new BloxOne Connection Profile: $($Name)",$MyInvocation.MyCommand)){
        Set-B1Context -Name $Name -Config $Config -NoSwitchProfile:$($NoSwitchProfile)
    }
}