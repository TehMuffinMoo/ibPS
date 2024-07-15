function Get-B1DFPLog {
    <#
    .SYNOPSIS
        Queries the BloxOneDDI DFP Log

    .DESCRIPTION
        This function is used to query the BloxOneDDI DFP (DNS Forwarding Proxy) Logs. This is the log which contains all DNS Security related events.

    .PARAMETER Query
        Use this parameter to filter the DFP Logs by hostname or FQDN

    .PARAMETER IP
        Used to filter the DFP Log by IP Address

    .PARAMETER Type
        Used to filter the DFP Log by query type, such as "A" or "CNAME"

    .PARAMETER Response
        Use this parameter to filter the DFP Log by the response, i.e "NXDOMAIN"

    .PARAMETER Network
        Filter the DFP Logs by one or more DFP Servers, External Networks & BloxOne Endpoints (i.e "mybloxoneddihost.mydomain.corp (DFP)" or "mybloxoneddihost1.mydomain.corp (DFP)","mybloxoneddihost2.mydomain.corp (DFP)","BloxOne Endpoint"

    .PARAMETER Start
        A date parameter used as the starting date/time of the log search. By default, the search will start from 24hrs ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER OrderBy
        The field in which to order the results by. This field supports auto-complete, and defaults to timestamp.

    .PARAMETER Order
        The direction to order results in. This defaults to ascending.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .EXAMPLE
          PS> Get-B1DFPLog -IP "10.10.132.10" -Query "google.com" -Type "A" -Response "216.58.201.110" -Start (Get-Date).AddHours(-6) -End (Get-Date) -Limit 1000 -Offset 0

    .EXAMPLE
          PS> Get-B1DFPLog -Network "MyB1Host (DFP)" -Start (Get-Date).AddHours(-6) Limit 10

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Logs
    #>
    param(
      [string]$Query,
      [string]$IP,
      [string]$Type,
      [string]$Response,
      [string[]]$Network,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [String]$OrderBy = 'timestamp',
      [ValidateSet('asc','desc')]
      [String]$Order = 'asc',
      [int]$Limit = 100,
      [int]$Offset = 0
    )

    $Cube = 'PortunusDnsLogs'

    $Dimensions = @(
        "timestamp"
        "qname"
        "device_name"
        "qip"
        "network"
        "response"
        "dns_view"
        "query_type"
        "mac_address"
        "dhcp_fingerprint"
        "user"
        "os_version"
        "response_region"
        "response_country"
        "device_region"
        "device_country"
        # "severity"
        # "actor_id"
        # "app_category"
        # "app_name"
        # "app_vendor"
        # "category"
        # "confidence"
        # "domain_category"
        # "endpoint_groups"
        # "feed_name"
        # "policy_action"
        # "policy_id"
        # "policy_name"
        # "private_ip"
        # "qtype"
        # "tclass"
        # "tfamily"
        # "threat_indicator"
        # "tproperty"
        # "type"
        # "user_groups"
    )
    $Filters = @()

    if ($Query) {
        $QuerySplat = @{
            "member" = "$($Cube).qname"
            "operator" = "contains"
            "values" = @(
                $Query
            )
		}
        $Filters += $QuerySplat
    }

    if ($Type) {
        $Filters += @{
            "member" = "$($Cube).query_type"
            "operator" = "equals"
            "values" = @(
                $Type
            )
		}
    }

    if ($Response) {
        $Filters += @{
            "member" = "$($Cube).response"
            "operator" = "contains"
            "values" = @(
                $Response
            )
		}
    }

    if ($IP) {
        $Filters += @{
            "member" = "$($Cube).qip"
            "operator" = "contains"
            "values" = @(
                $IP
            )
		}
    }

    if ($Network) {
        $Filters += @{
            "member" = "$($Cube).network"
            "operator" = "contains"
            "values" = $Network
        }
    }

    $Result = Invoke-B1CubeJS -Cube $($Cube) -Dimensions $Dimensions -TimeDimension timestamp -Start $Start -End $End -Limit $Limit -Offset $Offset -Filters $Filters -OrderBy $OrderBy -Order $Order
    if ($Result) {
        return $Result
    } else {
        Write-Host "Error: No DNS logs returned." -ForegroundColor Red
    }
}