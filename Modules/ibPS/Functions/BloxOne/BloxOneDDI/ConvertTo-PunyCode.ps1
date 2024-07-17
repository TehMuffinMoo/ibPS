function ConvertTo-PunyCode {
    <#
    .SYNOPSIS
        Uses the BloxOne API to convert a domain name to Punycode

    .DESCRIPTION
        This function uses the BloxOne API to convert a domain name to Punycode

    .PARAMETER FQDN
        The fully qualified domain name to convert to Punycode

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        This example shows a domain where the 'c' is using a cyrillic character set, which looks identical to a normal 'c'.

        When converting to PunyCode, this becomes obvious.

        PS> ConvertTo-PunyCode -FQDN "bbс.co.uk"

        idn       punycode
        ---       --------
        bbс.co.uk xn--bb-pmc.co.uk

    .EXAMPLE
        This example shows the same query as Example #1, but with a standard character set.

        PS> ConvertTo-PunyCode -FQDN "bbc.co.uk"

        idn       punycode
        ---       --------
        bbc.co.uk bbc.co.uk

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Logs
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(
      [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
      [string[]]$FQDN,
      [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        $Results = @()
        foreach ($iFQDN in $FQDN) {
            if($PSCmdlet.ShouldProcess("Convert $($iFQDN) to PunyCode","Convert $($iFQDN) to PunyCode",$MyInvocation.MyCommand)){
                $Results += Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/convert_domain_name/$($iFQDN)" -Method GET | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue
                $ShouldProcess = $true
            }
        }

        if ($ShouldProcess) {
            if ($Results) {
                return $Results
            } else {
                Write-Host "Error. Unable to convert domain name." -ForegroundColor Red
                break
            }
        }
    }
}