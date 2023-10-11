function Get-NIOSAuthoritativeZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [String]$FQDN,
      [String]$View,
      [Int]$Limit = 1000,
      $Creds
    )
    if ($FQDN) {
        Query-NIOS -Method GET -Server $Server -Uri "zone_auth?view=$View&_return_as_object=1&_max_results=$Limit" -Creds $Creds | select -ExpandProperty results | where {$_.fqdn -eq $FQDN} -ErrorAction SilentlyContinue
    } else {
        Query-NIOS -Method GET -Server $Server -Uri "zone_auth?view=$View&_return_as_object=1&_max_results=$Limit" -Creds $Creds | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}