function Disable-B1TDLookalikeTargetCandidate {
    <#
    .SYNOPSIS
        Disables a lookalike from the Common Watched Domains list

    .DESCRIPTION
        This function is used to disable a lookalike from the Common Watched Domains list

    .PARAMETER Domain
        One or more common watched domain to disable

        This parameter auto-completes based on the current list of enabled domains

    .EXAMPLE
        PS> Disable-B1TDLookalikeTargetCandidate -Domain "adobe.com","airbnb.com"

        Successfully disabled lookalike candidate: adobe.com
        Successfully disabled lookalike candidate: airbnb.com

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String[]]$Domain
    )

    $DisabledDomains = @()

    foreach ($DomainToDisable in $Domain) {
        $DisabledDomains += $DomainToDisable
    }

    if ($DisabledDomains) {
        $JSONData = @{
            "select" = @()
            "unselect" = $DisabledDomains
        } | ConvertTo-Json
        $Results = Query-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/lookalike_target_candidates" -Data $($JSONData) -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

        $Candidates = Get-B1TDLookalikeTargetCandidates | Select-Object -ExpandProperty items_described
        foreach ($DisabledDomain in $DisabledDomains) {
            if (($Candidates | Where-Object {$_.item -eq $DisabledDomain}).selected -ne "True") {
                Write-Host "Successfully disabled lookalike candidate: $($DisabledDomain)" -ForegroundColor Green
            } else {
                Write-Host "Failed to disabled lookalike candidate: $($DisabledDomain)" -ForegroundColor Red
            }
        }
    }
}