function Get-B1AsAServiceConfigChanges {
    <#
    .SYNOPSIS
        Retrieves a list of configuration changes for NIOS-X As A Service

    .DESCRIPTION
        This function is used query a list of configuration changes for NIOS-X As A Service, optionally filtering by service or location.

    .PARAMETER Service
        The name of the Universal DDI Service to query configuration changes for. Either Service or ServiceID is required.

    .PARAMETER ServiceID
        The id of the Universal DDI Service to query configuration changes for. Either ServiceID or Service is required.

    .PARAMETER Location
        The name of the Access Location to filter the configuration changes by. This parameter is optional.

    .EXAMPLE
        PS> Get-B1AASConfigChanges -Service NIOS-XaaS | ft -AutoSize

        id        resource_id                      change_message                          created_at           user_name                      request_id
        --        -----------                      --------------                          ----------           ---------                      ----------
        864953773 4t4t44tsfsdfdsfdfsdsfdisemg3vfr4 Updated Access Location VMo2-Swansea-DC 6/25/2025 6:37:22 PM example.user@domain.com        494ddfdsfsfsdfgt5heeeccd7fd4a616
        864953771 dvfdg45ythzxer5hs5h5ygavr4vfagr5 Updated Endpoint NIOS-XaaS-Swansea      6/25/2025 6:37:22 PM example.user@domain.com        494ddfdsfsfsdfgt5heeeccd7fd4a616
        864953769 dfsdsemniu9frhn4e9ufn9w48th4fgws Updated Universal Service               6/25/2025 6:37:22 PM example.user@domain.com        494ddfdsfsfsdfgt5heeeccd7fd4a616
        864951938 4t4t44tsfsdfdsfdfsdsfdisemg3vfr4 Updated Access Location VMo2-Swansea-DC 6/25/2025 6:36:34 PM example.user@domain.com        7fdr9fdsdffr4gf4g5ey5hy219c939f8

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Service
    #>
    [Alias('Get-B1AASConfigChanges')]
    [CmdletBinding()]
    param(
      [String]$Service,
      [String]$Location
    )

    $Data = @{}

    if ($Service) {
        $ServiceID = Get-B1AsAServiceServices | Where-Object {$_.name -eq $Service} | Select-Object -ExpandProperty id
        $Data["universal_service_id"] = $ServiceID
    }

    if ($Location) {
        if (!$Service) {
            Write-Host "Service parameter is required when specifying a location." -ForegroundColor Red
            return
        }
        $LocationID = Get-B1AsAServiceServiceStatus -Service $Service | Where-Object {$_.access_location_name -eq $Location} | Select-Object -ExpandProperty access_location_id
        $Data["access_location_id"] = $LocationID
    }

    $JSONData = $Data | ConvertTo-Json

    $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/universalinfra/v1/consolidated/getconfigchanges" -Data $JSONData | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue

    if ($Results) {
      return $Results
    } else {
      Write-Host "Error. No NIOS-XaaS Config Changes Found." -ForegroundColor Red
    }
}