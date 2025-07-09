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
    
    .PARAMETER Password
        The password of the Infoblox Portal account to use when connecting.

    .EXAMPLE
        PS> Connect-B1Account -Email "my.name@domain.com" -Password "mySuperSecurePassword"

        Successfully connected to BloxOne account.

    .FUNCTIONALITY
        Infoblox Portal

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Email,
        [Parameter(Mandatory = $true)]
        [string]$Password
    )

    $Body = @{
        email = $Email
        password = $Password
    } | ConvertTo-Json

    $Headers = @{
        "Content-Type" = "application/json"
    }

    try {
        $Result = Invoke-RestMethod -Method POST -Uri "https://csp.infoblox.com/v2/session/users/sign_in" -Body $Body -Headers $Headers -ContentType "application/json"
        if ($Result.jwt -ne $null) {
            $ENV:B1Bearer = $Result.jwt
            Write-Host "Successfully connected to BloxOne account." -ForegroundColor Green
        } else {
            Write-Error "Failed to connect to BloxOne account. Please check your credentials and try again."
            return $Result
        }
    } catch {
        Write-Error "An error occurred while connecting to the BloxOne account: $_"
    }
}