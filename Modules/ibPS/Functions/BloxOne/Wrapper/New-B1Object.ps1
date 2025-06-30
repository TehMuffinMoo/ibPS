function New-B1Object {
    <#
    .SYNOPSIS
        Generic Wrapper for creating new objects within the CSP (Cloud Services Portal)

    .DESCRIPTION
        This is a Generic Wrapper for creating new objects within the CSP (Cloud Services Portal).

    .PARAMETER Product
        Specify the product to use, such as 'BloxOne DDI'.
        This parameter is auto-populated when using tab

    .PARAMETER App
        Specify the App to use, such as 'DnsConfig'
        This parameter is auto-populated when using tab

    .PARAMETER Endpoint
        Specify the API Endpoint to use, such as "/ipam/record".
        This parameter is auto-populated when using tab

    .PARAMETER Data
        The data to submit

    .PARAMETER JSON
        Use this switch if the -Data parameter contains JSON data instead of a PSObject

    .PARAMETER Method
        The method to use when creating new object. Defaults to POST

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        ##This example will create a new DNS Record

        PS> $Splat = @{
                "name_in_zone" = "MyNewRecord"
                "zone" = "dns/auth_zone/12345678-8989-4833-abcd-12345678" ### The DNS Zone ID
                "type" = "A"
                "rdata" = @{
                    "address" = "10.10.10.10"
                }
            }
        PS> New-B1Object -Product 'BloxOne DDI' -App DnsData -Endpoint /dns/record -Data $Splat

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
        [Parameter(Mandatory=$true)]
        [String]$Product,
        [Parameter(Mandatory=$true)]
        [String]$App,
        [Parameter(Mandatory=$true)]
        [String]$Endpoint,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [psobject]$Data,
        [Switch]$JSON,
        [ValidateSet("POST","PUT")]
        $Method = "POST",
        [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        $B1CSPUrl = Get-B1CSPUrl
        $BasePath = Get-B1Schema -Product $Product -App $App -Quiet -GetBasePath

        $Uri = "$($B1CSPUrl)$($BasePath)$($Endpoint)$($QueryString)" -replace "\*","``*"
        if (!($JSON)) {
            $Data = $Data | ConvertTo-Json -Depth 15 -Compress
        } else {
            $Data = $JSON
        }
        if($PSCmdlet.ShouldProcess("Create new Object:`n$(JSONPretty($Data))","Create new Object: $($Endpoint)",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method $Method -Uri $Uri -Data $Data
            if ($Results) {
                return $Results
            }
        }
    }
}