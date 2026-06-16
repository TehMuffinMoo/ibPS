[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
param()

$Arg_ServiceLogApplications = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1ServiceLogApplications | Where-Object {$_.label -like "$($wordToComplete)*"}).label
}
Register-ArgumentCompleter -CommandName Get-B1ServiceLog -ParameterName Container -ScriptBlock $Arg_ServiceLogApplications