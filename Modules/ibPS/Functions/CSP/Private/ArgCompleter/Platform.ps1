[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
param()

$Arg_Applications = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-B1Applications | Where-Object {$_ -like "$wordToComplete*"}
}
Register-ArgumentCompleter -CommandName Get-B1Service,New-B1Service -ParameterName Type -ScriptBlock $Arg_Applications

$Arg_NIOSX_SKUs = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    @('XXS','XS','S','M','L','XL') | Where-Object {$_ -like "$wordToComplete*"}
}
Register-ArgumentCompleter -CommandName Set-B1Host,New-B1Host -ParameterName Size -ScriptBlock $Arg_NIOSX_SKUs

$Arg_NIOSX_SM = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $(Get-B1Host -Name $wordToComplete).display_name
}
Register-ArgumentCompleter -CommandName Get-B1Host,Set-B1Host,Remove-B1Host -ParameterName Name -ScriptBlock $Arg_NIOSX_SM
Register-ArgumentCompleter -CommandName Disable-B1HostLocalAccess,Enable-B1HostLocalAccess,Get-B1HealthCheck,Get-B1BootstrapConfig,Get-B1HostLocalAccess,Get-B1ServiceLog,New-B1Service,Restart-B1Host,Start-B1DiagnosticTask -ParameterName Server -ScriptBlock $Arg_NIOSX_SM

$Arg_AsAService_Services = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1AsAServiceServices | Where-Object {$_.name -like "$wordToComplete*"}).name
}
$AsAServiceServicesFunctions = @(
    'Get-B1AsAServiceServiceStatus'
    'Get-B1AASServiceStatus'
    'Get-B1AsAServiceDeployments'
    'Get-B1AASDeployments'
    'Get-B1AsAServiceConfigChanges'
    'Get-B1AASConfigChanges'
    'Get-B1AsAServiceCapabilities'
    'Get-B1AASCapabilities'
    'Get-B1AsAServiceTunnels'
    'Get-B1AASTunnels'
)
Register-ArgumentCompleter -CommandName $AsAServiceServicesFunctions -ParameterName Service -ScriptBlock $Arg_AsAService_Services

$Arg_AsAService_AccessLocations = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    if (-not $fakeBoundParameters['Service']) {
        Write-Host "`nService parameter is required when specifying a location." -ForegroundColor Red
        return
    }
    (Get-B1AsAServiceServiceStatus -Service $fakeBoundParameters['Service'] | Where-Object {$_.access_location_name -like "$wordToComplete*"}).access_location_name
}
$AsAServiceAccessLocationsFunctions = @(
    'Get-B1AsAServiceDeployments'
    'Get-B1AASDeployments'
    'Get-B1AsAServiceConfigChanges'
    'Get-B1AASConfigChanges'
    'Get-B1AsAServiceTunnels'
    'Get-B1AASTunnels'
)
Register-ArgumentCompleter -CommandName $AsAServiceAccessLocationsFunctions -ParameterName Location -ScriptBlock $Arg_AsAService_AccessLocations