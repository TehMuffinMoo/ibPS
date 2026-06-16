[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]

$Arg_DNS_RecordTypes = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    @("A","AAAA","ALIAS","CAA","CNAME","DNAME","HTTPS","MX","NAPTR","NS","PTR","SRV","SVCB","TXT","SOA") | Where-Object {$_ -like "$wordToComplete*"}
}
Register-ArgumentCompleter -CommandName Get-B1Record,Set-B1Record,New-B1Record,Remove-B1Record -ParameterName Type -ScriptBlock $Arg_DNS_RecordTypes

## --------------- ##
## ----- DTC ----- ##
## --------------- ##
$Arg_DTC_Servers = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1DTCServer -Name $wordToComplete).name | Where-Object {$_ -notin $fakeBoundParameters['Servers']}
}
Register-ArgumentCompleter -CommandName New-B1DTCPool -ParameterName Servers -ScriptBlock $Arg_DTC_Servers

$Arg_DTC_HealthChecks = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1DTCHealthCheck -Name $wordToComplete).name | Where-Object {$_ -notin $fakeBoundParameters['HealthChecks']}
}
Register-ArgumentCompleter -CommandName New-B1DTCPool -ParameterName HealthChecks -ScriptBlock $Arg_DTC_HealthChecks

$Arg_DTC_Policies = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1DTCPolicy -Name $wordToComplete).name | Where-Object {$_ -notin $fakeBoundParameters['Policy']}
}
Register-ArgumentCompleter -CommandName New-B1DTCLBDN -ParameterName Policy -ScriptBlock $Arg_DTC_Policies

$Arg_DTC_Pools = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1DTCPool -Name $wordToComplete).name | Where-Object {$_ -notin $fakeBoundParameters['Pools']}
}
Register-ArgumentCompleter -CommandName New-B1DTCPolicy -ParameterName Pools -ScriptBlock $Arg_DTC_Pools
Register-ArgumentCompleter -CommandName New-B1DTCTopologyRule -ParameterName Pool -ScriptBlock $Arg_DTC_Pools