function Get-B1ServiceLog {
    <#
    .SYNOPSIS
        Queries the BloxOneDDI Service Log

    .DESCRIPTION
        This function is used to query the BloxOneDDI Service Log. This log contains information from all containers on all BloxOneDDI Hosts, allowing you to query various types of diagnostic related data.

    .PARAMETER OnPremHost
        Use this parameter to filter the log for events relating to a specific BloxOneDDI Host

    .PARAMETER Container
        A pre-defined list of known containers to filter against.

    .PARAMETER Start
        A date parameter used as the starting date/time of the log search. By default, the search will start from 24hrs ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .EXAMPLE
        PS> Get-B1ServiceLog -OnPremHost "bloxoneddihost1.mydomain.corp" -Container "DNS" -Start (Get-Date).AddHours(-2)
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Logs
    #>
    param(
      [string]$OnPremHost,
      [string]$Container,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [Int]$Limit = 100
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()

    $Filters = @()
    if ($OnPremHost) {
        $OPHID = (Get-B1Host -Name $OnPremHost).ophid
        $Filters += "ophid=$OPHID"
    }
    if ($Container) {
        $Applications = Get-B1ServiceLogApplications
        if ($SelectedApp = $Applications | Where-Object {$_.label -eq $Container}) {
            $ContainerName = $SelectedApp.container_name
        } else {
            $ContainerName = $Container
        }
        $Filters += "container_name=$ContainerName"
    }

    if ($Limit) {
        $Filters += "_limit=$Limit"
    }

    $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ssZ")
    $Filters += "start=$StartTime"

    $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ssZ")
    $Filters += "end=$EndTime"

    $QueryFilters = ConvertTo-QueryString -Filters $Filters

    $B1OnPremHosts = Get-B1Host -Detailed
    if ($QueryFilters) {
        $Results = Query-CSP -Uri "$(Get-B1CSPUrl)/atlas-logs/v1/logs$QueryFilters" -Method GET | Select-Object -ExpandProperty logs | Select-Object timestamp,@{Name = 'onpremhost'; Expression = {$ophid = $_.ophid; (@($B1OnPremHosts).where({ $_.ophid -eq $ophid })).display_name }},container_name,msg,ophid -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "$(Get-B1CSPUrl)/atlas-logs/v1/logs" -Method GET | Select-Object -ExpandProperty logs | Select-Object timestamp,@{Name = 'onpremhost'; Expression = {$ophid = $_.ophid; (@($B1OnPremHosts).where({ $_.ophid -eq $ophid })).display_name }},container_name,msg,ophid -ErrorAction SilentlyContinue
    }
    if ($Results) {
        return $Results
    } else {
        Write-Host "Error. Unable to find any service logs." -ForegroundColor Red
        break
    }
}