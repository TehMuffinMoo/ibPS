function Get-B1AsAServiceDeployments {
    <#
    .SYNOPSIS
        Retrieves a list of NIOS-XaaS Service Deployments for a particular Service

    .DESCRIPTION
        This function is used query a list of NIOS-XaaS Service Deployments for a particular Service

    .PARAMETER Service
        The name of the Universal DDI Service to query deployments for. Either Service or ServiceID is required.

    .PARAMETER ServiceID
        The id of the Universal DDI Service to query deployments for. Either ServiceID or Service is required.

    .PARAMETER Location
        The name of the Access Location to filter the deployments by. This parameter is optional.

    .EXAMPLE
        PS> Get-B1AsAServiceDeployments -Service Production | ft -AutoSize

        id                               name           service_location          service_ip     cnames                          access_location_count size  neighbour_ips                    preferred_provider routing_type
        --                               ----           ----------------          ----------     ------                          --------------------- ----  -------------                    ------------------ ------------
        g3oox35c6wgsjuk2dl76zmofqzzgobsf Production-US  AWS US East (N. Virginia) 192.168.200.10 {66.77.88.99, 55.66.77.88}      1                     Small {192.168.200.11, 192.168.200.12} Any                static
        jca2xysvhkhhaef6gqlchg335zaqmrsr Production-GB  AWS Europe (London)       192.168.100.10 {22.33.44.55, 33.44.55.66}      1                     Small {192.168.100.11, 192.168.100.12} AWS                static

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Service
    #>
    [Alias('Get-B1AASDeployments')]
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$true, ParameterSetName = 'ByService')]
      [String]$Service,
      [Parameter(Mandatory=$true, ParameterSetName = 'ByServiceID')]
      [String]$ServiceID,
      [String]$Location
    )

    if (!$ServiceID) {
        $ServiceID = Get-B1AsAServiceServices | Where-Object {$_.name -eq $Service} | Select-Object -ExpandProperty id
    }

    $Data = @{
        "perspective" = "configuration/location"
        "universal_service_id" = $ServiceID
    }

    if ($Location) {
        if (!$ServiceID) {
            Write-Host "Service parameter is required when specifying a location." -ForegroundColor Red
            return
        }
        $LocationID = Get-B1AsAServiceServiceStatus -ServiceID $ServiceID | Where-Object {$_.access_location_name -eq $Location} | Select-Object -ExpandProperty access_location_id
        $Data["access_location_id"] = $LocationID
    }

    $JSONData = $Data | ConvertTo-Json

    $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/universalinfra/v1/consolidated/listconnectionpoints" -Data $JSONData | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue

    if ($Results) {
      return $Results
    } else {
      Write-Host "Error. No NIOS-XaaS Deployments Found." -ForegroundColor Red
    }
}