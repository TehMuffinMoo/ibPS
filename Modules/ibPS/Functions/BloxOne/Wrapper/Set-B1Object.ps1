function Set-B1Object {
    <#
    .SYNOPSIS
        Generic Wrapper for updating existing objects within the CSP (Cloud Services Portal)

    .DESCRIPTION
        This is a Generic Wrapper for updating objects within the CSP (Cloud Services Portal). It is recommended this is used via Pipeline

    .PARAMETER _ref
        The base URL of the object to update

    .PARAMETER id
        The id of the object to update

    .PARAMETER Data
        The data to update

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        ## This example will update the comment/description against multiple DNS Records

        PS> $Records = Get-B1Object -Product 'BloxOne DDI' -App DnsConfig -Endpoint /dns/record -Filters @('absolute_zone_name~"mydomain.corp." and type=="a"') -Fields comment
        PS> foreach ($Record in $Records) {
                $Record.comment = "Updated Comment"
            }
        PS> $Records | Set-B1Object

    .EXAMPLE
        ## This example will update the multiple DHCP Options against multiple Subnets

        PS> $Subnets = Get-B1Object -product 'BloxOne DDI' -App Ipamsvc -Endpoint /ipam/subnet -tfilter '("BuiltWith"=="ibPS")' -Fields name,dhcp_options,tags
        PS> foreach ($Subnet in $Subnets) {
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
        PS> $Subnets | Set-B1Object

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Core
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $Data,
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [String]$_ref,
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $true
        )]
        [String]$id,
        [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        $JSON = ($Data | ConvertTo-Json -Depth 10 -Compress)
        if($PSCmdlet.ShouldProcess("Update Object:`n$(JSONPretty($JSON))","Update Object: ($($id))",$MyInvocation.MyCommand)){
            $Data.PSObject.Properties.Remove('_ref')
            $Data.PSObject.Properties.Remove('id')
            $Results = Invoke-CSP -Method PATCH -Uri "$($_ref)/$($id)" -Data $JSON | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue
            if ($Results) {
                return $Results
            }
        }
    }
}