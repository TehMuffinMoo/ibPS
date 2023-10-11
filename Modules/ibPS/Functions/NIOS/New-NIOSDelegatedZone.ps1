function New-NIOSDelegatedZone {
    <#
    .SYNOPSIS
        Used to create a new delegated zone within NIOS

    .DESCRIPTION
        This function is used to create a new delegated zone within NIOS

    .PARAMETER Server
        The NIOS Grid Master FQDN

    .PARAMETER FQDN
        The FQDN of the delegated zone to create

    .PARAMETER Hosts
        A list of DNS Hosts to delegate this zone to

    .PARAMETER Creds
        Used when specifying NIOS credentials explicitly, if they have not been pre-defined using Store-NIOSCredentials

    .EXAMPLE
        New-NIOSDelegatedZone -Server gridmaster.domain.corp -FQDN my-dns.zone -Hosts "1.2.3.4","2.3.4.5"

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        DNS
    #>
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