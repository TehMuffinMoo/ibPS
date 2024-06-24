function Get-NIOSForwardZone {
    <#
    .SYNOPSIS
        Used to retrieve a list of Forward Zones from NIOS

    .DESCRIPTION
        This function is used to retrieve a list of Forward Zones from NIOS

    .PARAMETER Server
        The NIOS Grid Master FQDN

    .PARAMETER FQDN
        The FQDN of the subzone to filter by

    .PARAMETER View
        The DNS View within NIOS where the subzone is located

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned. The default number of results is 1000.

    .PARAMETER Creds
        Used when specifying NIOS credentials explicitly, if they have not been pre-defined using Set-NIOSCredentials

    .PARAMETER SkipCertificateCheck
        If this parameter is set, SSL Certificates Checks will be ignored

    .EXAMPLE
        Get-NIOSForwardZone -Server gridmaster.domain.corp -View External -FQDN my-dns.zone

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        DNS
    #>
    param(
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
        $Filter = ConvertTo-QueryString($Filters)
    }

    if ($Filter) {
        Invoke-NIOS -Method GET -Server $Server -Uri "zone_forward$Filter" -Creds $Creds -SkipCertificateCheck:$SkipCertificateCheck | Select-Object -ExpandProperty results
    } else {
        Invoke-NIOS -Method GET -Server $Server -Uri "zone_forward$Filter" -Creds $Creds -SkipCertificateCheck:$SkipCertificateCheck | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}