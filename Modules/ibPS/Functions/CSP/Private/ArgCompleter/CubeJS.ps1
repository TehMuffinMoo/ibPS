[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]

$Arg_CubeJS_Products = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-B1Schema -Quiet | Where-Object {
        $_ -like "$wordToComplete*"
    } | ForEach-Object {
          "`'$($_)`'"
    }
}
Register-ArgumentCompleter -CommandName Get-B1Object,Get-B1Schema,New-B1Object -ParameterName Product -ScriptBlock $Arg_CubeJS_Products

$Arg_CubeJS_Apps = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    (Get-B1Schema -Quiet -Product $fakeBoundParameters['Product']).app | Where-Object {
        $_ -like "$wordToComplete*"
    } | ForEach-Object {$_}
}
Register-ArgumentCompleter -CommandName Get-B1Object,Get-B1Schema,New-B1Object -ParameterName App -ScriptBlock $Arg_CubeJS_Apps

$Arg_CubeJS_Endpoints = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    (Get-B1Schema -Quiet -Product $fakeBoundParameters['Product'] -App $fakeBoundParameters['App']).Endpoint | Where-Object {
        $_ -like "$wordToComplete*"
    } | ForEach-Object {$_}
}
Register-ArgumentCompleter -CommandName Get-B1Object,Get-B1Schema,New-B1Object -ParameterName Endpoint -ScriptBlock $Arg_CubeJS_Endpoints

$Arg_CubeJS_Cubes = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1CubeJSCubes | Where-Object {$_.name -like "$($wordToComplete)*"}).Name
}
Register-ArgumentCompleter -CommandName Invoke-B1CubeJS,Get-B1CubeJSCubes,Get-B1CubeJSMeasures,Get-B1CubeJSDimensions -ParameterName Cube -ScriptBlock $Arg_CubeJS_Cubes

$Arg_CubeJS_Measures = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1CubeJSMeasures -Cube $fakeBoundParameters['Cube']).Name | ForEach-Object {
        $_.replace("$($fakeBoundParameters['Cube']).","")
    } | Where-Object {$_ -like "$($wordToComplete)*" -and $_ -notin @($fakeBoundParameters['Measures'])}
}
Register-ArgumentCompleter -CommandName Invoke-B1CubeJS -ParameterName Measures -ScriptBlock $Arg_CubeJS_Measures

$Arg_CubeJS_Dimensions = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1CubeJSDimensions -Cube $fakeBoundParameters['Cube']).Name | ForEach-Object {
        $_.replace("$($fakeBoundParameters['Cube']).","")
    } | Where-Object {$_ -like "$($wordToComplete)*" -and $_ -notin @($fakeBoundParameters['Dimensions'])}
}
Register-ArgumentCompleter -CommandName Invoke-B1CubeJS -ParameterName Dimensions -ScriptBlock $Arg_CubeJS_Dimensions

$Arg_CubeJS_Segments = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    (Get-B1CubeJSSegments -Cube $fakeBoundParameters['Cube']).Name | ForEach-Object {
        $_.replace("$($fakeBoundParameters['Cube']).","")
    } | Where-Object {$_ -like "$($wordToComplete)*" -and $_ -notin @($fakeBoundParameters['Segments'])}
}
Register-ArgumentCompleter -CommandName Invoke-B1CubeJS -ParameterName Segments -ScriptBlock $Arg_CubeJS_Segments

$Arg_CubeJS_OrderBy = {
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
Register-ArgumentCompleter -CommandName Invoke-B1CubeJS,Get-B1DFPLog -ParameterName OrderBy -ScriptBlock $Arg_CubeJS_OrderBy

$Arg_CubeJS_TimeDimensions = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    ((Get-B1CubeJSDimensions -Cube $fakeBoundParameters['Cube']) | Where-Object {$_.type -eq 'time'}).Name | ForEach-Object {
        $_.replace("$($fakeBoundParameters['Cube']).","")
    }  | Where-Object {$_ -like "$($wordToComplete)*" -and $_ -notin @($fakeBoundParameters['TimeDimension'])}
}
Register-ArgumentCompleter -CommandName Invoke-B1CubeJS -ParameterName TimeDimension -ScriptBlock $Arg_CubeJS_TimeDimensions