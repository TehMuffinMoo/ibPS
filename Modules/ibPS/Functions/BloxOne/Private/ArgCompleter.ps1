$products = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Query-CSP GET "$(Get-B1CSPUrl)/apidoc/docs/list/products") | Where-Object {
        $_.title -like "$wordToComplete*"
    } | ForEach-Object {
          "`'$($_.Title)`'"
    }
}
Register-ArgumentCompleter -CommandName Get-B1Object,Get-B1Schema,New-B1Object -ParameterName Product -ScriptBlock $products

$apps = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
    $Products = Query-CSP GET "$(Get-B1CSPUrl)/apidoc/docs/list/products"

    ($Products | Where-Object {$_.title -eq $($fakeBoundParameters['Product'])} | Select-Object -ExpandProperty apps) | Where-Object {$_.app -like "$wordToComplete*"} | ForEach-Object {$_.app}
}
Register-ArgumentCompleter -CommandName Get-B1Object,Get-B1Schema,New-B1Object -ParameterName App -ScriptBlock $apps

$endpoints = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (((Query-CSP GET "$(Get-B1CSPUrl)/apidoc/docs/$($fakeBoundParameters['App'])").paths).psobject.properties | ForEach-Object -begin {$h=@{}} -process {$h."$($_.Name)" = $_.Value} -end {$h}).GetEnumerator() | Where-Object {$_.Name -like "$wordToComplete*"} | ForEach-Object {$_.Name}
}
Register-ArgumentCompleter -CommandName Get-B1Object,Get-B1Schema,New-B1Object -ParameterName Endpoint -ScriptBlock $endpoints

$applications = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-B1Applications | Where-Object {$_ -like "$wordToComplete*"}
}
Register-ArgumentCompleter -CommandName Get-B1Service,New-B1Service -ParameterName Type -ScriptBlock $applications

$LookalikeCandidates = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    switch($commandName) {
        "Enable-B1TDLookalikeTargetCandidate" {
            (Get-B1TDLookalikeTargetCandidates | Select-Object -ExpandProperty items_described | Where-Object {$_.item -like "$($wordToComplete)*" -and $_.selected -eq "True"}) | Select-Object -ExpandProperty item
        }
        "Disable-B1TDLookalikeTargetCandidate" {
            (Get-B1TDLookalikeTargetCandidates | Select-Object -ExpandProperty items_described | Where-Object {$_.item -like "$($wordToComplete)*" -and $_.selected -ne "True"}) | Select-Object -ExpandProperty item
        }
    }
}
Register-ArgumentCompleter -CommandName Enable-B1TDLookalikeTargetCandidate,Disable-B1TDLookalikeTargetCandidate -ParameterName Domain -ScriptBlock $LookalikeCandidates