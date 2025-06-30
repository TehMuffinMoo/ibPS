function Get-B1CubeJSCubes {
    param(
        [String]$Cube
    )
    $Context = (Get-B1Context).CurrentContext
    if (-not $Script:B1CubeCache) {
        $Script:B1CubeCache = @{}
    }
    if (-not $Script:B1CubeCache."$($Context)") {
        $Script:B1CubeCache."$($Context)" = Invoke-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/meta" | Select-Object -ExpandProperty result | Select-Object -ExpandProperty cubes
    }
    if ($Cube) {
        $Result = $Script:B1CubeCache."$($Context)" | Where-Object {$_.name -eq $Cube}
        if ($Result) {
            return $Result
        } else {
            Write-Error "Unable to find Cube with name: $($Cube)"
            return $null
        }
    } else {
        return $Script:B1CubeCache."$($Context)"
    }
}

function Get-B1CubeJSMeasures {
    param(
        [Parameter(Mandatory=$true)]
        [String]$Cube
    )
    $CubeResult = Get-B1CubeJSCubes -Cube $Cube
    return $CubeResult.measures
}

function Get-B1CubeJSSegments {
    param(
        [Parameter(Mandatory=$true)]
        [String]$Cube
    )
    $CubeResult = Get-B1CubeJSCubes -Cube $Cube
    return $CubeResult.segments
}

function Get-B1CubeJSDimensions {
    param(
        [Parameter(Mandatory=$true)]
        [String]$Cube
    )
    $CubeResult = Get-B1CubeJSCubes -Cube $Cube
    return $CubeResult.dimensions
}