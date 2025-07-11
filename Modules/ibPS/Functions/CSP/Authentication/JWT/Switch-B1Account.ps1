function Switch-B1Account {
    param(
        [Parameter(Mandatory=$true, ParameterSetName="name")]
        [string]$Name,
        [Parameter(Mandatory=$true, ParameterSetName="id")]
        [string]$id
    )

    if (!$ENV:B1Bearer) {
        Write-Error "You must be connected to a BloxOne account before switching accounts. Please use Connect-B1Account first."
        return
    }

    if ($Name) {
        $Account = Get-B1CSPCurrentUser -Accounts | Where-Object { $_.name -eq $Name }
        if (!$Account) {
            Write-Error "No account found with the name: $Name"
            return
        }
        $id = $Account.id
    }

    $Body =  @{
      id = $id
    } | ConvertTo-Json

    $Headers = @{
        "Authorization" = "Bearer $ENV:B1Bearer"
    }

    try {
        $Result = Invoke-RestMethod -Method POST -Uri "https://csp.infoblox.com/v2/session/account_switch" -Body $Body -Headers $Headers -ContentType "application/json"
        
        if ($Result.jwt -ne $null) {
            $ENV:B1Bearer = $Result.jwt
            if ($CU = Get-B1CSPCurrentUser) {
                $CA = Get-B1CSPCurrentUser -Account
                Write-Host "Successfully switched to $($CA.name) using: $($CU.email)." -ForegroundColor Green
            } else {
                Write-Error "Successfully retrieved new JWT but no active user details were returned."
            }
        } else {
            if ($Result.error) {
                Write-Error "$($Result.error)"
            } else {
                Write-Error "An unknown error occurred while switching accounts."
            }
        }
    } catch {
        $json = $_ | ConvertFrom-Json
        if ($json.error) {
            Write-Error "$($json.error.message)"
        } else {
            Write-Error "An unknown error occurred while switching accounts."
        }
    }
}