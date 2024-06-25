function Set-NIOSWebSession {
    param(
        [Parameter(Mandatory=$true)]
        [String]$Server,
        [Parameter(Mandatory=$true)]
        [PSCredential]$Creds,
        [Parameter(Mandatory=$true)]
        [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession
    )
    if (-not $Script:NIOSWebSessions) {
        $Script:NIOSWebSessions = @{}
    }
    $Script:NIOSWebSessions."$($Server)-$($Creds.Username)" = $WebSession
}