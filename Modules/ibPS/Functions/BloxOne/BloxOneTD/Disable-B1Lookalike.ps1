function Disable-B1Lookalike {
    <#
    .SYNOPSIS
        Mutes a lookalike domain

    .DESCRIPTION
        This function is used to mute a lookalike domain

    .PARAMETER LookalikeDomain
        One or more identified lookalikes to mute

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Disable-B1Lookalike -LookalikeDomain "google98.pro","return-tax-hmrc.com"

        Successfully muted lookalike: google98.pro
        Successfully muted lookalike: return-tax-hmrc.com

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Threat Defense

    .NOTES
        Used in combination with Enable-B1Lookalike to mute/unmute lookalike domains.
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

    if ($LookalikeDomain) {
        $JSONData = @{
            "hide" = $LookalikeDomain
        } | ConvertTo-Json
        if($PSCmdlet.ShouldProcess("Disable Lookalike Domain(s): $($LookalikeDomain -join ', ')","Disable Lookalike Domain(s): $($LookalikeDomain -join ', ')",$MyInvocation.MyCommand)){
            $null = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/atclad/v1/lookalikes" -Data $($JSONData) -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

            foreach ($MutedDomain in $LookalikeDomain) {
                if (Get-B1Lookalikes -LookalikeDomain $($MutedDomain) -Muted true) {
                    Write-Host "Successfully muted lookalike domain: $($MutedDomain)" -ForegroundColor Green
                } else {
                    Write-Host "Failed to mute lookalike domain: $($MutedDomain)" -ForegroundColor Red
                }
            }
        }
    }
}