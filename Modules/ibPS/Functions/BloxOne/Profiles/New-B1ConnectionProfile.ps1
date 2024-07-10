function New-B1ConnectionProfile {
    <#
    .SYNOPSIS
        This function is used to create new BloxOne connection profiles. By default, the new profile will be set as active.

    .DESCRIPTION
        Connection profiles provide a convenient way of saving API Keys for multiple BloxOne Accounts. These can then easily be switched between by using [Switch-B1ConnectionProfile](https://ibps.readthedocs.io/en/latest/BloxOne/Profiles/Switch-B1ConnectionProfile/).

    .PARAMETER Name
        Specify the name for the new connection profile

    .PARAMETER APIKey
        Specify the BloxOne API Key to save as part of this profile

    .PARAMETER NoSwitchProfile
        Do not make this profile active upon creation

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
    param (
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [String]$APIKey,
        [Switch]$NoSwitchProfile
    )

    $Config = @{
       "Name" = $Name
       "API Key" = $([Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($($APIKey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString))))
    }
    Set-B1Context -Name $Name -Config $Config -NoSwitchProfile:$($NoSwitchProfile)
}