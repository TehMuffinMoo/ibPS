function Connect-B1Account {
    <#
    .SYNOPSIS
        Connects to the Infoblox Portal and retrieves an interactive JWT session token, enabling the use of account switching.

    .DESCRIPTION
        Connects to the Infoblox Portal and retrieves an interactive JWT session token, enabling the use of account switching.

        In most cases, I would recommend using API Keys as they remain persistent for the length of the key's lifetime, and do not require re-authentication.

        However, in cases such as automating the creation of Sandboxes; you will not have received an API Key for the sandbox account yet. Using a JWT session token with this function will enable you to switch into the Sandbox account(s) and perform the necessary operations and optionally create persistent API Key(s).

        When connected to the Infoblox Portal using this function, it will override any active connection profile configured in Get-B1ConnectionProfile for the duration of the session. You can disconnect from the Infoblox Portal using Disconnect-B1Account, which will restore the previous connection profile.

    .PARAMETER Email
        The email address of the Infoblox Portal account to use when connecting.

    .PARAMETER SecurePassword
        The password of the Infoblox Portal account to use when connecting, in SecureString format.

    .EXAMPLE
        PS> Connect-B1Account -Email "my.name@domain.com" -Password "mySuperSecurePassword"

        Successfully connected to MyAccount using: my.name@email.com.

    .FUNCTIONALITY
        Infoblox Portal

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    param(
        [Parameter(Mandatory = $true,ParameterSetName="JWT")]
        [string]$Email,
        [Parameter(Mandatory = $true,ParameterSetName="API")]
        [switch]$APIKey,
        [ValidateSet("US","EU")]
        [String]$CSPRegion = 'US',
        [Parameter(Mandatory = $false,ParameterSetName="JWT")]
        [SecureString]$SecurePassword,
        [Parameter(Mandatory = $false,ParameterSetName="API")]
        [SecureString]$SecureAPIKey
    )

    try {
        $AuthManager = [AuthManager]::new($CSPRegion)
        if ($Email) {
            if (-not $SecurePassword) {
                $Password = Read-Host -Prompt "Enter your password for $Email" -AsSecureString
            } else {
                $Password = $SecurePassword
            }
            $AuthManager.ConnectJWT($Email,$Password)
            if ($AuthManager.JWT) {
                $Script:AuthManager = $AuthManager
            }
        } elseif ($APIKey) {
            if (-not $SecureAPIKey) {
                $SecureAPIKey = Read-Host -Prompt "Enter your API Key" -AsSecureString
            }
            $AuthManager.ConnectAPIKey($SecureAPIKey)
            if ($AuthManager.APIKey) {
                $Script:AuthManager = $AuthManager
                $CU = Get-B1CSPCurrentUser -ErrorAction SilentlyContinue
                if ($CU) {
                    Write-Host "Connected using API Key as: $($CU.name)" -ForegroundColor Green
                } else {
                    Write-Error "Failed to connect using API Key. Please check your API Key and try again."
                    $Script:AuthManager = $null
                    return
                }
            }
        }
    } catch {
        Write-Error $_
        $Script:AuthManager = $null
    }
}