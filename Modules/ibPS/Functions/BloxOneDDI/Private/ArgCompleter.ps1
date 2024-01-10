$products = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Query-CSP GET "$(Get-B1CSPUrl)/apidoc/docs/list/products") | Where-Object {
        $_.title -like "$wordToComplete*"
    } | ForEach-Object {
          "`'$($_.Title)`'"
    }
}
Register-ArgumentCompleter -CommandName Get-B1Object,Get-B1Schema -ParameterName Product -ScriptBlock $products

$apps = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
    $Products = Query-CSP GET "$(Get-B1CSPUrl)/apidoc/docs/list/products"

    ($Products | Where-Object {$_.title -eq $($fakeBoundParameters['Product'])} | Select-Object -ExpandProperty apps) | Where-Object {$_.app -like "$wordToComplete*"} | ForEach-Object {$_.app}
}
Register-ArgumentCompleter -CommandName Get-B1Object,Get-B1Schema -ParameterName App -ScriptBlock $apps

$endpoints = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (((Query-CSP GET "$(Get-B1CSPUrl)/apidoc/docs/$($fakeBoundParameters['App'])").paths).psobject.properties | ForEach-Object -begin {$h=@{}} -process {$h."$($_.Name)" = $_.Value} -end {$h}).GetEnumerator() | Where-Object {$_.Name -like "$wordToComplete*"} | ForEach-Object {$_.Name}
}
Register-ArgumentCompleter -CommandName Get-B1Object,Get-B1Schema -ParameterName Endpoint -ScriptBlock $endpoints
