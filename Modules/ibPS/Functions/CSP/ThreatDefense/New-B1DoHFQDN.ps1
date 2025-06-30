function New-B1DoHFQDN {
    <#
    .SYNOPSIS
        Generates a new DoH FQDN

    .DESCRIPTION
        This function is used to generate a new DNS over HTTPS FQDN for use in Infoblox Threat Defense security policies

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1DoHFQDN

        policy_id doh_fqdn
        --------- --------
                0 dfsdgghhdh-btrb-4bbb-bffb-cmjumbfgfnhm9.doh.threatdefense.infoblox.com


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
        [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    if($PSCmdlet.ShouldProcess("Generate new DNS over HTTPS FQDN","Generate new DNS over HTTPS FQDN",$MyInvocation.MyCommand)){
        $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/doh_fqdns" | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
        if ($Result) {
            return $Result
        } else {
            Write-Error "Failed to generate a new DNS over HTTPS FQDN."
        }
    }
}