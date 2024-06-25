function New-NIOSObject {
    <#
    .SYNOPSIS
        Generic Wrapper function for creating new objects from the NIOS WAPI

    .DESCRIPTION
        Generic Wrapper function for creating new objects from the NIOS WAPI, either directly or via BloxOne Federation

    .PARAMETER ObjectType
        Specify the object type to create. This field supports tab completion.

    .PARAMETER Object
        Specify the Infoblox Object template to use when creating the new NIOS object.

    .PARAMETER Fields
        A string array of fields to return in the response. This field supports tab completion.

    .PARAMETER BaseFields
        Using the -BaseFields switch will return the base fields in addition to those selected in -Fields.

    .PARAMETER AllFields
        Using the -AllFields switch will return all available fields in the response.

    .PARAMETER Server
        Specify the NIOS Grid Manager IP or FQDN to use

        This parameter can be ommitted if the Server is stored by using Set-NIOSConnectionProfile

        This is used only when connecting to NIOS directly.

    .PARAMETER GridUID
        Specify the NIOS Grid UID (license_uid). This indicates which Grid to connect to when using NIOS Federation within BloxOne.

    .PARAMETER GridName
        Specify the NIOS Grid Name in BloxOne DDI instead of the GridUID. This is convient, but requires resolving the license_uid on every API Call.

        This parameter can be ommitted if the Federated Grid has been stored by using Set-NIOSConnectionProfile

    .PARAMETER ApiVersion
        The version of the NIOS API to use (WAPI)

        This parameter can be ommitted if the API Version is stored by using Set-NIOSConnectionProfile

    .PARAMETER Creds
        The creds parameter can be used to specify credentials as part of the command.

        This parameter can be ommitted if the Credentials are stored by using Set-NIOSConnectionProfile

        This is used only when connecting to NIOS directly.

    .PARAMETER SkipCertificateCheck
        If this parameter is set, SSL Certificates Checks will be ignored.

        This parameter can be ommitted if the configuration has been stored by using Set-NIOSConnectionProfile

        This is used only when connecting to NIOS directly.

    .EXAMPLE
        PS> @{                                                                                        
            name = 'my.example.com'
            ipv4addr = '172.25.22.12'
            comment = 'My A Record'
        } | New-NIOSObject -ObjectType 'record:a'

        record:a/ZG5zLmJpbmRfYSQuX2RlZmF1bHQuY29tLmV4YW1wbGUsbXksMTcyLjI1LjIyLjEy:my.example.com/default

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Core
    #>
    param(
        [Parameter(Mandatory = $true)]
        [Alias('type')]
        [String]$ObjectType,
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline=$true
        )]
        [PSCustomObject]$Object,
        [Alias('ReturnFields')]
        [String[]]$Fields,
        [Alias('ReturnAllFields')]
        [Switch]$AllFields,
        [Alias('ReturnBaseFields')]
        [Switch]$BaseFields,
        [String]$Server,
        [String]$GridUID,
        [String]$GridName,
        [String]$ApiVersion,
        [Switch]$SkipCertificateCheck,
        [PSCredential]$Creds
    )

    begin {
        ## Initialize Query Filters
        [System.Collections.ArrayList]$QueryFilters = @()
        $InvokeOpts = Initialize-NIOSOpts $PSBoundParameters
    }

    process {
        try {
            $Uri = "$($ObjectType)$($QueryString)"
            $JSON = $Object | ConvertTo-Json -Depth 5
            Invoke-NIOS @InvokeOpts -Uri $Uri -Method POST -Data $JSON
        } catch {
            Write-Error $_
            break
        }
    }
}