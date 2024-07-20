[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
param()

$B1FederatedHosts = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1Host -tfilter '"host/federation"==true' -Name $wordToComplete).display_name
}
Register-ArgumentCompleter -CommandName Invoke-NIOS,Get-NIOSSchema,Get-NIOSObject,Set-NIOSConnectionProfile -ParameterName GridName -ScriptBlock $B1FederatedHosts

$SchemaObjectType = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $InvokeOpts = Initialize-NIOSOpts $fakeBoundParameters
    (Get-NIOSSchema @InvokeOpts).supported_objects | Where-Object {$_ -like "$wordToComplete*"}
}
Register-ArgumentCompleter -CommandName Get-NIOSSchema,Get-NIOSObject,New-NIOSObject -ParameterName ObjectType -ScriptBlock $SchemaObjectType

$AvailableReturnFields = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $InvokeOpts = Initialize-NIOSOpts $fakeBoundParameters
    if ($fakeBoundParameters.ObjectType) {
        $ObjectType = $fakeBoundParameters.ObjectType
    } elseif ($fakeBoundParameters.ObjectRef) {
        $ObjectType = ($fakeBoundParameters.ObjectRef -split '/')[0]
    }
    (Get-NIOSSchema @InvokeOpts -ObjectType $ObjectType -Fields -Method GET).name | Where-Object {$_ -like "$wordToComplete*"}
}
Register-ArgumentCompleter -CommandName Get-NIOSObject,Set-NIOSObject,New-NIOSObject -ParameterName Fields -ScriptBlock $AvailableReturnFields

$NIOSConnectionProfiles = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-NIOSConnectionProfile -List | Where-Object {$_.Name -like "$($wordToComplete)*"}).Name
}
Register-ArgumentCompleter -CommandName Get-NIOSConnectionProfile,Set-NIOSConnectionProfile,Switch-NIOSConnectionProfile,Remove-NIOSConnectionProfile -ParameterName Name -ScriptBlock $NIOSConnectionProfiles