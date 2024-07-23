function Enable-B1Lookalike {
    <#
    .SYNOPSIS
        Unmutes a lookalike domain

    .DESCRIPTION
        This function is used to unmute a lookalike domain

    .PARAMETER LookalikeDomain
        One or more identified lookalikes to unmute

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Enable-B1Lookalike -LookalikeDomain "google98.pro","return-tax-hmrc.com"

        Successfully unmuted lookalike: google98.pro
        Successfully unmuted lookalike: return-tax-hmrc.com

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Threat Defense

    .NOTES
        Used in combination with Disable-B1Lookalike to mute/unmute lookalike domains.
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [String[]]$LookalikeDomain,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $JSONData = @{
        "expose" = $LookalikeDomain
    } | ConvertTo-Json

    if($PSCmdlet.ShouldProcess("Enable Lookalike Domain(s): $($LookalikeDomain -join ', ')","Enable Lookalike Domain(s): $($LookalikeDomain -join ', ')",$MyInvocation.MyCommand)){
        $null = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/atclad/v1/lookalikes" -Data $($JSONData) -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

        foreach ($UnmutedDomain in $LookalikeDomain) {
            if (Get-B1Lookalikes -LookalikeDomain $($UnmutedDomain) -Muted false) {
                Write-Host "Successfully unmuted lookalike domain: $($UnmutedDomain)" -ForegroundColor Green
            } else {
                Write-Host "Failed to unmute lookalike domain: $($UnmutedDomain)" -ForegroundColor Red
            }
        }
    }
}