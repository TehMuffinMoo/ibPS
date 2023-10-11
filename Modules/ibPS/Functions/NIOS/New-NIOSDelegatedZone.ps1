function New-NIOSDelegatedZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [Parameter(Mandatory=$true)]
      [System.Object]$Hosts,
      [Parameter(Mandatory=$true)]
      [String]$FQDN,
      [PSCredential]$Creds
    )
    if (Get-NIOSDelegatedZone -Server $Server -Creds $Creds -FQDN $FQDN) {
        Write-Host "Error. Delegated zone already exists." -ForegroundColor Red
    } else {
        Write-Host "Creating delegated DNS Zone $FQDN.." -ForegroundColor Cyan

        $splat = @{
            "fqdn" = $FQDN
            "delegate_to" = $Hosts
        }
        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        try {
            $Result = Query-NIOS -Method POST -Server $Server -Uri "zone_delegated?_return_as_object=1" -Creds $Creds -Data $splat
            $Successful = $true
            if ($Debug) {$Result}
        } catch {
            Write-Host "Failed to create NIOS DNS Zone Delegation." -ForegroundColor Red
            $Successful = $false
        } finally {
            if ($Successful) {
                Write-Host "NIOS DNS Zone Delegation created successfully for $FQDN." -ForegroundColor Green
            }
        }
    }
}