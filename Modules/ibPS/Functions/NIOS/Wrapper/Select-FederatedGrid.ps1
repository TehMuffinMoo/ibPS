function Select-FederatedGrid {
    param (
        $GridUID,
        $GridName
    )
    
    if ($GridUID) {
        if (!(Get-B1Host -tfilter "`"host/license_uid`"==`"$($GridUID)`"")) {
            Write-Error "Failed to find Grid associated with UID: $($GridUID)"
            break
        } else {
            $FederatedGridUID = $GridUID
        }
    }
    if ($GridName) {
        $FederatedGridUID = (Get-B1Host -Name $GridName -Strict).tags.'host/license_uid'
    }
    $Script:B1FederatedGrid = $FederatedGridUID
}