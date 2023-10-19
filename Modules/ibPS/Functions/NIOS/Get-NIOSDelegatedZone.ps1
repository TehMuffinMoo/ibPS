function Get-NIOSDelegatedZone {
    <#
    .SYNOPSIS
        Used to retrieve a list of Delegated Zones from NIOS

    .DESCRIPTION
        This function is used to retrieve a list of Delegated Zones from NIOS

    .PARAMETER Server
        The NIOS Grid Master FQDN

    .PARAMETER FQDN
        The FQDN of the subzone to filter by

    .PARAMETER View
        The DNS View within NIOS where the subzone is located

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned. The default number of results is 1000.

    .PARAMETER Creds
        Used when specifying NIOS credentials explicitly, if they have not been pre-defined using Store-NIOSCredentials

    .PARAMETER SkipCertificateCheck
        If this parameter is set, SSL Certificates Checks will be ignored

    .EXAMPLE
        Get-NIOSDelegatedZone -Server gridmaster.domain.corp -View External -FQDN my-dns.zone

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [String]$FQDN,
      [String]$View,
      [Int]$Limit = 1000,
      [PSCredential]$Creds,
      [Switch]$SkipCertificateCheck
    )

    $Filters = @()
    if ($FQDN) {
        $Filters += "fqdn=$FQDN"
    }
    if ($View) {
        $Filters += "view=$View"
    }
    $Filters += "_return_as_object=1"
    $Filters += "_max_results=$Limit"
    if ($Filters) {
        $Filter = Combine-Filters2($Filters)
    }

    if ($Filter) {
        Query-NIOS -Method GET -Server $Server -Uri "zone_delegated$Filter" -Creds $Creds -SkipCertificateCheck:$SkipCertificateCheck | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-NIOS -Method GET -Server $Server -Uri "zone_delegated$Filter" -Creds $Creds -SkipCertificateCheck:$SkipCertificateCheck | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}