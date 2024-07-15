function Get-NIOSWebSession {
    param(
        [Parameter(Mandatory=$true)]
        [String]$Server,
        [Parameter(Mandatory=$true)]
        [PSCredential]$Creds
    )
    if ($Script:NIOSWebSessions) {
        if ($Script:NIOSWebSessions."$($Server)-$($Creds.UserName)") {
            $Script:NIOSWebSessions."$($Server)-$($Creds.UserName)"
        }
    }

}