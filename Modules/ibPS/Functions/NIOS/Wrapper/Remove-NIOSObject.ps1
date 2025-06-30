function Remove-NIOSObject {
    <#
    .SYNOPSIS
        Generic Wrapper function for removing objects from the NIOS WAPI

    .DESCRIPTION
        Generic Wrapper function for removing objects from the NIOS WAPI, either directly or via Universal DDI Federation

    .PARAMETER ObjectRef
        Specify the object _ref to remove.

    .PARAMETER Server
        Specify the NIOS Grid Manager IP or FQDN to use

        This parameter can be ommitted if the Server is stored by using Set-NIOSConnectionProfile

        This is used only when connecting to NIOS directly.

    .PARAMETER GridUID
        Specify the NIOS Grid UID (license_uid). This indicates which Grid to connect to when using NIOS Federation within Universal DDI.

    .PARAMETER GridName
        Specify the NIOS Grid Name in Universal DDI DDI instead of the GridUID. This is convient, but requires resolving the license_uid on every API Call.

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

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

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
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName=$true
        )]
        [Alias('ref','_ref')]
        [String]$ObjectRef,
        [String]$Server,
        [String]$GridUID,
        [String]$GridName,
        [String]$ApiVersion,
        [Switch]$SkipCertificateCheck,
        [PSCredential]$Creds,
        [Switch]$Force
    )

    begin {
        ## Initialize Query Filters
        $InvokeOpts = Initialize-NIOSOpts $PSBoundParameters
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    }

    process {
        try {
            if ($PSCmdlet.ShouldProcess("$($ObjectRef)")){
                Invoke-NIOS @InvokeOpts -Uri $ObjectRef -Method DELETE
            }
        } catch {
            Write-Error $_
            break
        }
    }
}