function Get-B1AsAServiceCapabilities {
    <#
    .SYNOPSIS
        Retrieves a list of NIOS-XaaS Service Capabilities for a particular Service

    .DESCRIPTION
        This function is used query a list of NIOS-XaaS Service Capabilities for a particular Service

    .PARAMETER Service
        The name of the Universal DDI Service to query capabilities for. Either Service or ServiceID is required.

    .PARAMETER ServiceID
        The id of the Universal DDI Service to query capabilities for. Either ServiceID or Service is required.

    .EXAMPLE
        PS> Get-B1AsAServiceCapabilities -Service Production | ft -AutoSize

        type  service_status  profile_id                            profile_name              association_count
        ----  --------------  ----------                            ------------              -----------------
        dns   Available       fdsu98uv-rgg5-5ge4d-g5eg-cgecgcgfdfgf NIOS-XaaS DNS Profile     459
        ntp   Available
        dhcp  Available       sdfdsxfb-rbf5-dxzvdx-dxvd-cxdvdxvvxd4 NIOS-XaaS DHCP Profile    2931

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

    $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/universalinfra/v1/consolidated/getcapabilities" -Data $Data | Select-Object -ExpandProperty universal_service -ErrorAction SilentlyContinue | Select-Object -ExpandProperty capabilities -ErrorAction SilentlyContinue

    if ($Results) {
      return $Results
    } else {
      Write-Host "Error. No NIOS-XaaS Service Capabilities Found." -ForegroundColor Red
    }
}