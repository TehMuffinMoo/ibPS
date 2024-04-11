function Disable-B1LookalikeTargetCandidate {
    <#
    .SYNOPSIS
        Disables a lookalike from the Common Watched Domains list

    .DESCRIPTION
        This function is used to disable a lookalike from the Common Watched Domains list

    .PARAMETER Domain
        One or more common watched domain to disable

        This parameter auto-completes based on the current list of enabled domains

    .EXAMPLE
        PS> Disable-B1LookalikeTargetCandidate -Domain "adobe.com","airbnb.com"

        Successfully disabled lookalike candidate: adobe.com
        Successfully disabled lookalike candidate: airbnb.com

    .EXAMPLE
        PS> Disable-B1LookalikeTargetCandidate -Domain <TabComplete>

        accuweather.com        barclays.co.uk         craigslist.org         googledoc.com          microsoft.com          tripadvisor.com
        active.aero            blackberry.com         cyber.mil.pl           googledocs.com         microsoftonline.com    tumblr.com
        adobe.com              blogger.com            dropbox.com            googledrive.com        mozilla.org            twitch.tv
        ...

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
        $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/lookalike_target_candidates" -Data $($JSONData) -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

        $Candidates = Get-B1LookalikeTargetCandidates | Select-Object -ExpandProperty items_described
        foreach ($DisabledDomain in $DisabledDomains) {
            if (($Candidates | Where-Object {$_.item -eq $DisabledDomain}).selected -ne "True") {
                Write-Host "Successfully disabled lookalike candidate: $($DisabledDomain)" -ForegroundColor Green
            } else {
                Write-Host "Failed to disabled lookalike candidate: $($DisabledDomain)" -ForegroundColor Red
            }
        }
    }
}