$B1FederatedHosts = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1Host -tfilter '"host/federation"==true' -Name $wordToComplete).display_name
}
Register-ArgumentCompleter -CommandName Invoke-NIOS,Get-NIOSSchema,Get-NIOSObject,Select-FederatedGrid -ParameterName GridName -ScriptBlock $B1FederatedHosts

$SchemaObjectType = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $InvokeOpts = Initialize-NIOSOpts $fakeBoundParameters
    (Get-NIOSSchema @InvokeOpts).supported_objects | Where-Object {$_ -like "$wordToComplete*"}
}
Register-ArgumentCompleter -CommandName Get-NIOSSchema,Get-NIOSObject -ParameterName ObjectType -ScriptBlock $SchemaObjectType

$AvailableFields = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $InvokeOpts = Initialize-NIOSOpts $fakeBoundParameters
    Switch($commandName) {
        'Get-NIOSObject' {
            $Method = 'GET'
        }
        'Set-NIOSObject' {
            $Method = 'PATCH'
        }
        'Remove-NIOSObject' {
            $Method = 'DELETE'
        }
        'New-NIOSObject' {
            $Method = 'POST'
        }
    }
    if ($fakeBoundParameters.ObjectType) {
        $ObjectType = $fakeBoundParameters.ObjectType
    } elseif ($fakeBoundParameters.ObjectRef) {
        $ObjectType = ($fakeBoundParameters.ObjectRef -split '/')[0]
    }
    (Get-NIOSSchema @InvokeOpts -ObjectType $ObjectType -Fields -Method $Method).name | Where-Object {$_ -like "$wordToComplete*"}
}
Register-ArgumentCompleter -CommandName Get-NIOSObject -ParameterName Fields -ScriptBlock $AvailableFields