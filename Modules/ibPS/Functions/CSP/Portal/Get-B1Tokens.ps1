function Get-B1Tokens {
    <#
    .SYNOPSIS
        Retrieves summary information on Token Consumption

    .DESCRIPTION
        This function is used query summary information around Infoblox Token Consumption

    .PARAMETER Bucket
        Management, Server or Reporting

        Selecting Server will return a list of servers with some additional fields including 'should_be_size' and 'needs_right_sizing' based on the defined NIOS-X SKU thresholds.

    .PARAMETER RightSizing
        The RightSizing parameter is used in conjunction with '-Bucket Server' to retrieve a list of NIOS-X servers that require right-sizing, and optionally apply the changes.
        Using 'Check' will return a list of NIOS-X Servers that require right-sizing based on their object peak, in addition to returning the current & expected token usage.
        Using 'Apply' will apply the right-sizing changes for any NIOS-X Servers that require it, in addition to returning the current & expected token usage.

    .EXAMPLE
        PS> Get-B1Tokens -Bucket Server -RightSizing Check | ft * -AutoSize

Current Token Count: 191980 (Token Packs: 383.96)
Expected Token Count: 194240 (Token Packs: 388.48)
Token Delta: > 2260 (Token Packs: > 4.52)
display_name    size should_be_size needs_right_sizing tokens_current tokens_should_be objects_current objects_peak objects_percentage qps_current qps_peak qps_percentage lps_current lps_peak lps_percentage
------------    ---- -------------- ------------------ -------------- ---------------- --------------- ------------ ------------------ ----------- -------- -------------- ----------- -------- --------------
vmniosx-001     XXS  XS                           True            130              250            4548         4730            157.667      87.200   98.030          1.961       0.470    0.630          0.840
vmniosx-002     XXS  XS                           True            130              250            3198         3201            106.700      17.500   40.630          0.813       0.600    1.100          1.467
vmniosx-004     XXS  XS                           True            130              250            2988         3005            100.167      18.520   34.350          0.687       0.700    0.870          1.160
vmniosx-010     XXS  S                            True            130              470            6500         7824            260.800     835.750 1369.680         27.394       1.900    2.830          3.773
vmniosx-014     XXS  XS                           True            130              250            3419         3480            116.000      63.470   95.800          1.916       0.470    0.770          1.027
vmniosx-019     XXS  XS                           True            130              250            3654         3735            124.500      28.970   37.500          0.750       0.600    0.630          0.840

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Infoblox Portal

    .FUNCTIONALITY
        Licenses
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)]
        [ValidateSet('Management','Server','Reporting')]
        [String]$Bucket
    )

    DynamicParam {
        if ($Bucket -eq "Server") {
             $RightSizingAttribute = New-Object System.Management.Automation.ParameterAttribute
             $RightSizingAttribute.Position = 3
             $RightSizingAttribute.HelpMessage = "The RightSizing parameter is used to retrieve right-sizing information for NIOS-X Servers."

             $RightSizingCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
             $RightSizingCollection.Add($RightSizingAttribute)
             $RightSizingValidateSet = New-Object System.Management.Automation.ValidateSetAttribute("Check","Apply")
             $RightSizingCollection.Add($RightSizingValidateSet)

             #add our paramater specifying the attribute collection
             $RightSizingParam = New-Object System.Management.Automation.RuntimeDefinedParameter('RightSizing', [string], $RightSizingCollection)

             #expose the name of our parameter
             $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
             $paramDictionary.Add('RightSizing', $RightSizingParam)
             return $paramDictionary
       }
    }

    process {
        $NIOSXSKUs = @{
            'XXS' = @{
                'QPSLimit' = 5000
                'LPSLimit' = 75
                'ObjectLimit' = 3000
                'Tokens' = 130
            }
            'XS' = @{
                'QPSLimit' = 10000
                'LPSLimit' = 150
                'ObjectLimit' = 7500
                'Tokens' = 250
            }
            'S' = @{
                'QPSLimit' = 20000
                'LPSLimit' = 200
                'ObjectLimit' = 29000
                'Tokens' = 470
            }
            'M' = @{
                'QPSLimit' = 40000
                'LPSLimit' = 300
                'ObjectLimit' = 110000
                'Tokens' = 880
            }
            'L' = @{
                'QPSLimit' = 70000
                'LPSLimit' = 400
                'ObjectLimit' = 440000
                'Tokens' = 1900
            }
            'XL' = @{
                'QPSLimit' = 115000
                'LPSLimit' = 675
                'ObjectLimit' = 880000
                'Tokens' = 2700
            }
        }

        Switch($Bucket) {
            "Management" {

            }
            "Server" {
                $Results = @()
                $RightSizing = $PSBoundParameters['RightSizing']
                foreach ($B1Host in $(Get-B1Host -Detailed | Where-Object {$_.host_type -ne 6})) {
                    # Check $B1Host.object.peak against the defined thresholds and assign a 'should be' size category, in addition to checking against the real size and creating a field for if it needs right-sizing or not
                    # Additionally, check $B1Host.qps.peak and $B1Host.lps.peak against the defined thresholds and write a warning if either of those are above the defined limits for that size category
                    $B1Host | Add-Member -MemberType NoteProperty -Name 'should_be_size' -Value $(
                        switch ($B1Host.object.peak) {
                            { $_ -le $NIOSXSKUs['XXS']['ObjectLimit'] -and $B1Host.qps.peak -le $NIOSXSKUs['XXS']['QPSLimit'] -and $B1Host.lps.peak -le $NIOSXSKUs['XXS']['LPSLimit'] } { 'XXS'; break }
                            { $_ -le $NIOSXSKUs['XS']['ObjectLimit'] -and $B1Host.qps.peak -le $NIOSXSKUs['XS']['QPSLimit'] -and $B1Host.lps.peak -le $NIOSXSKUs['XS']['LPSLimit'] } { 'XS'; break }
                            { $_ -le $NIOSXSKUs['S']['ObjectLimit'] -and $B1Host.qps.peak -le $NIOSXSKUs['S']['QPSLimit'] -and $B1Host.lps.peak -le $NIOSXSKUs['S']['LPSLimit'] } { 'S'; break }
                            { $_ -le $NIOSXSKUs['M']['ObjectLimit'] -and $B1Host.qps.peak -le $NIOSXSKUs['M']['QPSLimit'] -and $B1Host.lps.peak -le $NIOSXSKUs['M']['LPSLimit'] } { 'M'; break }
                            { $_ -le $NIOSXSKUs['L']['ObjectLimit'] -and $B1Host.qps.peak -le $NIOSXSKUs['L']['QPSLimit'] -and $B1Host.lps.peak -le $NIOSXSKUs['L']['LPSLimit'] } { 'L'; break }
                            default { 'XL'; break }
                        }
                        
                    ) -Force
                    
                    $B1Host | Add-Member -MemberType NoteProperty -Name 'needs_right_sizing' -Value $(
                        if ($B1Host.should_be_size -ne $B1Host.size) {
                            $true
                        } else {
                            $false
                        }
                    )

                    $B1Host | Add-Member -MemberType NoteProperty -Name 'tokens_current' -Value $NIOSXSKUs[$B1Host.size]['Tokens']
                    $B1Host | Add-Member -MemberType NoteProperty -Name 'tokens_should_be' -Value $NIOSXSKUs[$B1Host.should_be_size]['Tokens']
                    $Results += $B1Host
                }

                if ($RightSizing -ne $null) {
                    $ToBeRightSized = $Results | Select-Object display_name,size,should_be_size,needs_right_sizing,tokens_current,tokens_should_be,
                            @{ Name = 'objects_current'; Expression = { $_.object.current }},
                            @{ Name = 'objects_peak'; Expression = { $_.object.peak }},
                            @{ Name = 'objects_percentage'; Expression = { "$( [math]::Round(($_.object.peak / $NIOSXSKUs[$_.size]['ObjectLimit']) * 100, 2))%"}},
                            @{ Name = 'objects_limit'; Expression = { $NIOSXSKUs[$_.size]['ObjectLimit'] }} ,
                            @{ Name = 'qps_current'; Expression = { $_.qps.current }},
                            @{ Name = 'qps_peak'; Expression = { $_.qps.peak }},
                            @{ Name = 'qps_percentage'; Expression = { "$( [math]::Round(($_.qps.peak / $NIOSXSKUs[$_.size]['QPSLimit']) * 100, 2))%"}},
                            @{ Name = 'qps_limit'; Expression = { $NIOSXSKUs[$_.size]['QPSLimit'] }} ,
                            @{ Name = 'lps_current'; Expression = { $_.lps.current }},
                            @{ Name = 'lps_peak'; Expression = { $_.lps.peak }},
                            @{ Name = 'lps_percentage'; Expression = { "$( [math]::Round(($_.lps.peak / $NIOSXSKUs[$_.size]['LPSLimit']) * 100, 2))%"}},
                            @{ Name = 'lps_limit'; Expression = { $NIOSXSKUs[$_.size]['LPSLimit'] }},id |
                            Where-Object {$_.needs_right_sizing -eq $true}

                    if ($ToBeRightSized.Count -gt 0) {
                        $ToBeRightSized

                        Write-Host "Current Token Count: $(($Results | Measure-Object -Property tokens_current -Sum).Sum) (Token Packs: $(($Results | Measure-Object -Property tokens_current -Sum).Sum / 500))" -ForegroundColor Cyan
                        Write-Host "Expected Token Count: $(($Results | Measure-Object -Property tokens_should_be -Sum).Sum) (Token Packs: $(($Results | Measure-Object -Property tokens_should_be -Sum).Sum / 500))" -ForegroundColor Green
                        $TokenDelta = $(($Results | Measure-Object -Property tokens_should_be -Sum).Sum) - $(($Results | Measure-Object -Property tokens_current -Sum).Sum)
                        $TokenDeltaSymbol = if ($TokenDelta -gt 0) { '>' } elseif ($TokenDelta -lt 0) { '<' } else { '=' }
                        Write-Host "Token Delta: $TokenDeltaSymbol $TokenDelta (Token Packs: $TokenDeltaSymbol $(($TokenDelta) / 500))" -ForegroundColor Red
                    } else {
                        Write-Host "All NIOS-X Servers are correctly sized based on their QPS, LPS & Object Count." -ForegroundColor Green
                    }

                    if ($RightSizing -eq "Apply") {
                        foreach ($HostToBeRightSized in $ToBeRightSized) {
                            Write-Host "Applying right-sizing for $($HostToBeRightSized.display_name). Current Size: $($HostToBeRightSized.size). Should Be Size: $($HostToBeRightSized.should_be_size)" -ForegroundColor Yellow
                            $UpdateResult = Get-B1Host -id $HostToBeRightSized.id | Set-B1Host -Size $HostToBeRightSized.should_be_size
                            if ($UpdateResult) {
                                Write-Host "Successfully applied right-sizing for $($HostToBeRightSized.display_name). New Size: $($UpdateResult.size)" -ForegroundColor Green
                            } else {
                                Write-Host "Failed to apply right-sizing for $($HostToBeRightSized.display_name)." -ForegroundColor Red
                            }
                        }
                    }
                } else {
                    $Results
                }
            }
            "Reporting" {

            }
        }
    }
}