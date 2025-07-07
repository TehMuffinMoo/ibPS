## DHCP Reports
### Simple DHCP Report
This is a simple example of how to query DHCP Ranges by Utilization. The following example shows obtaining a list of DHCP Ranges where the utilization is between 90 and 99%.
```powershell
Get-B1Range -CustomFilters 'utilization.utilization>=90 and utilization.utilization<100' | ft name,start,end,@{name='utilization';expr={"$($_.utilization.utilization)%"}} -AutoSize

name              start         end            utilization
----              -----         ---            -----------
Client            10.11.242.129 10.11.242.254  92%
IoT               10.90.17.1    10.90.17.62    92%
Server            10.13.48.129  10.13.48.254   93%
Azure             10.5.24.1     10.5.25.254    94%
AWS               10.13.48.65   10.13.48.126   94%
GCP               10.210.207.1  10.210.207.254 95%
Management        10.18.59.133  10.18.59.157   96%
Operational       10.210.117.1  10.210.117.126 96%
Guest             10.63.224.4   10.63.225.254  97%
Other             10.14.77.1    10.14.77.126   97%
Supplier          10.8.242.1    10.8.242.126   97%
Management        10.11.245.129 10.11.245.254  98%
Supplier Other    10.14.59.65   10.14.59.126   99%
```

### DHCP Report Script
This example will show how you can create a Global DHCP Utilization Report.

The function included below will enable you to produce a report with the Top X offending DHCP Ranges based on utilization. 

```powershell
function DHCP-Report {
    <#
    .SYNOPSIS
        A simple script function designed to report on DHCP Utilization from Universal DDI

    .DESCRIPTION
        This function is used to create a DHCP Utilization report, with the Top X offenders listed.

    .PARAMETER MaxResults
        Return the top X number of DHCP Ranges based on highest utilization. Returns Top 15 offending ranges by default.

    .PARAMETER MinRangeSize
        Return results based on minimum range size. Ignores ranges with <32 addresses by default.

    .PARAMETER ResolveSubnets
        Return the associated parent Subnet in the results. This will considerably slow down the query if returning a large number of results.

    .EXAMPLE
        PS> DHCP-Report -MinRangeSize 300 -MaxResults 15 -ResolveSubnets | ft * -AutoSize

        Name                                RangeStart   RangeEnd       Total Dynamic Static Abandoned Used Free Utilization Subnet
        ----                                ----------   --------       ----- ------- ------ --------- ---- ---- ----------- ------
        Client                              10.15.146.1  10.15.147.254  510   0       260    0         260  250  51%         10.15.146.0/23
        Client                              10.8.4.1     10.8.7.254     1022  0       542    0         542  480  53%         10.8.4.0/22
        Client                              10.209.6.1   10.209.7.254   510   0       277    0         277  233  54%         10.209.6.0/23
                                            10.63.48.6   10.63.49.254   505   0       283    0         283  222  56%         10.63.48.0/23
        Client                              10.11.20.1   10.11.23.254   1022  0       610    0         610  412  60%         10.11.20.0/22
        Client                              10.11.224.1  10.11.225.254  510   0       334    0         334  176  65%         10.11.224.0/23
        Birmingham-Site-A-Floor-4           10.110.14.5  10.110.15.254  506   0       346    0         346  160  68%         10.110.14.0/23
        Birmingham-Site-A-Floor-4           10.29.0.1    10.29.3.254    1022  0       771    0         771  251  75%         10.29.0.0/22
                                            171.26.188.1 171.26.189.254 510   0       390    0         390  120  76%         171.26.188.0/23
        Server                              10.5.24.1    10.5.25.254    510   0       493    0         493  17   97%         10.5.24.0/23
                                            10.63.224.4  10.63.225.254  507   0       494    0         494  13   97%         10.63.224.0/23
        Guest                               10.11.246.1  10.11.247.254  510   0       506    0         506  4    99%         10.11.246.0/23
                                            10.63.226.4  10.63.227.254  507   0       507    0         507  0    100%        10.63.226.0/23
                                            10.63.228.4  10.63.229.254  507   0       507    0         507  0    100%        10.63.228.0/23
        RFID                                10.11.160.1  10.11.161.254  510   0       509    0         509  1    100%        10.11.160.0/23
    #>
    param(
      [Int]$MaxResults = 100,
      [Int]$MinRangeSize = 32,
      [Switch]$ResolveSubnets
    )

    ## Get full list of all DHCP Ranges
    Write-Host -NoNewLine "`rQuerying list of DHCP Ranges..                                           " -ForegroundColor Cyan
    $RangeList = Get-B1Range -Limit $($MaxResults) -Fields name,start,end,utilization,parent -OrderBy 'utilization.utilization desc' -CustomFilters "utilization.total>=$($MinRangeSize)"

    $Total = $RangeList.count
    $Current = 0
    $Results = @()
    foreach ($Range in $RangeList) {
      $Current++
      Write-Host -NoNewLine "`r($($Current)/$($Total)): Processing Range: $($Range.start) - $($Range.end)                                           " -ForegroundColor Cyan
      $Data = [PSCustomObject]@{
        "Name" = $Range.name
        "RangeStart" = $Range.start
        "RangeEnd" = $Range.end
        "Total" = $Range.utilization.total
        "Dynamic" = $Range.utilization.dynamic
        "Static" = $Range.utilization.static
        "Abandoned" = $Range.utilization.abandoned
        "Used" = $Range.utilization.used
        "Free" = $Range.utilization.free
        "Utilization" = $($Range.utilization.utilization)
        "Parent" = $Range.parent
      }
      $Results += $Data
    }
    Write-Host -NoNewLine "`r                                                                                                                                                                            "

    $Results = $Results | Sort-Object Utilization | Select-Object Name,RangeStart,RangeEnd,Total,Dynamic,Static,Abandoned,Used,Free,@{name='Utilization';expr={"$($_.Utilization)%"}},Parent
    if ($ResolveSubnets) {
      $SubnetCount = $Results.count
      $SubnetIter = 0
      foreach ($Result in $Results) {
        $SubnetIter++
        Write-Host -NoNewLine "`r($($SubnetIter)/$($SubnetCount)): Resolving Subnet for: $($Result.RangeStart)                                           " -ForegroundColor Cyan
        $ParentSubnet = Get-B1Subnet -id $Result.parent -Fields address,cidr
        $Result | Add-Member -MemberType NoteProperty -Name "Subnet" -Value "$($ParentSubnet.address)/$($ParentSubnet.cidr)"
      }
    }
    return $Results | Select-Object * -ExcludeProperty Parent
}
```