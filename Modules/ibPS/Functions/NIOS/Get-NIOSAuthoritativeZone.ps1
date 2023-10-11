function Get-NIOSAuthoritativeZone {
    <#
    .SYNOPSIS
        Used to retrieve a list of Authoritative Zones from NIOS

    .DESCRIPTION
        This function is used to retrieve a list of Authoritative Zones from NIOS

    .PARAMETER Server
        The NIOS Grid Master FQDN

    .PARAMETER FQDN
        The FQDN of the subzone to filter by

    .PARAMETER View
        The DNS View within NIOS where the subzone is located

    .PARAMETER B1View
        The DNS View within BloxOne where the subzone is to be migrated to

    .PARAMETER Confirm
        Set this parameter to false to ignore confirmation prompts

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned. The default number of results is 1000.

    .PARAMETER Creds
        Used when specifying NIOS credentials explicitly, if they have not been pre-defined using Store-NIOSCredentials

    .EXAMPLE
        Get-NIOSAuthoritativeZone 

    .EXAMPLE
        Migrate-NIOSSubzoneToBloxOne -Server gridmaster.domain.corp -Subzone my-dns.zone -NIOSView External -B1View my-b1dnsview -CreateZones -AuthNSGs "Core DNS Group"

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Migration
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [String]$FQDN,
      [String]$View,
      [Int]$Limit = 1000,
      [PSCredential]$Creds
    )
    if ($FQDN) {
        Query-NIOS -Method GET -Server $Server -Uri "zone_auth?view=$View&fqdn=$FQDN&_return_as_object=1&_max_results=$Limit" -Creds $Creds | Select-Object -ExpandProperty results
    } else {
        Query-NIOS -Method GET -Server $Server -Uri "zone_auth?view=$View&_return_as_object=1&_max_results=$Limit" -Creds $Creds | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}