function Disconnect-B1Account {
    <#
    .SYNOPSIS
        Disconnects from the Infoblox Portal and invalidates the interactive JWT session token.

    .DESCRIPTION
        Disconnects from the Infoblox Portal and invalidates the interactive JWT session token.

    .EXAMPLE
        PS> Disconnect-B1Account

        Successfully disconnected from the Infoblox Portal.

    .FUNCTIONALITY
        Infoblox Portal

    .FUNCTIONALITY
        Core

    .FUNCTIONALITY
        Authentication
    #>
    param()
    if ($ENV:B1Bearer) {
        $CU = Get-B1CSPCurrentUser
        $CA = Get-B1CSPCurrentUser -Account
        if ($CU -and $CA) {
            Write-Host "Disconnecting from $($CA.name) using: $($CU.email)." -ForegroundColor Green
        } else {
            Write-Host "Already disconnected from the Infoblox Portal." -ForegroundColor Green
            return
        }
    } else {
        Write-Error "You are not currently connected to the Infoblox Portal. Please use Connect-B1Account first."
        return
    }

    $Headers = @{
        "Authorization" = "Bearer $($ENV:B1Bearer)"
    }

    try {
        $ENV:B1Bearer = $null
        $Result = Invoke-RestMethod -Method DELETE -Uri "$($ENV:B1CSPUrl)/v2/session/users/sign_out" -Headers $Headers
        Write-Host "Disconnected Successfully." -ForegroundColor Green
    } catch {
        Write-Error "An unknown error occurred while disconnecting from the Infoblox Portal."
        return $_
    }
}