function Remove-B1Service {
    <#
    .SYNOPSIS
        Removes an existing BloxOneDDI Service

    .DESCRIPTION
        This function is used to remove an existing BloxOneDDI Service

    .PARAMETER Name
        The name of the BloxOneDDI Service to remove

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Remove-B1Service -Name "dns_bloxoneddihost1.mydomain.corp" -Strict
    
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
        Write-Host "Removing $($B1Service.name).." -ForegroundColor Cyan
        $ServiceId = $($B1Service.id).replace("infra/service/","") ## ID returned from API doesn't match endpoint? /infra/service not /infra/v1/services
        $Results = Query-CSP -Method DELETE -Uri "https://csp.infoblox.com/api/infra/v1/services/$ServiceId"
        if (Get-B1Service -Name $Name -Strict:$Strict) {
          Write-Host "Failed to delete service" -ForegroundColor Red
        } else {
          Write-Host "Service deleted successfully." -ForegroundColor Green
        }
    }
}