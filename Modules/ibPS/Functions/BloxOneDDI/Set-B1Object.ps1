function Set-B1Object {
    <#
    .SYNOPSIS
        Generic Wrapper for interaction with the CSP (Cloud Services Portal) via GET requests

    .DESCRIPTION
        This is a Generic Wrapper for getting objects from the BloxOne CSP (Cloud Services Portal).

    .PARAMETER _ref
        The base URL of the object to update

    .PARAMETER id
        The id of the object to update

    .PARAMETER Data
        The data to update

    .EXAMPLE
        This example will update the comment/description against multiple DNS Records

        $Records = Get-B1Object -Product 'BloxOne DDI' -App DnsConfig -Endpoint /dns/record -Filters @('absolute_zone_name~"mydomain.corp." and type=="a"') -Fields comment
        foreach ($Record in $Records) {
            $Record.comment = "Updated Comment"
        }
        $Records | Set-B1Object

    .EXAMPLE
        This example will update the multiple DHCP Options against multiple Subnets

        $Subnets = Get-B1Object -product 'BloxOne DDI' -App Ipamsvc -Endpoint /ipam/subnet -tfilter '("BuiltWith"=="ibPS")' -Fields name,dhcp_options,tags
        foreach ($Subnet in $Subnets) {
            $Subnet.dhcp_options = @(
                @{
                    "type"="option"
                    "option_code"=(Get-B1DHCPOptionCode -Name "routers").id
                    "option_value"="10.10.100.254"
                }
                @{
                    "type"="option"
                    "option_code"=(Get-B1DHCPOptionCode -Name "domain-name-servers").id
                    "option_value"="10.1.1.100,10.3.1.100"
                }
            )
        }
        $Subnets | Set-B1Object

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Core
    #>
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline = $true)]
        $Data,
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory=$true
          )]
          [String]$_ref,
        [Parameter(
          ValueFromPipelineByPropertyName = $true,
          Mandatory=$true
        )]
        [String]$id
    )

    process {
        $Results = Query-CSP -Method PATCH -Uri "$($_ref)/$($id)" -Data ($Data | Select-Object -ExcludeProperty _ref,id | ConvertTo-Json -Depth 10 -Compress) | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue
        if ($Results) {
            return $Results
        }
    }
}