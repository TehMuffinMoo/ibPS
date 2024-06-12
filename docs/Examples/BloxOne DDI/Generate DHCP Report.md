## DHCP Report
This example will show how you can create a Global DHCP Utilization Report.

The function included below will enable you to produce a report with the Top X offending DHCP Ranges based on utilization. 

```powershell
function DHCP-Report {
    <#
    .SYNOPSIS
        A simple script function designed to report on DHCP Utilization from BloxOne DDI

    .DESCRIPTION
        This function is used to create a DHCP Utilization report, with the Top X offenders listed.

    .PARAMETER MaxResults
        Return the top X number of DHCP Ranges based on highest utilization. Returns Top 15 offending ranges by default.

    .PARAMETER MinRangeSize
        Return results based on minimum range size. Ignores ranges with <32 addresses by default.

    .PARAMETER ResolveSubnets
        Return the associated parent Subnet in the results. This will considerably slow down the query in large environments.

    .EXAMPLE
        PS> DHCP-Report -MinRangeSize 300 -MaxResults 15 -ResolveSubnets:$true | ft * -AutoSize

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
    [Bool]$ResolveSubnets = $False
  )

  if ($ResolveSubnets) {
    ## Get full list of all Subnets
    Write-Host -NoNewLine "`rQuerying list of DHCP Subnets..                                           " -ForegroundColor Cyan
    $SubnetsList = @()
    $Subnets = Get-B1Subnet -Limit 10000 -Fields address,cidr
    $SubnetsList += $Subnets
    $SubnetOffset = 0
    while ($Subnets.Count -eq 10000) {
      $SubnetOffset += 10000
      $Subnets = Get-B1Subnet -Limit 10000 -Offset $SubnetOffset -Fields address,cidr
      $SubnetsList += $Subnets
    }
  }

  ## Get full list of all DHCP Ranges
  $RangeList = @()
  Write-Host -NoNewLine "`rQuerying list of DHCP Ranges..                                           " -ForegroundColor Cyan
  $Ranges = Get-B1Range -Limit 10000 -Fields name,start,end,utilization,parent
  $RangeList += $Ranges
  $RangeOffset = 0
  while ($Ranges.Count -eq 10000) {
    $RangeOffset += 10000
    $Ranges = Get-B1Range -Limit 10000 -Offset $RangeOffset -Fields name,start,end,utilization,parent
    $RangeList += $Ranges
  }

  $Total = $RangeList.count
  $Current = 0
  $Results = @()
  foreach ($Range in $RangeList) {
    $Current++
    Write-Host -NoNewLine "`r($($Current)/$($Total)): Processing Range: $($Range.start) - $($Range.end)                                           " -ForegroundColor Cyan
    if ([int]$($Range.utilization.total) -ge [int]$MinRangeSize) {
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
  }
  Write-Host -NoNewLine "`r                                                                                                                                                                            "

  $Results = $Results | Sort-Object Utilization | Select-Object Name,RangeStart,RangeEnd,Total,Dynamic,Static,Abandoned,Used,Free,@{name='Utilization';expr={"$($_.Utilization)%"}},Parent -Last $($MaxResults)
  if ($ResolveSubnets) {
    $SubnetCount = $Results.count
    $SubnetIter = 0
    foreach ($Result in $Results) {
      $SubnetIter++
      Write-Host -NoNewLine "`r($($SubnetIter)/$($SubnetCount)): Resolving Subnet for: $($Result.RangeStart)                                           " -ForegroundColor Cyan
      $ParentSubnet = $($SubnetsList | Where-Object {$_.id -eq $Result.Parent})
      $Result | Add-Member -MemberType NoteProperty -Name "Subnet" -Value "$($ParentSubnet.address)/$($ParentSubnet.cidr)"
    }
  }
  return $Results | Select-Object * -ExcludeProperty Parent
}
```