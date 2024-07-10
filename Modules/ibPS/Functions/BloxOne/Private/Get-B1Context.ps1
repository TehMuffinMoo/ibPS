function Get-B1Context {
    Initialize-B1Config
    $Configs = (Get-Content $Script:B1ConfigFile) | ConvertFrom-Json
    return $Configs
}