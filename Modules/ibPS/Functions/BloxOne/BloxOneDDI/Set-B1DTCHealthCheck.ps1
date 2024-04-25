function Set-B1DTCHealthCheck {
    <#
    .SYNOPSIS
        Updates a health check object within BloxOne DTC

    .DESCRIPTION
        This function is used to update a health check object within BloxOne DTC
    
    .PARAMETER Name
        The name of the DTC health check object to update

    .PARAMETER NewName
        Use -NewName to update the name of the DTC health check object

    .PARAMETER Description
        The new description for the health check object

    .PARAMETER Interval
        Update the frequency in seconds in which the health check is performed.

    .PARAMETER Timeout
        Update the number of seconds before the health check times out.

    .PARAMETER RetryUp
        Update how many retry attempts before reporting a Healthy status.

    .PARAMETER RetryDown
        Update how many retry attempts before reporting a Down status.

    .PARAMETER State
        Update the state of the health check to enabled or disabled.

    .PARAMETER Port
        The -Port parameter is used only when updating the port on TCP or HTTP Health Checks.

    .PARAMETER UseHTTPS
        The -UseHTTPS parameter is used when selecting Use HTTPS in a HTTP Health Check

    .PARAMETER HTTPRequest
        The -HTTPRequest parameter is the HTTP Request that a HTTP Health Check will make when checking status. This accepts multi-line strings if separated by `n

    .PARAMETER StatusCodes
        The -StatusCodes parameter is used to specify which status codes are accepted to report a healthy status when using HTTP Health Checks. Use a zero ( 0 ) to select Status Codes 'any'

    .PARAMETER Tags
        Any tags you want to apply to the DTC health check

    .PARAMETER Object
        The DTC Health Check Object(s) to update. Accepts pipeline input.

    .EXAMPLE
        PS> 
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    [Parameter(ParameterSetName="Default",Mandatory=$true)]
    param(
      [Parameter(ParameterSetName='Default',Mandatory=$true)]
      [String]$Name,
      [String]$NewName,
      [String]$Description,
      [Int]$Interval,
      [Int]$Timeout,
      [Int]$RetryUp,
      [Int]$RetryDown,
      [ValidateSet("Enabled","Disabled")]
      [String]$State,
      [Int]$Port,
      [ValidateSet("Enabled","Disabled")]
      [String]$UseHTTPS,
      [String]$HTTPRequest,
      [AllowNull()]
      [Nullable[System.Int32][]]$StatusCodes,
      [System.Object]$Tags,
      [Parameter(
          ValueFromPipeline = $true,
          ParameterSetName="With ID",
          Mandatory=$true
      )]
      [System.Object]$Object
    )

    process {
        if ($Object) {
            $SplitID = $Object.id.split('/')
            $PermittedInputs = @('dtc/health_check_icmp','dtc/health_check_tcp','dtc/health_check_http')
            if (("$($SplitID[0])/$($SplitID[1])") -notin $PermittedInputs) {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dtc/health_check_icmp', 'dtc/health_check_tcp' & 'dtc/health_check_http' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DTCHealthCheck -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find DTC Health Check: $($Name)"
                return $null
            }
        }

        $NewObj = $Object | Select-Object -ExcludeProperty id,type,metadata

        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($Interval) {
            $NewObj.interval = $Interval
        }
        if ($Timeout) {
            $NewObj.timeout = $Timeout
        }
        if ($RetryUp) {
            $NewObj.retry_up = $RetryUp
        }
        if ($RetryDown) {
            $NewObj.retry_down = $RetryDown
        }

        if ($Port) {
            if ($Object.type -in @('tcp','http')) {
                $NewObj.port = $Port
            } else {
                Write-Error "The -Port parameter is only supported with TCP and HTTP Health Checks."
                return $null
            }
        }
        if ($UseHTTPS) {
            if ($Object.type -eq 'http') {
                $NewObj.https = $(if ($UseHTTPS -eq 'Enabled') { $true } else { $false })
            } else {
                Write-Error "The -UseHTTPS parameter is only supported with HTTP Health Checks."
                return $null
            }
        }
        if ($HTTPRequest) {
            if ($Object.type -eq 'http') {
                $NewObj.request = $HTTPRequest
            } else {
                Write-Error "The -HTTPRequest parameter is only supported with HTTP Health Checks."
                return $null
            }
        }
        if (0 -in $StatusCodes) {
            $NewObj.codes = $null
        }
        if ($StatusCodes) {
            if ($Object.type -eq 'http') {
                $NewObj.codes = $($StatusCodes -join ',')
            } else {
                Write-Error "The -StatusCodes parameter is only supported with HTTP Health Checks."
                return $null
            }
        }

        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress

        $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
        if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
            $Results | Select-Object -ExpandProperty result
        } else {
            $Results
        }
    }
}