function ConvertTo-PunyCode {
    <#
    .SYNOPSIS
        Uses the BloxOne API to convert a domain name to Punycode

    .DESCRIPTION
        This function uses the BloxOne API to convert a domain name to Punycode

    .PARAMETER FQDN
        The fully qualified domain name to convert to Punycode

    .EXAMPLE
        PS> ConvertTo-PunyCode -FQDN "bbс.co.uk"

        idn       punycode
        ---       --------
        bbс.co.uk xn--bb-pmc.co.uk
    
    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Logs
    #>
    param(
      [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
      [string[]]$FQDN
    )

    process {
        $Results = @()
        foreach ($iFQDN in $FQDN) {
            
            $Results += Query-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/convert_domain_name/$($iFQDN)" -Method GET | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue
        }

        if ($Results) {
            return $Results
        } else {
            Write-Host "Error. Unable to convert domain name." -ForegroundColor Red
            break
        }
    }
}