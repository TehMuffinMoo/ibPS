$B1FederatedHosts = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1Host -tfilter '"host/federation"==true' -Name $wordToComplete).display_name
}
Register-ArgumentCompleter -CommandName Invoke-NIOS,Get-NIOSSchema,Get-NIOSObject -ParameterName GridName -ScriptBlock $B1FederatedHosts

$SchemaObjectType = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $InvokeOpts = Initialize-NIOSOpts $fakeBoundParameters
    (Get-NIOSSchema @InvokeOpts).supported_objects | Where-Object {$_ -like "$wordToComplete*"}
}
Register-ArgumentCompleter -CommandName Get-NIOSSchema,Get-NIOSObject -ParameterName ObjectType -ScriptBlock $SchemaObjectType