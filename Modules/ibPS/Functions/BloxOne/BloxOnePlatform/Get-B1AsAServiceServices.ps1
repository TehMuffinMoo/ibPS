function Get-B1AsAServiceServices {
    <#
    .SYNOPSIS
        Retrieves a list of NIOS-X As A Service services

    .DESCRIPTION
        This function is used query a list of NIOS-X As A Service services

    .EXAMPLE
        PS> Get-B1AsAServiceServices

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Service
    #>
    [Alias('Get-B1AASServices')]
    [CmdletBinding()]
    param()

    $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/universalinfra/v1/consolidated/getcatalog" -Data '{}' | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue

    if ($Results) {
      return $Results
    } else {
      Write-Host "Error. No NIOS-XaaS Services Found." -ForegroundColor Red
    }
}