function Get-B1AsAServiceServiceStatus {
    <#
    .SYNOPSIS
        Retrieves the connection status of NIOS-X As A Service connections

    .DESCRIPTION
        This function is used query the connection status of NIOS-X As A Service connections

    .PARAMETER Service
        The name of the Universal DDI Service to query the service status for. Either Service or ServiceID is required.

    .PARAMETER ServiceID
        The id of the Universal DDI Service to query the service status for. Either ServiceID or Service is required.

    .PARAMETER Location
        The name of the Access Location to filter the the service status by. This parameter is optional.

    .EXAMPLE
        PS> Get-B1AsAServiceServiceStatus -Service Production | ft -AutoSize

        universal_service_id             service_location          endpoint_id                       access_location_id               access_location_name access_location_country status    identity                    wan_ip_addresses  lan_subnets
        --------------------             ----------------          -----------                       ------------------               -------------------- ----------------------- ------    --------                    ----------------  -----------
        4t4t44tsfsdfdsfdfsdsfdisemg3vfr4 AWS Europe (London)       q7xmxm5qhmavsq3v6eetwfkvlvg5uqk5  ay7ng7ggcisiolqya4iafozsisemg3vf Head-Office          United Kingdom          Connected dfsgfsrt443f.infoblox.com   {88.88.88.88}     {10.12.0.0/16}
        ej7vgf7hlwxmyubjitxdatpnidk3a32r AWS US East (N. Virginia) dffsf43trgd8j489tjg89e4hrgregdfs  xzf4k74qfdsf4fsegf4tgr4etgedsg45 US-Office            United Kingdom          Connected fdsfsdfg54gf.infoblox.com   {66.66.66.66}     {10.13.0.0/16}

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Service
    #>
    [Alias('Get-B1AASServiceStatus')]
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
        $LocationID = Get-B1AsAServiceConnectionStatus -ServiceID $ServiceID | Where-Object {$_.access_location_name -eq $Location} | Select-Object -ExpandProperty access_location_id
        $Data["access_location_id"] = $LocationID
    }

    $JSONData = $Data | ConvertTo-Json

    $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/universalinfra/v1/consolidated/listconnectionstatus" -Data $JSONData | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue

    if ($Results) {
      return $Results
    } else {
      Write-Host "Error. No NIOS-XaaS Connections Found." -ForegroundColor Red
    }
}