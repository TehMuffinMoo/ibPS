function Optimize-B1ServerTokens {
    <#
    .SYNOPSIS
        Checks and optionally applies optimizations to NIOS-X Server Token Consumption

    .DESCRIPTION
        This function is used to check and optionally apply optimizations to NIOS-X Server Token Consumption by right-sizing the Server SKUs

    .PARAMETER Action
        The action to perform. Use 'Check' to check for right-sizing opportunities, or 'Apply' to apply right-sizing to any NIOS-X Servers that are not optimally sized.

    .PARAMETER Force
        Bypass confirmation prompts when applying right-sizing optimizations.

    .EXAMPLE
        PS> Optimize-B1ServerTokens -Action Check | ft * -AutoSize

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
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(
        [ValidateSet('Check','Apply')]
        [String]$Action = 'Check',
        [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $Results = @()
    $NIOSXSKUs = Get-NIOSXSKUs
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

    if ($Action -ne $null) {
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
            Write-Host "Token Delta: $TokenDeltaSymbol $TokenDelta (Token Packs: $TokenDeltaSymbol $(($TokenDelta) / 500))`n" -ForegroundColor Red
        } else {
            Write-Host "All NIOS-X Servers are correctly sized based on their QPS, LPS & Object Count." -ForegroundColor Green
        }

        if ($Action -eq "Apply") {
            foreach ($HostToBeRightSized in $ToBeRightSized) {
                if($PSCmdlet.ShouldProcess("Applying right-sizing for $($HostToBeRightSized.display_name). Current Size: $($HostToBeRightSized.size). Should Be Size: $($HostToBeRightSized.should_be_size)","Apply right-sizing for: $($HostToBeRightSized.display_name)?",$MyInvocation.MyCommand)){
                    Write-Host "Applying right-sizing for $($HostToBeRightSized.display_name). Current Size: $($HostToBeRightSized.size). Should Be Size: $($HostToBeRightSized.should_be_size)" -ForegroundColor Yellow
                    $UpdateResult = Get-B1Host -id $HostToBeRightSized.id | Set-B1Host -Size $HostToBeRightSized.should_be_size
                    if ($UpdateResult) {
                        Write-Host "Successfully applied right-sizing for $($HostToBeRightSized.display_name). New Size: $($UpdateResult.size)" -ForegroundColor Green
                    } else {
                        Write-Host "Failed to apply right-sizing for $($HostToBeRightSized.display_name)." -ForegroundColor Red
                    }
                }
            }
        }
    } else {
        $Results
    }
}