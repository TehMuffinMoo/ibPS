function Get-B1AsAServiceCapabilities {
    <#
    .SYNOPSIS
        Retrieves a list of NIOS-XaaS Service Capabilities for a particular Service

    .DESCRIPTION
        This function is used query a list of NIOS-XaaS Service Capabilities for a particular Service

    .EXAMPLE
        PS> Get-B1AsAServiceCapabilities -Service Production | ft -AutoSize

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Service
    #>
    [Alias('Get-B1AASCapabilities')]
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$true, ParameterSetName = 'ByService')]
      [String]$Service,
      [Parameter(Mandatory=$true, ParameterSetName = 'ByServiceID')]
      [String]$ServiceID
    )

    if (!$ServiceID) {
        $ServiceID = Get-B1AsAServiceServices | Where-Object {$_.name -eq $Service} | Select-Object -ExpandProperty id
    }

    $Data = @{
        "perspective" = "configuration/location"
        "universal_service_id" = $ServiceID
    } | ConvertTo-Json

    $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/universalinfra/v1/consolidated/getcapabilities" -Data $Data | Select-Object -ExpandProperty universal_service -ErrorAction SilentlyContinue

    if ($Results) {
      return $Results
    } else {
      Write-Host "Error. No NIOS-XaaS Service Capabilities Found." -ForegroundColor Red
    }
}