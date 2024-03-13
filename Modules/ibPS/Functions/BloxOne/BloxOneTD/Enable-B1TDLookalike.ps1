function Enable-B1TDLookalike {
    <#
    .SYNOPSIS
        Unmutes a lookalike domain

    .DESCRIPTION
        This function is used to unmute a lookalike domain

    .PARAMETER LookalikeDomain
        One or more identified lookalikes to unmute

    .EXAMPLE
        PS> Enable-B1TDLookalike -LookalikeDomain "google98.pro","return-tax-hmrc.com"

        Successfully unmuted lookalike: google98.pro
        Successfully unmuted lookalike: return-tax-hmrc.com

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense

    .NOTES
        Used in combination with Disable-B1TDLookalike to mute/unmute lookalike domains.
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String[]]$LookalikeDomain
    )

    $UnmutedDomains = @()

    foreach ($DomainToUnmute in $LookalikeDomain) {
        $UnmutedDomains += $DomainToUnmute
    }

    if ($UnmutedDomains) {
        $JSONData = @{
            "expose" = $UnmutedDomains
        } | ConvertTo-Json
        $Results = Query-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/atclad/v1/lookalikes" -Data $($JSONData) -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

        foreach ($UnmutedDomain in $UnmutedDomains) {
            if (Get-B1TDLookalikes -LookalikeDomain $($UnmutedDomain) -Muted false) {
                Write-Host "Successfully unmuted lookalike domain: $($UnmutedDomain)" -ForegroundColor Green
            } else {
                Write-Host "Failed to unmute lookalike domain: $($UnmutedDomain)" -ForegroundColor Red
            }
        }
    }
}