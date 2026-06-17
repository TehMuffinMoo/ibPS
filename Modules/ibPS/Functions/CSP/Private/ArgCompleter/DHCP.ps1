[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
param()

$Arg_DHCP_HAGroups = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1HAGroup -Name $wordToComplete).name
}
Register-ArgumentCompleter -CommandName Get-B1HAGroup,Set-B1HAGroup,Remove-B1HAGroup -ParameterName Name -ScriptBlock $Arg_DHCP_HAGroups

$Arg_DHCP_Hosts = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1DHCPHost -Name $wordToComplete).name
}
Register-ArgumentCompleter -CommandName New-B1HAGroup,Set-B1HAGroup -ParameterName PrimaryNode -ScriptBlock $Arg_DHCP_Hosts
Register-ArgumentCompleter -CommandName New-B1HAGroup,Set-B1HAGroup -ParameterName SecondaryNode -ScriptBlock $Arg_DHCP_Hosts
Register-ArgumentCompleter -CommandName Get-B1DHCPLog,Get-B1DHCPLease -ParameterName DHCPServer -ScriptBlock $Arg_DHCP_Hosts