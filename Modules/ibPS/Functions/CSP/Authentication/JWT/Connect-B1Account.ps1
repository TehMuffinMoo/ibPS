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

        Successfully connected to MyAccount using: my.name@email.com.

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
        [ValidateSet("US","EU")]
        [String]$CSPRegion = 'US',
        [String]$CSPUrl,
        [Parameter(Mandatory = $false)]
        [SecureString]$SecurePassword
    )

    if (-not $SecurePassword) {
        $Password = Read-Host -Prompt "Enter your password for $Email" -AsSecureString
    } else {
        $Password = $SecurePassword
    }

    switch ($CSPRegion) {
        "US" {
            $CSPUrl = "https://csp.infoblox.com"
        }
        "EU" {
            $CSPUrl = "https://csp.eu.infoblox.com"
        }
    }
    $ENV:B1CSPUrl = $CSPUrl

    $Body = @{
        email = $Email
        password = ConvertFrom-SecureString -SecureString $Password -AsPlainText
    } | ConvertTo-Json

    $Headers = @{
        "Content-Type" = "application/json"
    }

    try {
        $Result = Invoke-RestMethod -Method POST -Uri "$($CSPUrl)/v2/session/users/sign_in" -Body $Body -Headers $Headers -ContentType "application/json"
        if ($Result.jwt -ne $null) {
            $ENV:B1Bearer = $Result.jwt
            if ($CU = Get-B1CSPCurrentUser) {
                $CA = Get-B1CSPCurrentUser -Account
                Write-Host "Successfully connected to $($CA.name) using: $($CU.email)." -ForegroundColor Green
            } else {
                Write-Error "Successfully retrieved JWT but no active user details were returned."
            }
        } else {
            if ($Result.error.message) {
                Write-Error "$($Result.error.message)"
            } else {
                Write-Error "An unknown error occurred while connecting to the Infoblox Portal. Please check your credentials and try again."
            }
        }
    } catch {
        $json = $_ | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($json.error) {
            Write-Error "$($json.error.message)"
        } else {
            Write-Error "An unknown error occurred while connecting to the Infoblox Portal. Please check your credentials and try again."
        }
    }
}