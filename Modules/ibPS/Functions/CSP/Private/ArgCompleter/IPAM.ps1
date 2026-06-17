[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
param()

$Arg_IPAM_IPSpaces = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    ((Get-B1Space) | Where-Object {$_.name -like "$wordToComplete*"}).name
}
$IPAM_IPSpaces_Functions = @(
    'Get-B1Host'
    'New-B1Host'
    'Set-B1Host'
    'Get-B1Address'
    'Get-B1AddressBlock'
    'Get-B1AddressBlockNextAvailable'
    'Get-B1DHCPLease'
    'Get-B1DNSUsage'
    'Get-B1FixedAddress'
    'Get-B1Range'
    'Get-B1Subnet'
    'Get-B1SubnetNextAvailable'
    'New-B1AddressBlock'
    'New-B1AddressReservation'
    'New-B1DNSView'
    'New-B1FixedAddress'
    'New-B1Range'
    'New-B1Subnet'
    'Remove-B1AddressBlock'
    'Remove-B1AddressReservation'
    'Remove-B1FixedAddress'
    'Remove-B1Range'
    'Remove-B1Subnet'
    'Set-B1AddressBlock'
    'Set-B1FixedAddress'
    'Set-B1Range'
    'Set-B1Subnet'
)
Register-ArgumentCompleter -CommandName $IPAM_IPSpaces_Functions -ParameterName Space -ScriptBlock $Arg_IPAM_IPSpaces
Register-ArgumentCompleter -CommandName 'Get-B1Space' -ParameterName Name -ScriptBlock $Arg_IPAM_IPSpaces