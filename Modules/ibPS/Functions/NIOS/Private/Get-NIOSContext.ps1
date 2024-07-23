function Get-NIOSContext {
    $Configs = (Get-Content $Script:NIOSConfigFile) | ConvertFrom-Json
    return $Configs
}