function Get-B1Context {
    $Configs = (Get-Content $Script:B1ConfigFile) | ConvertFrom-Json
    return $Configs
}