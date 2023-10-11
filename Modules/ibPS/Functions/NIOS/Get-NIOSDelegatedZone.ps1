
function Get-NIOSDelegatedZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [String]$FQDN,
      $Creds
    )
    if ($FQDN) {
        Query-NIOS -Method GET -Server $Server -Uri "zone_delegated?_return_as_object=1" -Creds $Creds | select -ExpandProperty results | where {$_.fqdn -eq $FQDN} -ErrorAction SilentlyContinue
    } else {
        Query-NIOS -Method GET -Server $Server -Uri "zone_delegated?_return_as_object=1" -Creds $Creds | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}