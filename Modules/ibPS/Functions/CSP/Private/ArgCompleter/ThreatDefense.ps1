[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
param()

$Arg_TD_ExternalNetworks = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1NetworkList -Name $($wordToComplete) | Where-Object {$_.name -like "$($wordToComplete)*"}).name
}
Register-ArgumentCompleter -CommandName New-B1SecurityPolicy,Set-B1SecurityPolicy -ParameterName ExternalNetworks -ScriptBlock $Arg_TD_ExternalNetworks

$Arg_TD_LookalikeTargetCandidates = {
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
Register-ArgumentCompleter -CommandName Enable-B1LookalikeTargetCandidate,Disable-B1LookalikeTargetCandidate -ParameterName Domain -ScriptBlock $Arg_TD_LookalikeTargetCandidates

$Arg_TD_TideSources = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $ReturnSources = @()
    $Sources = Get-B1DossierSupportedSources -Target $($fakeBoundParameters.Type)
    $Sources.PSObject.Properties.Name | ForEach-Object {
        if (($Sources."$($_)") -eq $True) {
            $ReturnSources += $_
        }
    }
    return $ReturnSources | Where-Object {$_ -like "$($wordToComplete)*"}
}
Register-ArgumentCompleter -CommandName Start-B1DossierLookup -ParameterName Source -ScriptBlock $Arg_TD_TideSources

$Arg_TD_TideThreatClass = {
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
Register-ArgumentCompleter -CommandName Get-B1DNSEvent,Submit-B1TideData -ParameterName ThreatClass -ScriptBlock $Arg_TD_TideThreatClass

$Arg_TD_TideThreatProperty = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1TideThreatProperty | Where-Object {$_.name -like "$($wordToComplete)*"}).name
}
Register-ArgumentCompleter -CommandName Get-B1DNSEvent,Submit-B1TideData -ParameterName ThreatProperty -ScriptBlock $Arg_TD_TideThreatProperty

$Arg_TD_TideDataProfile = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1TideDataProfile | Where-Object {$_.name -like "$($wordToComplete)*"}).name
}
Register-ArgumentCompleter -CommandName Submit-B1TideData -ParameterName Profile -ScriptBlock $Arg_TD_TideDataProfile
Register-ArgumentCompleter -CommandName Get-B1TideDataProfile -ParameterName Name -ScriptBlock $Arg_TD_TideDataProfile

$Arg_TD_SecurityPolicyRuleFilter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    switch($fakeBoundParameters['Type']) {
        "Custom" {
            (Get-B1CustomList | Where-Object {$_.name -like "$($wordToComplete)*"}).name
        }
        "Feed" {
            (Get-B1ThreatFeeds | Where-Object {$_.key -like "$($wordToComplete)*"}).key
        }
        "Application" {
            (Get-B1ApplicationFilter -Name $wordToComplete | Where-Object {$_.name -like "$($wordToComplete)*"}).name
        }
        "Category" {
            (Get-B1CategoryFilter -Name $wordToComplete | Where-Object {$_.name -like "$($wordToComplete)*"}).name
        }
    }
}
Register-ArgumentCompleter -CommandName New-B1SecurityPolicyRule -ParameterName Object -ScriptBlock $Arg_TD_SecurityPolicyRuleFilter

$Arg_TD_DFPServices = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1Service -Type dfp -Name $($wordToComplete) | Where-Object {$_.name -like "$($wordToComplete)*"}).name
}
Register-ArgumentCompleter -CommandName New-B1SecurityPolicy,Set-B1SecurityPolicy -ParameterName DFPs -ScriptBlock $Arg_TD_DFPServices