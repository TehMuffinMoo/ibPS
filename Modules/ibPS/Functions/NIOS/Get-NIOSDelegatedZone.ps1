
function Get-NIOSDelegatedZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [String]$FQDN,
      [Int]$Limit,
      [PSCredential]$Creds
    )
    if ($FQDN) {
        Query-NIOS -Method GET -Server $Server -Uri "zone_delegated?_return_as_object=1&_max_results=$Limit" -Creds $Creds | Select-Object -ExpandProperty results | Where-Object {$_.fqdn -eq $FQDN} -ErrorAction SilentlyContinue
    } else {
        Query-NIOS -Method GET -Server $Server -Uri "zone_delegated?_return_as_object=1&_max_results=$Limit" -Creds $Creds | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}