function Disable-B1TDLookalike {
    <#
    .SYNOPSIS
        Mutes a lookalike domain

    .DESCRIPTION
        This function is used to mute a lookalike domain

    .PARAMETER Domain
        One or more identified lookalikes to mute

    .EXAMPLE
        PS> Disable-B1TDLookalike -LookalikeDomain "google98.pro","return-tax-hmrc.com"

        Successfully muted lookalike: google98.pro
        Successfully muted lookalike: return-tax-hmrc.com

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String[]]$LookalikeDomain
    )

    $MutedDomains = @()

    foreach ($DomainToMute in $LookalikeDomain) {
        $MutedDomains += $DomainToMute
    }

    if ($MutedDomains) {
        $JSONData = @{
            "hide" = $MutedDomains
        } | ConvertTo-Json
        $Results = Query-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/atclad/v1/lookalikes" -Data $($JSONData) -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

        foreach ($MutedDomain in $MutedDomains) {
            if (Get-B1TDLookalikes -LookalikeDomain $($MutedDomain) -Muted true) {
                Write-Host "Successfully muted lookalike domain: $($MutedDomain)" -ForegroundColor Green
            } else {
                Write-Host "Failed to mute lookalike domain: $($MutedDomain)" -ForegroundColor Red
            }
        }
    }
}