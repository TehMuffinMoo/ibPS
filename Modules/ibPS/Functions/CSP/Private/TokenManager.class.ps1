class B1Session {
    [string]$Type
    [string]$Email
    [string]$CSPRegion = 'US'
    [string]$CSPUrl
    [string]$APIKey
    [string]$JWT
    [System.Timers.Timer]$RenewalTimer
    [string]$TimerEventId

    B1Session([string]$region = 'US') {
        $this.CSPRegion = $region
        switch ($region) {
            'US' { $this.CSPUrl = 'https://csp.infoblox.com' }
            'EU' { $this.CSPUrl = 'https://csp.eu.infoblox.com' }
            default { throw "Unsupported region: $region" }
        }
    }

    [void]ConnectJWT([string]$email,[securestring]$SecurePassword) {
        $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)

        $this.Type = 'JWT'
        $this.Email = $email

        $body = @{
            email = $this.Email
            password = $plainPassword
        } | ConvertTo-Json

        $headers = @{ "Content-Type" = "application/json" }

        try {
            $result = Invoke-RestMethod -Method POST -Uri "$($this.CSPUrl)/v2/session/users/sign_in" -Body $body -Headers $headers
            if ($result.jwt) {
                $this.JWT = $result.jwt
                $this.StartRenewalTimer()
                Write-Host "Connected as $($this.Email)" -ForegroundColor Green
            } else {
                throw "No JWT returned."
            }
        } catch {
            Write-Error "Failed to connect: $_"
        }
    }

    [void]ConnectAPI([securestring]$SecureAPIKey) {
        $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureAPIKey)
        $this.APIKey = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)

        $this.Type = 'API'
    }

    [void]Disconnect() {
        if (-not $this.JWT) {
            Write-Warning "No active session to disconnect."
            return
        }

        $headers = @{ "Authorization" = "Bearer $($this.JWT)" }

        try {
            Invoke-RestMethod -Method DELETE -Uri "$($this.CSPUrl)/v2/session/users/sign_out" -Headers $headers
            $this.JWT = $null
            $this.StopRenewalTimer()
            Write-Host "Disconnected successfully." -ForegroundColor Green
        } catch {
            Write-Error "Failed to disconnect: $_"
        }
    }

    [void]StartRenewalTimer() {
        $this.RenewalTimer = New-Object System.Timers.Timer
        $this.RenewalTimer.Interval = 60000
        $this.RenewalTimer.AutoReset = $true

        $session = $this
        $this.TimerEventId = "TimerElapsed_$($this.Email)"

        # Unregister any existing event with the same ID
        Unregister-Event -SourceIdentifier $this.TimerEventId -ErrorAction SilentlyContinue
        Remove-Event -SourceIdentifier $this.TimerEventId -ErrorAction SilentlyContinue

        Register-ObjectEvent -InputObject $this.RenewalTimer -EventName Elapsed -SourceIdentifier $this.TimerEventId -Action {
            $session.UpdateSession()
        } | Out-Null

        $this.RenewalTimer.Start()
    }

    [void]StopRenewalTimer() {
        if ($this.RenewalTimer) {
            if ($this.TimerEventId) {
                Unregister-Event -SourceIdentifier $this.TimerEventId -ErrorAction SilentlyContinue
                Remove-Event -SourceIdentifier $this.TimerEventId -ErrorAction SilentlyContinue
            }
            $this.RenewalTimer.Stop()
            $this.RenewalTimer.Dispose()
        }
    }

    [void]RefreshIfNeeded() {
        if (-not $this.JWT) {
            Write-Warning "No JWT available to refresh."
            return
        }

        try {
            $jwtInfo = $this.ParseJWT($this.JWT)

            if ($jwtInfo.expires -lt [DateTime]::UtcNow) {
                Write-Error "JWT has already expired. Please reconnect using Connect()."
                return
            }

            if ($jwtInfo.expires -lt [DateTime]::UtcNow.AddMinutes(5)) {
                Write-Verbose "JWT is expiring soon. Refreshing session..."
                $this.UpdateSession()
            } else {
                Write-Verbose "JWT is still valid. No refresh needed."
            }
        } catch {
            Write-Error "Failed to evaluate JWT expiration: $_"
        }
    }

    [void]UpdateSession() {
        if (-not $this.JWT) {
            Write-Warning "No JWT to refresh."
            return
        }

        $headers = @{
            "Authorization" = "Bearer $($this.JWT)"
            "Content-Type" = "application/json"
        }

        try {
            $result = Invoke-RestMethod -Method POST -Uri "$($this.CSPUrl)/v2/session/users/renew" -Headers $headers
            if ($result.jwt) {
                $this.JWT = $result.jwt
                Write-Verbose "Session refreshed at $(Get-Date)"
            } else {
                Write-Warning "Failed to refresh session."
            }
        } catch {
            Write-Error "Error refreshing session: $_"
        }
    }

    [pscustomobject]GetSessionInfo() {
        try {

            switch($this.Type) {
                'JWT' {
                    if (-not $this.JWT) {
                        Write-Error "You must be connected to the Infoblox Portal before retrieving the session."
                        return $null
                    }
                    return $this.ParseJWT($this.JWT)
                }
                'API' {
                    if (-not $this.APIKey) {
                        Write-Error "No API Key available."
                        return $null
                    }
                    return $this.APIKey
                }
                default {
                    Write-Error "Unknown session type: $($this.Type)"
                    return $null
                }
            }

            return $null
        } catch {
            Write-Error "An unknown error occurred while retrieving the Infoblox Portal session."
            return $_
        }
    }

    [pscustomobject]ParseJWT([string]$token) {
        if (!$token.Contains(".") -or !$token.StartsWith("eyJ")) { Write-Error "Invalid token" -ErrorAction Stop }

        $tokenheader = $token.Split(".")[0].Replace('-', '+').Replace('_', '/')
        while ($tokenheader.Length % 4) { Write-Verbose "Invalid length for a Base-64 char array or string, adding ="; $tokenheader += "=" }
    
        $tokenPayload = $token.Split(".")[1].Replace('-', '+').Replace('_', '/')
        while ($tokenPayload.Length % 4) { Write-Verbose "Invalid length for a Base-64 char array or string, adding ="; $tokenPayload += "=" }
        $tokenByteArray = [System.Convert]::FromBase64String($tokenPayload)
        $tokenArray = [System.Text.Encoding]::ASCII.GetString($tokenByteArray)
        $tokobj = $tokenArray | ConvertFrom-Json

        $tokobj | Add-Member -MemberType NoteProperty -Name 'issued' -Value (Get-Date -Date "01/01/1970").AddSeconds($tokobj.iat)
        $tokobj | Add-Member -MemberType NoteProperty -Name 'expires' -Value (Get-Date -Date "01/01/1970").AddSeconds($tokobj.exp)
        $tokobj | Add-Member -MemberType NoteProperty -Name 'notBefore' -Value (Get-Date -Date "01/01/1970").AddSeconds($tokobj.nbf)
        
        return $tokobj
    }

    [string]ToString() {
        return "B1Session for $($this.Email) [Region: $($this.CSPRegion)]"
    }
}
