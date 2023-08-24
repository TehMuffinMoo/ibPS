function Remove-B1Host {
    <#
    .SYNOPSIS
        Removes an existing BloxOneDDI Host

    .DESCRIPTION
        This function is used to remove an existing BloxOneDDI Host

    .PARAMETER Name
        The name of the BloxOneDDI host to remove

    .Example
        Remove-B1Host -Name "bloxoneddihost1.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        Host
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name
    )
    $hostID = (Get-B1Host -Name $Name -Strict -Detailed).id
    if ($hostID) {
        Query-CSP -Method DELETE -Uri "https://csp.infoblox.com/api/infra/v1/hosts/$hostID"
        $hostID = (Get-B1Host -Name $Name -Strict -Detailed).id
        if ($hostID) {
            Write-Host "Error. Failed to delete BloxOneDDI Host $Name" -ForegroundColor Red
        } else {
            Write-Host "Successfully deleted BloxOneDDI Host $Name" -ForegroundColor Green
        }
    } else {
        Write-Host "Error. Unable to find Host ID from name: $Name" -ForegroundColor Red
    }
}