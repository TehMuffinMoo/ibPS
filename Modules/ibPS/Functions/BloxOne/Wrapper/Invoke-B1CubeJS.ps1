function Invoke-B1CubeJS {
    <#
    .SYNOPSIS
    .DESCRIPTION

    .PARAMETER Cube
    .PARAMETER Measures
    .PARAMETER Dimensions
    .PARAMETER Segments
    .PARAMETER AllDimensions
    .PARAMETER Filters
    .PARAMETER Limit
    .PARAMETER Offset

    .PARAMETER OrderBy
        The field in which to order the results by. This field supports auto-complete, and defaults to timestamp.

    .PARAMETER Order
        The direction to order results in. This defaults to ascending.

    .PARAMETER TimeDimension
    .PARAMETER Start
    .PARAMETER End
    .PARAMETER Granularity
    .PARAMETER Grouped
    .PARAMETER Raw

    .EXAMPLE
    .EXAMPLE

    .FUNCTIONALITY
        CubeJS

    .FUNCTIONALITY
        BloxOne Threat Defense

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Logs
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [String]$Cube,
        [String[]]$Measures,
        [String[]]$Dimensions,
        [String[]]$Segments,
        [Switch]$AllDimensions,
        [System.Object]$Filters,
        [Int]$Limit,
        [Int]$Offset,
        [String]$OrderBy,
        [ValidateSet('asc','desc')]
        [String]$Order,
        [Parameter(
            Mandatory=$true,
            ParameterSetName='TimeDimension'
        )]
        [String]$TimeDimension,
        [Parameter(
            Mandatory=$true,
            ParameterSetName='TimeDimension'
        )]
        [datetime]$Start,
        [Parameter(
            ParameterSetName='TimeDimension'
        )]
        [datetime]$End,
        [Parameter(
            ParameterSetName='TimeDimension'
        )]
        [String]$Granularity,
        [Switch]$Grouped,
        [Switch]$Raw
    )

    if ($Start) {
        $Start = $Start.ToUniversalTime()
        $StartDate = $Start.ToString("yyyy-MM-ddTHH:mm:ss.000")
    }
    if ($Start -or $End) {
        if (-not $End) {
            $End = Get-Date
        }
        $End = $End.ToUniversalTime()
        $EndDate = $End.ToString("yyyy-MM-ddTHH:mm:ss.000")
    }

    $splat = @{
        "measures" = @()
        "dimensions" = @()
        "segments" = @()
        "ungrouped" = $(if ($Grouped) { $False } else { $True })
    }

    if ($Limit) {
        $splat.limit = $Limit
    }
    if ($Offset) {
        $splat.offset = $Offset
    }

    if ($Measures) {
        $splat.Measures = @($(
            $Measures | %{
                "$($Cube).$($_)"
            }
        ))
    }

    if ($OrderBy) {
        if (-not $Order) {
            $Order = 'asc'
        }
        $splat.order = @{
            "$($Cube).$($OrderBy)" = "$($Order)"
        }
    }

    if ($Dimensions -or $AllDimensions) {
        if ($AllDimensions) {
            $splat.Dimensions = @((Get-B1CubeJSDimensions -Cube $Cube).Name)
        } else {
            $splat.Dimensions = @($(
                $Dimensions | %{
                    "$($Cube).$($_)"
                }
            ))
        }
    }

    if ($Segments) {
        $splat.segments = @($(
            $Segments | %{
                "$($Cube).$($_)"
            }
        ))
    }

    if ($Filters) {
        $splat.filters = @($Filters)
    }

    if ($TimeDimension) {
        $splat.timeDimensions = @(
            @{
                "dimension" = "$($Cube).$($TimeDimension)"
                "dateRange" = @(
                    $StartDate
                    $EndDate
                )
                "granularity" = $(if ($Granularity) {$Granularity} else {$null})
            }
        )
    }
    $Data = $splat | ConvertTo-Json -Depth 4 -Compress
    $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
    Write-DebugMsg -Query $($splat | ConvertTo-Json -Depth 4)
    $Result = Invoke-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/query?query=$Query"
    if ($Result) {
        if (-not $Raw) {
            if ($Result.result.data) {
                $ReturnProperties = @{
                    Property = @()
                }
                $Result.result.data[0].PSObject.Properties | %{
                    $ReturnProperties.Property += @{n=$($_.Name.Replace("$($Cube).",""));e=$([ScriptBlock]::Create("`$`_.`'$($($_.Name))`'"))}
                }
                return $Result.result.data | Select-Object @ReturnProperties
            } else {
                Write-Host "Query returned no data." -ForegroundColor Yellow
            }
        } else {
            return $Result.result
        }
    }
}