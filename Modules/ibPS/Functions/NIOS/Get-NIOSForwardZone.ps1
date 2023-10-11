function Get-NIOSForwardZone {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [String]$FQDN,
      [Int]$Limit,
      $Creds
    )
    if ($FQDN) {
        Query-NIOS -Method GET -Server $Server -Uri "zone_forward?_return_as_object=1&_max_results=$Limit" -Creds $Creds | select -ExpandProperty results | where {$_.fqdn -eq $FQDN} -ErrorAction SilentlyContinue
    } else {
        Query-NIOS -Method GET -Server $Server -Uri "zone_forward?_return_as_object=1&_max_results=$Limit" -Creds $Creds | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}