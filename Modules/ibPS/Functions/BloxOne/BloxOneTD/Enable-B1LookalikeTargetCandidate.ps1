function Enable-B1LookalikeTargetCandidate {
    <#
    .SYNOPSIS
        Enables a lookalike from the Common Watched Domains list

    .DESCRIPTION
        This function is used to enable a lookalike from the Common Watched Domains list

    .PARAMETER Domain
        One or more common watched domain to enable.

        This parameter auto-completes based on the current list of disabled domains

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Enable-B1LookalikeTargetCandidate -Domain "adobe.com","airbnb.com"

        Successfully enabled lookalike candidate: adobe.com
        Successfully enabled lookalike candidate: airbnb.com

    .EXAMPLE
        PS> Enable-B1LookalikeTargetCandidate -Domain <TabComplete>

        alibaba.com                  flickr.com                   navyfederal.org              secureserver.net
        americanexpressbusiness.com  fortisbc.com                 nytimes.com                  sedoparking.com
        arrow.com                    foxnews.com                  odnoklassniki.ru             squarespace.com
        ...

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [String[]]$Domain,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters

    $JSONData = @{
        "select" = $Domain
        "unselect" = @()
    } | ConvertTo-Json

    if($PSCmdlet.ShouldProcess("Enable Lookalike Target Candidate(s): $($Domain -join ', ')","Enable Lookalike Target Candidate(s): $($Domain -join ', ')",$MyInvocation.MyCommand)){
        $null = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/lookalike_target_candidates" -Data $($JSONData) -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        $Candidates = Get-B1LookalikeTargetCandidates | Select-Object -ExpandProperty items_described
        foreach ($EnabledDomain in $Domain) {
            if (($Candidates | Where-Object {$_.item -eq $EnabledDomain}).selected -eq "True") {
                Write-Host "Successfully enabled lookalike candidate: $($EnabledDomain)" -ForegroundColor Green
            } else {
                Write-Host "Failed to enabled lookalike candidate: $($EnabledDomain)" -ForegroundColor Red
            }
        }
    }
}