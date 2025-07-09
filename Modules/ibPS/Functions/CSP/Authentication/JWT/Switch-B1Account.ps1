function Switch-B1Account {
    param(
        $id
    )

    if (!$ENV:B1Bearer) {
        Write-Error "You must be connected to a BloxOne account before switching accounts. Please use Connect-B1Account first."
        return
    }

    $Body =  @{
      id = $id
    } | ConvertTo-Json

    $Headers = @{
        "Authorization" = "Bearer $ENV:B1Bearer"
    }

    $Result = Invoke-RestMethod -Method POST -Uri "https://csp.infoblox.com/v2/session/account_switch" -Body $Body -Headers $Headers -ContentType "application/json"
    
    if ($Result.jwt -ne $null) {
        $ENV:B1Bearer = $Result.jwt
        Write-Host "Successfully switched account." -ForegroundColor Green
    } else {
        Write-Error "Failed to switch account. Please check the account ID and try again."
        return $Result
    }
}