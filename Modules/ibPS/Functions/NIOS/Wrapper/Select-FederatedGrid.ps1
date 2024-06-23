function Select-FederatedGrid {
    param (
        $GridUID,
        $GridName
    )
    
    if ($GridUID) {
        $GridMember = Get-B1Host -tfilter "`"host/license_uid`"==`"$($GridUID)`""
        if ($GridMember) {
            $FederatedGridUID = $GridUID
            $GridName = $GridMember.display_name
        } else {
            Write-Error "Failed to find Grid associated with UID: $($GridUID)"
            break            
        }
    } elseif ($GridName) {
        $FederatedGridUID = (Get-B1Host -Name $GridName -Strict).tags.'host/license_uid'
    }

    if ($FederatedGridUID) {
        Write-Colour "## WARNING ##" -Colour Yellow
        Write-Colour $($GridName)," is now the selected Grid. All NIOS commands will be run against the selected Grid." -Colour Red,Yellow
        Write-Colour "## WARNING ##" -Colour Yellow
        $ENV:B1FederatedGrid = $FederatedGridUID
    } else {
        Write-Error "Failed to select the NIOS Grid."
    }
}