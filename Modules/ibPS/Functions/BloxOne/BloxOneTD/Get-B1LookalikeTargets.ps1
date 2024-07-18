function Get-B1LookalikeTargets {
    <#
    .SYNOPSIS
        Queries a list of lookalike target domains for the account

    .DESCRIPTION
        This function is used to query a list of lookalike target domains for the account
        The Lookalike Target Domains are second-level domains BloxOne uses to detect lookalike FQDNs against, i.e the list of defined lookalike domains to monitor.

    .EXAMPLE
        PS> Get-B1LookalikeTargets

        description     : Auto-generated
        item_count      : 219
        items           : {google.com, facebook.com, bbc.co.uk, infoblox.com…}
        items_described : {@{description=description for google.com; item=google.com; target_domain_status=accepted; valid=True}, @{description=a description for facebook ; item=facebook.com; target_domain_status=accepted; valid=True}, @{description=Another
                        description but for bbc; item=bbc.co.uk; target_domain_status=accepted; valid=True}, @{description=Our domain; item=infoblox.com; target_domain_status=accepted; valid=True}…}
        name            : Global Lookalike Target List

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    [CmdletBinding()]
    param(
    )

    $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_targets" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue

    if ($Results) {
      return $Results
    }
}