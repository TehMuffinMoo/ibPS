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
        return $Script:NIOSSchema[$GridCacheName][$SchemaType]
    }
}