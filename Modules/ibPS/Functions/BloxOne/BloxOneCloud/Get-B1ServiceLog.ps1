function Get-B1ServiceLog {
    <#
    .SYNOPSIS
        Queries the BloxOneDDI Service Log

    .DESCRIPTION
        This function is used to query the BloxOneDDI Service Log. This log contains information from all containers on all BloxOneDDI Hosts, allowing you to query various types of diagnostic related data.

    .PARAMETER B1Host
        Use this parameter to filter the log for events relating to a specific BloxOneDDI Host

    .PARAMETER Container
        A pre-defined list of known containers to filter against.

    .PARAMETER Start
        A date parameter used as the starting date/time of the log search. By default, the search will start from 24hrs ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .EXAMPLE
        PS> Get-B1ServiceLog -B1Host "bloxoneddihost1.mydomain.corp" -Container "DNS" -Start (Get-Date).AddHours(-2)

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Logs
    #>
    [CmdletBinding()]
    param(
      [Alias('OnPremHost')]
      [string]$B1Host,
      [string]$Container,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [Int]$Limit = 100,
      [Int]$Offset
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()

    $Filters = @()
    if ($B1Host) {
        $OPHID = (Get-B1Host -Name $B1Host).ophid
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
    if ($Offset) {
        $Filters += "_limit=$Limit"
    }

    $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ssZ")
    $Filters += "start=$StartTime"

    $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ssZ")
    $Filters += "end=$EndTime"

    $QueryFilters = ConvertTo-QueryString -Filters $Filters
    Write-DebugMsg -Filters $Filters
    $B1Hosts = Get-B1Host -Detailed -Fields ohpid,display_name -Limit 2500
    if ($QueryFilters) {
        $Results = Invoke-CSP -Uri "$(Get-B1CSPUrl)/atlas-logs/v1/logs$QueryFilters" -Method GET
    } else {
        $Results = Invoke-CSP -Uri "$(Get-B1CSPUrl)/atlas-logs/v1/logs" -Method GET
    }
    if ($Results) {
        return $Results.logs | Select-Object timestamp,@{Name = 'B1Host'; Expression = {$ophid = $_.ophid; (@($B1Hosts).where({ $_.ophid -eq $ophid })).display_name }},container_name,msg,ophid -ErrorAction SilentlyContinue
    } else {
        Write-Host "Error. Unable to find any service logs." -ForegroundColor Red
        break
    }
}