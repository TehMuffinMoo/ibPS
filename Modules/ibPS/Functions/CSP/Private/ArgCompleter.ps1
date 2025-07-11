[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
param()

$products = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-B1Schema -Quiet | Where-Object {
        $_ -like "$wordToComplete*"
    } | ForEach-Object {
          "`'$($_)`'"
    }
}
Register-ArgumentCompleter -CommandName Get-B1Object,Get-B1Schema,New-B1Object -ParameterName Product -ScriptBlock $products

$apps = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    (Get-B1Schema -Quiet -Product $fakeBoundParameters['Product']).app | Where-Object {
        $_ -like "$wordToComplete*"
    } | ForEach-Object {$_}
}
Register-ArgumentCompleter -CommandName Get-B1Object,Get-B1Schema,New-B1Object -ParameterName App -ScriptBlock $apps

$endpoints = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    (Get-B1Schema -Quiet -Product $fakeBoundParameters['Product'] -App $fakeBoundParameters['App']).Endpoint | Where-Object {
        $_ -like "$wordToComplete*"
    } | ForEach-Object {$_}
}
Register-ArgumentCompleter -CommandName Get-B1Object,Get-B1Schema,New-B1Object -ParameterName Endpoint -ScriptBlock $endpoints

$applications = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-B1Applications | Where-Object {$_ -like "$wordToComplete*"}
}
Register-ArgumentCompleter -CommandName Get-B1Service,New-B1Service -ParameterName Type -ScriptBlock $applications

$B1Accounts = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    if (!$ENV:B1Bearer) {
        Write-Host "`nYou must be connected to a BloxOne account before switching accounts. Please use Connect-B1Account first." -ForegroundColor Red
        return
    }
    (Get-B1CSPCurrentUser -Accounts | Where-Object {$_.name -like "$wordToComplete*"}).name
}
Register-ArgumentCompleter -CommandName Switch-B1Account -ParameterName Name -ScriptBlock $B1Accounts

$B1TDSecurityPolicyRuleFilter = {
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
Register-ArgumentCompleter -CommandName New-B1SecurityPolicyRule -ParameterName Object -ScriptBlock $B1TDSecurityPolicyRuleFilter

$B1DFPServices = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1Service -Type dfp -Name $($wordToComplete) | Where-Object {$_.name -like "$($wordToComplete)*"}).name
}
Register-ArgumentCompleter -CommandName New-B1SecurityPolicy,Set-B1SecurityPolicy -ParameterName DFPs -ScriptBlock $B1DFPServices

$B1TDExternalNetworks = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1NetworkList -Name $($wordToComplete) | Where-Object {$_.name -like "$($wordToComplete)*"}).name
}
Register-ArgumentCompleter -CommandName New-B1SecurityPolicy,Set-B1SecurityPolicy -ParameterName ExternalNetworks -ScriptBlock $B1TDExternalNetworks

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

$B1TDTideSources = {
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
Register-ArgumentCompleter -CommandName Start-B1DossierLookup -ParameterName Source -ScriptBlock $B1TDTideSources

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

$B1DDIDTCServers = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1DTCServer -Name $wordToComplete).name | Where-Object {$_ -notin $fakeBoundParameters['Servers']}
}
Register-ArgumentCompleter -CommandName New-B1DTCPool -ParameterName Servers -ScriptBlock $B1DDIDTCServers

$B1DDIDTCHealthChecks = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1DTCHealthCheck -Name $wordToComplete).name | Where-Object {$_ -notin $fakeBoundParameters['HealthChecks']}
}
Register-ArgumentCompleter -CommandName New-B1DTCPool -ParameterName HealthChecks -ScriptBlock $B1DDIDTCHealthChecks

$B1DDIDTCPolicies = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1DTCPolicy -Name $wordToComplete).name | Where-Object {$_ -notin $fakeBoundParameters['Policy']}
}
Register-ArgumentCompleter -CommandName New-B1DTCLBDN -ParameterName Policy -ScriptBlock $B1DDIDTCPolicies

$B1DDIDTCPools = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1DTCPool -Name $wordToComplete).name | Where-Object {$_ -notin $fakeBoundParameters['Pools']}
}
Register-ArgumentCompleter -CommandName New-B1DTCPolicy -ParameterName Pools -ScriptBlock $B1DDIDTCPools
Register-ArgumentCompleter -CommandName New-B1DTCTopologyRule -ParameterName Pool -ScriptBlock $B1DDIDTCPools

$B1Compartments = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1Compartment -Name $wordToComplete).name
}
$B1CompartmentFunctions = @(
    'Get-B1Range'
    'Get-B1Subnet'
    'Get-B1AddressBlock'
    'New-B1AddressBlock'
    'Set-B1AddressBlock'
    'Get-B1AuthoritativeZone'
    'New-B1AuthoritativeZone'
    'Set-B1AuthoritativeZone'
    'Get-B1ForwardZone'
    'Get-B1Record'
    'Get-B1Address'
    'New-B1Space'
)
Register-ArgumentCompleter -CommandName $B1CompartmentFunctions -ParameterName Compartment -ScriptBlock $B1Compartments

$B1ConnectionProfiles = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1ConnectionProfile -List | Where-Object {$_.Name -like "$($wordToComplete)*"}).Name
}
Register-ArgumentCompleter -CommandName Get-B1ConnectionProfile,Set-B1ConnectionProfile,Switch-B1ConnectionProfile,Remove-B1ConnectionProfile -ParameterName Name -ScriptBlock $B1ConnectionProfiles
Register-ArgumentCompleter -CommandName Invoke-CSP -ParameterName ProfileName -ScriptBlock $B1ConnectionProfiles

$B1CubeJSCubes = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1CubeJSCubes | Where-Object {$_.name -like "$($wordToComplete)*"}).Name
}
Register-ArgumentCompleter -CommandName Invoke-B1CubeJS,Get-B1CubeJSCubes,Get-B1CubeJSMeasures,Get-B1CubeJSDimensions -ParameterName Cube -ScriptBlock $B1CubeJSCubes

$B1CubeJSMeasures = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1CubeJSMeasures -Cube $fakeBoundParameters['Cube']).Name | ForEach-Object {
        $_.replace("$($fakeBoundParameters['Cube']).","")
    } | Where-Object {$_ -like "$($wordToComplete)*" -and $_ -notin @($fakeBoundParameters['Measures'])}
}
Register-ArgumentCompleter -CommandName Invoke-B1CubeJS -ParameterName Measures -ScriptBlock $B1CubeJSMeasures

$B1CubeJSDimensions = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1CubeJSDimensions -Cube $fakeBoundParameters['Cube']).Name | ForEach-Object {
        $_.replace("$($fakeBoundParameters['Cube']).","")
    } | Where-Object {$_ -like "$($wordToComplete)*" -and $_ -notin @($fakeBoundParameters['Dimensions'])}
}
Register-ArgumentCompleter -CommandName Invoke-B1CubeJS -ParameterName Dimensions -ScriptBlock $B1CubeJSDimensions

$B1CubeJSSegments = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1CubeJSSegments -Cube $fakeBoundParameters['Cube']).Name | ForEach-Object {
        $_.replace("$($fakeBoundParameters['Cube']).","")
    } | Where-Object {$_ -like "$($wordToComplete)*" -and $_ -notin @($fakeBoundParameters['Segments'])}
}
Register-ArgumentCompleter -CommandName Invoke-B1CubeJS -ParameterName Segments -ScriptBlock $B1CubeJSSegments

$B1CubeJSOrderBy = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Switch($commandName) {
        'Get-B1DFPLog' {
            $fakeBoundParameters['Cube'] = 'PortunusDnsLogs'
        }
        'Get-B1DHCPLog' {
            $fakeBoundParameters['Cube'] = 'NstarLeaseActivity'
        }
        'Get-B1DNSLog' {
            $fakeBoundParameters['Cube'] = 'NstarDnsActivity'
        }
    }
    $Dimensions = (Get-B1CubeJSDimensions -Cube $fakeBoundParameters['Cube']).Name | ForEach-Object {
        $_.replace("$($fakeBoundParameters['Cube']).","")
    } | Where-Object {$_ -like "$($wordToComplete)*" -and $_ -notin @($fakeBoundParameters['OrderBy'])}

    $Measures = (Get-B1CubeJSMeasures -Cube $fakeBoundParameters['Cube']).Name | ForEach-Object {
        $_.replace("$($fakeBoundParameters['Cube']).","")
    } | Where-Object {$_ -like "$($wordToComplete)*" -and $_ -notin @($fakeBoundParameters['Measures'])}

    return $Dimensions + $Measures
}
Register-ArgumentCompleter -CommandName Invoke-B1CubeJS,Get-B1DFPLog -ParameterName OrderBy -ScriptBlock $B1CubeJSOrderBy

$B1CubeJSTimeDimensions = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    ((Get-B1CubeJSDimensions -Cube $fakeBoundParameters['Cube']) | Where-Object {$_.type -eq 'time'}).Name | ForEach-Object {
        $_.replace("$($fakeBoundParameters['Cube']).","")
    }  | Where-Object {$_ -like "$($wordToComplete)*" -and $_ -notin @($fakeBoundParameters['TimeDimension'])}
}
Register-ArgumentCompleter -CommandName Invoke-B1CubeJS -ParameterName TimeDimension -ScriptBlock $B1CubeJSTimeDimensions

$AsAServiceServices = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1AsAServiceServices | Where-Object {$_.name -like "$wordToComplete*"}).name
}
Register-ArgumentCompleter -CommandName Get-B1AsAServiceServiceStatus,Get-B1AASServiceStatus,Get-B1AsAServiceDeployments,Get-B1AASDeployments,Get-B1AsAServiceConfigChanges,Get-B1AASConfigChanges,Get-B1AsAServiceCapabilities,Get-B1AASCapabilities,Get-B1AsAServiceTunnels,Get-B1AASTunnels -ParameterName Service -ScriptBlock $AsAServiceServices

$AsAServiceAccessLocations = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    if (-not $fakeBoundParameters['Service']) {
        Write-Host "`nService parameter is required when specifying a location." -ForegroundColor Red
        return
    }
    (Get-B1AsAServiceServiceStatus -Service $fakeBoundParameters['Service'] | Where-Object {$_.access_location_name -like "$wordToComplete*"}).access_location_name
}
Register-ArgumentCompleter -CommandName Get-B1AsAServiceConfigChanges,Get-B1AASConfigChanges,Get-B1AsAServiceDeployments,Get-B1AASDeployments,Get-B1AsAServiceTunnels,Get-B1AASTunnels -ParameterName Location -ScriptBlock $AsAServiceAccessLocations