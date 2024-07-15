function Get-NIOSSchema {
    <#
    .SYNOPSIS
        Generic Wrapper function for retrieving schema information from the NIOS WAPI

    .DESCRIPTION
        Generic Wrapper function for retrieving schema information from the NIOS WAPI, either directly or via BloxOne Federation

    .PARAMETER ObjectType
        Specify the object type to retrieve schema information for. This field supports tab completion.

    .PARAMETER Fields
        A string array of fields to return in the response. This field supports tab completion.

    .PARAMETER Method
        If -Method is specified, only fields which support the selected method will be returned.

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
        PS> Get-NIOSSchema

        requested_version supported_objects                                    supported_versions
        ----------------- -----------------                                    ------------------
        2.12              {ad_auth_service, admingroup, adminrole, adminuser…} {1.0, 1.1, 1.2, 1.2.1…}

    .EXAMPLE
        PS> Get-NIOSSchema -ObjectType dtc:lbdn

        cloud_additional_restrictions : {all}
        fields                        : {@{is_array=True; name=auth_zones; standard_field=False; supports=rwu; type=System.Object[]}, @{is_array=False; name=auto_consolidated_monitors; standard_field=False; supports=rwu; type=System.Object[]}, @{is_array=False; name=comment; searchable_by=:=~;
                                        standard_field=True; supports=rwus; type=System.Object[]}, @{is_array=False; name=disable; standard_field=False; supports=rwu; type=System.Object[]}…}
        restrictions                  : {csv}
        type                          : dtc:lbdn
        version                       : 2.12

    .EXAMPLE
        PS> Get-NIOSSchema -ObjectType dtc:lbdn -Fields | ft -AutoSize

        is_array name                       standard_field supports type
        -------- ----                       -------------- -------- ----
        True auth_zones                              False rwu      {zone_auth}
        False auto_consolidated_monitors             False rwu      {bool}
        False comment                                True  rwus     {string}
        False disable                                False rwu      {bool}
        False extattrs                               False rwu      {extattr}
        False health                                 False r        {dtc:health}
        False lb_method                              False rwu      {enum}
        False name                                   True  rwus     {string}
        True patterns                                False rwu      {string}
        False persistence                            False rwu      {uint}
        True pools                                   False rwu      {dtc:pool:link}
        False priority                               False rwu      {uint}
        False topology                               False rwu      {string}
        False ttl                                    False rwu      {uint}
        True types                                   False rwu      {enum}
        False use_ttl                                False rwu      {bool}

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Core
    #>
    param(
      [String]$ObjectType,
      [Switch]$Fields,
      [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'GET',
      [String]$Server,
      [String]$GridUID,
      [String]$GridName,
      [String]$ApiVersion,
      [Switch]$SkipCertificateCheck,
      [PSCredential]$Creds
    )

    begin {
        $InvokeOpts = Initialize-NIOSOpts $PSBoundParameters
        $Uri = "$($ObjectType)?_schema"

        Switch($Method) {
            'GET' {
                $MethodL = 'r'
            }
            {$_ -in @('PUT', 'PATCH')} {
                $MethodL = 'u'
            }
            {$_ -in @('POST', 'DELETE')} {
                $MethodL = 'w'
            }
        }
    }

    process {
        $GridCacheName = $(
            if ($InvokeOpts.Server) {
                $InvokeOpts.Server
            }
            if ($InvokeOpts.GridName) {
                $InvokeOpts.GridName
            }
            if ($InvokeOpts.GridUID) {
                $InvokeOpts.GridUID
            }
        )

        if ($ObjectType) {
            $SchemaType = $ObjectType
        } else {
            $SchemaType = 'base'
        }
        if (-not $Script:NIOSSchema) {
            $Script:NIOSSchema = @{}
        }
        if (-not $Script:NIOSSchema."$($GridCacheName)") {
            $Script:NIOSSchema."$($GridCacheName)" = @{}
        }
        if (-not $Script:NIOSSchema."$($GridCacheName)"."$($SchemaType)") {
            $Results = Invoke-NIOS -Uri $Uri @InvokeOpts
            $Script:NIOSSchema."$($GridCacheName)"."$($SchemaType)" = $Results
        }
        if ($Fields) {
            return $Script:NIOSSchema."$($GridCacheName)"."$($SchemaType)" | Select-Object -ExpandProperty Fields | Where-Object {$_.supports -like "*$($MethodL)*"}
        }
        return $Script:NIOSSchema."$($GridCacheName)"."$($SchemaType)"
    }
}