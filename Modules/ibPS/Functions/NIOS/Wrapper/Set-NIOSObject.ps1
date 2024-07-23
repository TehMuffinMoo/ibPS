function Set-NIOSObject {
    <#
    .SYNOPSIS
        Generic Wrapper function for updating objects using the NIOS WAPI

    .DESCRIPTION
        Generic Wrapper function for updating objects using the NIOS WAPI, either directly or via BloxOne Federation

    .PARAMETER Object
        Specify the Infoblox Object to update. Accepts pipeline input.

    .PARAMETER ObjectRef
        Specify the object _ref to update.

    .PARAMETER TemplateObject
        Specify the Infoblox Object template to use when updating the NIOS object(s).

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

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

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
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(
            Mandatory=$true,
            ParameterSetName='Object',
            ValueFromPipeline=$true
        )]
        [PSCustomObject]$Object,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ref',
            ValueFromPipelineByPropertyName=$true
        )]
        [Alias('ref','_ref')]
        [String]$ObjectRef,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ref',
            ValueFromPipelineByPropertyName=$true
        )]
        [PSCustomObject]$TemplateObject,
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
        [PSCredential]$Creds,
        [Switch]$Force
    )

    begin {
        ## Initialize Query Filters
        [System.Collections.ArrayList]$QueryFilters = @()
        $InvokeOpts = Initialize-NIOSOpts $PSBoundParameters
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    }

    process {
        Switch($PSCmdlet.ParameterSetName) {
            'Object' {
                if (!($Object._ref)) {
                    Write-Error "Input object is missing the '_ref' field."
                    return $null
                }
                $ObjectRef = $Object._ref
            }
            'Ref' {
                $Object = $TemplateObject
            }
        }

        $ObjectType = $ObjectRef.split('/')[0]

        ## Build Return Fields
        if (!$AllFields -and $Fields) {
            if ($BaseFields) {
                $QueryFilters.Add("_return_fields%2B=$($Fields -join ',')") | Out-Null
            } else {
                $QueryFilters.Add("_return_fields=$($Fields -join ',')") | Out-Null
            }
        } elseif ($AllFields) {
            $QueryFilters.Add("_return_fields=$((Get-NIOSSchema @InvokeOpts -ObjectType $ObjectType -Fields -Method GET).name -join ',')") | Out-Null
        }

        if ($QueryFilters) {
            $QueryString = ConvertTo-QueryString $QueryFilters
        }

        $Uri = "$($ObjectRef)$($QueryString)"

        ## Strip non-writable fields
        $PUTFields = (Get-NIOSSchema @InvokeOpts -ObjectType $ObjectType -Fields -Method PUT).name
        $FieldsToRemove = $Object.PSObject.Properties.Name | Where-Object {$_ -notin $PUTFields}
        $FieldsToRemove | ForEach-Object {
            $Object.PSObject.Properties.Remove($_)
        }

        $JSON = $Object | ConvertTo-Json -Depth 5

        try {
            if($PSCmdlet.ShouldProcess("Update NIOS Object:`n$(JSONPretty($JSON))","Update NIOS Object: ($($Uri))",$MyInvocation.MyCommand)){
                Invoke-NIOS @InvokeOpts -Uri $Uri -Method PUT -Data $JSON
            }
        } catch {
            Write-Error $_
            break
        }
    }
}