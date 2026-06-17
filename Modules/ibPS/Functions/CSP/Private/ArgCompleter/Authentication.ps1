[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
param()
## --------------- ##
## ----- JWT ----- ##
## --------------- ##

$Arg_JWT_Accounts = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    if (!$Script:AuthManager) {
        Write-Host "`nYou must be connected to the Infoblox Portal before switching accounts. Please use Connect-B1Account first." -ForegroundColor Red
        return
    }
    (Get-B1CSPCurrentUser -Accounts | Where-Object {$_.name -like "$wordToComplete*"}).name
}
Register-ArgumentCompleter -CommandName Switch-B1Account -ParameterName Name -ScriptBlock $Arg_JWT_Accounts

## --------------- ##
## ----- API ----- ##
## --------------- ##
$Arg_Connection_Profiles = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1ConnectionProfile -List | Where-Object {$_.Name -like "$($wordToComplete)*"}).Name
}
Register-ArgumentCompleter -CommandName Get-B1ConnectionProfile,Set-B1ConnectionProfile,Switch-B1ConnectionProfile,Remove-B1ConnectionProfile -ParameterName Name -ScriptBlock $Arg_Connection_Profiles
Register-ArgumentCompleter -CommandName Invoke-CSP -ParameterName ProfileName -ScriptBlock $Arg_Connection_Profiles

## --------------------------- ##
## Compartments (Access Views) ##
## --------------------------- ##
$Arg_Compartments = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1Compartment -Name $wordToComplete).name
}
$B1CompartmentFunctions = @(
    'Get-B1Range'
    'Get-B1Subnet'
    'Get-B1AddressBlock'
    'New-B1AddressBlock'
    'Set-B1AddressBlock'
    'Get-B1AuthoritativeZone'
    'New-B1AuthoritativeZone'
    'Set-B1AuthoritativeZone'
    'Get-B1ForwardZone'
    'Get-B1Record'
    'Get-B1Address'
    'New-B1Space'
)
Register-ArgumentCompleter -CommandName $B1CompartmentFunctions -ParameterName Compartment -ScriptBlock $Arg_Compartments
Register-ArgumentCompleter -CommandName Get-B1Compartment -ParameterName Name -ScriptBlock $Arg_Compartments