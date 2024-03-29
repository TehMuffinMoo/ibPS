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

$B1TDLookalikeTargetCandidates = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    switch($commandName) {
        "Enable-B1LookalikeTargetCandidate" {
            (Get-B1LookalikeTargetCandidates | Select-Object -ExpandProperty items_described | Where-Object {$_.item -like "$($wordToComplete)*" -and $_.selected -ne "True"}) | Select-Object -ExpandProperty item
        }
        "Disable-B1LookalikeTargetCandidate" {
            (Get-B1LookalikeTargetCandidates | Select-Object -ExpandProperty items_described | Where-Object {$_.item -like "$($wordToComplete)*" -and $_.selected -eq "True"}) | Select-Object -ExpandProperty item
        }
    }
}
Register-ArgumentCompleter -CommandName Enable-B1LookalikeTargetCandidate,Disable-B1LookalikeTargetCandidate -ParameterName Domain -ScriptBlock $B1TDLookalikeTargetCandidates

$B1TDTideThreatClass = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    [System.Collections.ArrayList]$ReturnArr = @()
    if ($TideClasses = (Get-B1TideThreatClass | Where-Object {$_.id -like "$($wordToComplete)*"}).id) {
        $ReturnArr += $TideClasses
    }
    if ($ThreatInsightClasses = (Get-B1TideThreatInsightClass | Where-Object {$_.class -like "$($wordToComplete)*"}).class) {
        $ReturnArr += $ThreatInsightClasses
    }
    return $ReturnArr
}
Register-ArgumentCompleter -CommandName Get-B1DNSEvent,Submit-B1TideData -ParameterName ThreatClass -ScriptBlock $B1TDTideThreatClass

$B1TDTideThreatProperty = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1TideThreatProperty | Where-Object {$_.name -like "$($wordToComplete)*"}).name
}
Register-ArgumentCompleter -CommandName Get-B1DNSEvent,Submit-B1TideData -ParameterName ThreatProperty -ScriptBlock $B1TDTideThreatProperty

$B1TDTideDataProfile = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1TideDataProfile | Where-Object {$_.name -like "$($wordToComplete)*"}).name
}
Register-ArgumentCompleter -CommandName Submit-B1TideData -ParameterName Profile -ScriptBlock $B1TDTideDataProfile
Register-ArgumentCompleter -CommandName Get-B1TideDataProfile -ParameterName Name -ScriptBlock $B1TDTideDataProfile

$ServiceLogApplications = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1ServiceLogApplications | Where-Object {$_.label -like "$($wordToComplete)*"}).label
    
}
Register-ArgumentCompleter -CommandName Get-B1ServiceLog -ParameterName Container -ScriptBlock $ServiceLogApplications