function Get-NIOSSchema {
    <#
    .SYNOPSIS

    .DESCRIPTION
        
    .EXAMPLE

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
            if ($Server) {
                $Server
            }
            if ($GridName) {
                $GridName
            }
            if ($GridUID) {
                $GridUID
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
        if (-not $Script:NIOSSchema[$GridCacheName]) {
            $Script:NIOSSchema[$GridCacheName] = @{}
        }
        if (-not $Script:NIOSSchema[$GridCacheName][$SchemaType]) {
            $Results = Invoke-NIOS -Uri $Uri @InvokeOpts
            $Script:NIOSSchema[$GridCacheName][$SchemaType] = $Results
        }
        if ($Fields) {
            return $Script:NIOSSchema[$GridCacheName][$SchemaType] | Select-Object -ExpandProperty Fields | Where-Object {$_.supports -like "*$($MethodL)*"}
        }
        return $Script:NIOSSchema[$GridCacheName][$SchemaType]
    }
}