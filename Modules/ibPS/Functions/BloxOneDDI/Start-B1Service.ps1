function Start-B1Service {
    <#
    .SYNOPSIS
        Starts a BloxOneDDI Service

    .DESCRIPTION
        This function is used to start a BloxOneDDI Service

    .PARAMETER Name
        The name of the BloxOneDDI Service to start

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Start-B1Service -Name "dns_bloxoneddihost1.mydomain.corp" -Strict
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Service
    #>
    param(
        [Parameter(Mandatory=$false)]
        [String]$Name,
        [Parameter(Mandatory=$false)]
        [Switch]$Strict = $false
    )
    $MatchType = Match-Type $Strict
    $B1Service = Get-B1Service -Name $Name -Strict:$Strict
    if ($B1Service.count -gt 1) {
        Write-Host "More than one service returned. Check the name and use -Strict if required." -ForegroundColor Red
        $B1Service | ft name,service_type,@{label='host_id';e={$_.configs.host_id}} -AutoSize
    } elseif ($B1Service) {
        Write-Host "Starting $($B1Service.name).." -ForegroundColor Cyan
        $B1Service.desired_state = "start"
        $splat = $B1Service | ConvertTo-Json -Depth 3 -Compress
        $ServiceId = $($B1Service.id).replace("infra/service/","") ## ID returned from API doesn't match endpoint? /infra/service not /infra/v1/services
        $Results = Query-CSP -Method PUT -Uri "https://csp.infoblox.com/api/infra/v1/services/$ServiceId" -Data $splat
        if ($Results.result.desired_state -eq "start") {
          Write-Host "Service started successfully" -ForegroundColor Green
        } else {
          Write-Host "Failed to start service." -ForegroundColor Red
        }
    }
}