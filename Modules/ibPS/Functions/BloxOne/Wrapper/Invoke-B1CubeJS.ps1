function Invoke-B1CubeJS {
    <#
    .SYNOPSIS
        A wrapper function for interacting with the Infoblox Portal CubeJS API

    .DESCRIPTION
        This is a wrapper function used for interacting with the Infoblox Portal CubeJS APIs.

    .PARAMETER Cube
        Specify the name of the cube to query. This field supports auto/tab-completion.
        Cubes are a way to separate and organise individual tables and databases.

    .PARAMETER Measures
        Specify one or more measures. This field supports auto/tab-completion.
        Measures are referred to as quantitative data, such as number of units sold, number of unique queries, total count, etc.

    .PARAMETER Dimensions
        Specify one or more dimensions. This field supports auto/tab-completion.
        Dimensions are referred to as categorical data, such as ip address, hostname, status or timestamps.

    .PARAMETER Segments
        Specify one or more segments. This field supports auto/tab-completion.
        Segments are predefined filters, used to define complex filtering logic in SQL.

    .PARAMETER AllDimensions
        Used to attempt to return all available dimensions. This discovers a list of dimensions from the CubeJS Meta endpoint, which may not be accurate and could cause errors.

    .PARAMETER Filters
        Used to provide a list of filters.

        A filter is a JavaScript object with the following properties:

        $Filters = @(
            @{
                "member" = "NstarLeaseActivity.state"  ## Dimension or measure to be used in the filter, for example: stories.isDraft.
                "operator" = "contains"                ## An operator to be used in the filter. Only some operators are available for measures. For dimensions the available operators depend on the type of the dimension.
                "values" = @(                          ## An array of values for the filter. Values must be of type String.
                    'Assignments'
                )
            }
        )

    .PARAMETER Limit
        Limit the number of results returned. This can be used in combination with -Offset for pagination.

    .PARAMETER Offset
        Offset the returned results by the number specified. This can be used in combination with -Limit for pagination.

    .PARAMETER OrderBy
        The field in which to order the results by. This field supports auto-complete, and defaults to timestamp.

    .PARAMETER Order
        The direction to order results in. This defaults to ascending.

    .PARAMETER TimeDimension
        In order to be able to work with time series data, Cube needs to identify a time dimension which is a timestamp column in the database. This field supports auto/tab-completion.

    .PARAMETER Start
        Used in combination with -TimeDimension and -End to return time series data between specific time periods.

    .PARAMETER End
        Used in combination with -TimeDimension and -Start to return time series data between specific time periods.

    .PARAMETER Granularity
        When returning aggregated results and with the -Grouped parameter, granularity allows you to group data based on time frame such as second, minute, hour, day, week, month, quarter or year.

    .PARAMETER Grouped
        Specifying -Grouped will include all dimensions in the GROUP BY statement in the query.

    .PARAMETER Raw
        Return the Raw results from the API, instead of parsing the output.

    .EXAMPLE
        $Filters = @(
            @{
                "member" = "asset_daily_counts.asset_context"
                "operator" = "equals"
                "values" = @(
                    'cloud'
                )
            }
        )
        Invoke-B1CubeJS -Cube asset_daily_counts `
                        -Measures asset_count `
                        -Dimensions asset_context `
                        -TimeDimension asset_date `
                        -Granularity day `
                        -Start (Get-Date).AddDays(-30) `
                        -Filters $Filters `
                        -Grouped -OrderBy asset_date `
                        -Order desc

        asset_context asset_count asset_date            asset_date.day
        ------------- ----------- ----------            --------------
        cloud         618         7/23/2024 12:00:00 AM 7/23/2024 12:00:00 AM
        cloud         618         7/22/2024 12:00:00 AM 7/22/2024 12:00:00 AM
        cloud         618         7/21/2024 12:00:00 AM 7/21/2024 12:00:00 AM
        cloud         618         7/20/2024 12:00:00 AM 7/20/2024 12:00:00 AM
        cloud         630         7/19/2024 12:00:00 AM 7/19/2024 12:00:00 AM
        cloud         69          7/18/2024 12:00:00 AM 7/18/2024 12:00:00 AM
        cloud         22          7/17/2024 12:00:00 AM 7/17/2024 12:00:00 AM
        cloud         22          7/16/2024 12:00:00 AM 7/16/2024 12:00:00 AM
        ...

    .FUNCTIONALITY
        CubeJS

    .FUNCTIONALITY
        Infoblox Threat Defense

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
        [ValidateSet('second','minute','hour','day','week','month','quarter','year')]
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
            $Measures | ForEach-Object {
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
                $Dimensions | ForEach-Object {
                    "$($Cube).$($_)"
                }
            ))
        }
    }

    if ($Segments) {
        $splat.segments = @($(
            $Segments | ForEach-Object {
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
                $Result.result.data[0].PSObject.Properties | ForEach-Object {
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