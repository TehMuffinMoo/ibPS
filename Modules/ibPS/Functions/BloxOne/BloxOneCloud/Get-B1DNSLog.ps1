function Get-B1DNSLog {
    <#
    .SYNOPSIS
        Queries the BloxOneDDI DNS Log

    .DESCRIPTION
        This function is used to query the BloxOneDDI DNS Logs. This is the log which contains all generic DNS request information.

    .PARAMETER Query
        Use this parameter to filter the DNS Logs by hostname or FQDN

    .PARAMETER IP
        Used to filter the DNS Log by IP Address. Accepts multiple inputs.

    .PARAMETER Name
        Used to filter the DNS Log by Client Host Name. Accepts multiple inputs.

    .PARAMETER Type
        Used to filter the DNS Log by query type, such as "A" or "CNAME"

    .PARAMETER Response
        Use this parameter to filter the DNS Log by the response, i.e "NXDOMAIN"

    .PARAMETER DNSServers
        Filter the DNS Logs by one or more DNS Servers (i.e "mybloxoneddihost.mydomain.corp" or "mybloxoneddihost1.mydomain.corp","mybloxoneddihost2.mydomain.corp"

    .PARAMETER OrderBy
        The field in which to order the results by. This field supports auto-complete, and defaults to timestamp.

    .PARAMETER Order
        The direction to order results in. This defaults to ascending.

    .PARAMETER Start
        A date parameter used as the starting date/time of the log search. By default, the search will start from 24hrs ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination. Only works if -Limit is less than 10,000 and combined Limit and Offset do not exceed 10,000

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        PS> Get-B1DNSLog -IP "10.10.172.35" -Query "google.com" -Type "A" -Response "216.58.201.110" -Start (Get-Date).AddHours(-6) -End (Get-Date) -Limit 1000 -Offset 0

    .EXAMPLE
        PS> Get-B1DNSLog -IP "10.10.172.35" -Query "google.com" -Type "A" -Response "216.58.201.110" -Start (Get-Date).AddHours(-6) -End (Get-Date) -Limit 1000 -Offset 0

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Logs
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(
      [string]$Query,
      [string[]]$IP,
      [string[]]$Name,
      [string]$Type,
      [string]$Response,
      [string[]]$DNSServers,
      [String]$OrderBy = 'timestamp',
      [ValidateSet('asc','desc')]
      [String]$Order = 'asc',
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [ValidateRange(1,50000)]
      [int]$Limit = 100,
      [int]$Offset = 0,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $Cube = 'NstarDnsActivity'

    if ($Limit -ge 10001) {
        $UseExport = $true
    }

    $DNSHostQuery = Get-B1DNSHost -Limit 2500 -Fields site_id,name
    $DNSServices += $DNSHostQuery
    if ($DNSHostQuery.count -eq 2500) {
        $Offset = 2500
        while ($DNSHostQuery.count -gt 0) {
            $DNSHostQuery = Get-B1DNSHost -Limit 2500 -Offset $Offset -Fields site_id,name
            $DNSServices += $DNSHostQuery
            $Offset += 2500
        }
    }

    $Dimensions = @(
        "timestamp",
        "qname",
        "response",
        "query_type",
        "dns_view",
        "device_ip",
        "mac_address",
        "dhcp_fingerprint",
        "device_name",
        "query_nanosec",
        "site_id"
    )

    $Filters = @()

    if ($Query) {
        $Filters += @{
            "member" = "NstarDnsActivity.qname"
            "operator" = "contains"
            "values" = @(
                $Query
            )
		}
    }

    if ($Type) {
        $Filters += @{
            "member" = "NstarDnsActivity.query_type"
            "operator" = "equals"
            "values" = @(
                $Type
            )
		}
    }

    if ($Response) {
        $Filters += = @{
            "member" = "NstarDnsActivity.response"
            "operator" = "contains"
            "values" = @(
                $Response
            )
		}
    }

    if ($IP) {
        $Filters += @{
            "member" = "NstarDnsActivity.device_ip"
            "operator" = "contains"
            "values" = $IP
		}
    }

    if ($Name) {
        $Filters += @{
            "member" = "NstarDnsActivity.device_name"
            "operator" = "contains"
            "values" = $Name
		}
    }

    if ($DNSServers) {
        $DNSServerArr = @()
        foreach ($DNSServer in $DNSServers) {
          $SiteID = ($DNSServices | Where-Object {$_.name -like "*$DNSServer*"}).site_id
          $DNSServerArr += $SiteID
        }
        $Filters += @{
            "member" = "NstartDnsActivity.site_id"
            "operator" = "equals"
            "values" = $DNSServerArr
        }
    }

    $Data = $splat | ConvertTo-Json -Depth 4 -Compress
    $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
    if($PSCmdlet.ShouldProcess("Query the DNS Logs","Query the DNS Logs",$MyInvocation.MyCommand)){
        if ($UseExport) {
            $Options = '{"output":"csv","header":{"enabled":true,"display":["timestamp","query","response","query_type","dns_view","device_ip","mac_address","dhcp_fingerprint","name","query_nanosec"]}}'
            Write-DebugMsg -Query ($splat | ConvertTo-Json -Depth 4)
            $Result = Invoke-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/export?query=$Query&options=$Options"
            $ResultData = ConvertFrom-Csv $Result
            if ($ResultData) {
                $ResultData
            } else {
                Write-Host "Error: No DNS logs returned." -ForegroundColor Red
            }
        } else {
            $Result = Invoke-B1CubeJS -Cube $($Cube) -Dimensions $Dimensions -TimeDimension timestamp -Start $Start -End $End -Limit $Limit -Offset $Offset -Filters $Filters -OrderBy $OrderBy -Order $Order
            if ($Result) {
                return $Result | Select-Object @{name="dns_server";Expression={$siteId = $_.'site_id'; (@($DNSServices).where({ $_.site_id -eq $siteId })).name}},*
            } else {
                Write-Host "Error: No DNS logs returned." -ForegroundColor Red
            }
        }
    }
}