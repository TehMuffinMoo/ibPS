function Get-B1Schema {
    <#
    .SYNOPSIS
        Used for obtaining API Schema information for use with generic wrapper cmdlets

    .DESCRIPTION
        This is used for obtaining API Schema information for use with generic wrapper cmdlets

    .PARAMETER Product
        Specify the product to use

    .PARAMETER App
        Specify the App to use

    .PARAMETER Endpoint
        Specify the API Endpoint to use, such as "/ipam/record".

    .PARAMETER Method
        Specify the endpoint method to view the schema information for

    .PARAMETER ListParameters
        Specify this switch to list information relating to available parameters for the particular endpoint

    .EXAMPLE
        Get-B1Schema -Product 'BloxOne DDI'

    .EXAMPLE
        Get-B1Schema -Product 'BloxOne DDI' -App DnsConfig

    .EXAMPLE
        Get-B1Schema -Product 'BloxOne Cloud' -App 'CDC' -Endpoint /v2/flows/data -Method get -ListParameters

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Core
    #>
    param(
      [String]$Product,
      [String]$App,
      [String]$Endpoint,
      [ValidateSet("GET","POST","PUT", "PATCH", "DELETE")]
      [String]$Method,
      [Switch]$ListParameters
    )

    if ($ListParameters -and -not ($Method -and $Endpoint)) {
        Write-Error "You must specify both the -Method and -Endpoint parameters to use -ListParameters"
        break
    }

    ## Get Saved CSP URL
    $B1CSPUrl = Get-B1CSPUrl

    if ($Product) {
        if ($App) {

            $Uri = "$(Get-B1CSPUrl)/apidoc/docs/$($PSBoundParameters['App'])"

            $Results = Query-CSP -Method GET -Uri $Uri
            if ($Results) {
                if ($Endpoint) {
                    $Return = (($Results.paths.psobject.properties | ForEach-Object -begin {$h=@{}} -process {$h."$($_.Name)" = $_.Value} -end {$h}).GetEnumerator() | Where-Object {$_.Name -eq $($PSBoundParameters['Endpoint'])}).Value | Select-Object -ExpandProperty $($Method)
                    if ($ListParameters) {
                        $Return.parameters | Format-Table name,type,description -Wrap
                    } elseif (!($Method)) {
                        $ResultMethods = ($Return.psobject.properties | ForEach-Object -begin {$h=@{}} -process {$h."$($_.Name)" = $_.Value} -end {$h}).GetEnumerator()
                        foreach ($ResultMethod in $ResultMethods) {
                            $Methods += @{
                                "$($ResultMethod.Name)" = $($ResultMethod.Value.psobject.properties | ForEach-Object -begin {$h=@{}} -process {$h."$($_.Name)" = $_.Value} -end {$h}).description
                            }
                        }
                        Write-Host "Available Methods: " -ForegroundColor Green
                        $Methods | Format-Table -Wrap
                    } else {
                        $Return
                    }
                } else {
                    $Return = @()
                    $ResultsParsed = (($Results.paths.psobject.properties | ForEach-Object -begin {$h=@{}} -process {$h."$($_.Name)" = $_.Value} -end {$h}).GetEnumerator())
                    foreach ($ResultParsed in $ResultsParsed) {
                        $ResultMethods = (($ResultParsed.Value.psobject.properties | ForEach-Object -begin {$h=@{}} -process {$h."$($_.Name)" = $_.Value} -end {$h}).GetEnumerator())
                        $Methods = @()
                        foreach ($ResultMethod in $ResultMethods) {
                            $Methods += @{
                                "$($ResultMethod.Name)" = $($ResultMethod.Value.psobject.properties | ForEach-Object -begin {$h=@{}} -process {$h."$($_.Name)" = $_.Value} -end {$h}).description
                            }
                        }
                        $ResultMethods
                        $Return += @{
                            "Endpoint" = $ResultParsed.Name
                            "Description" = ($Methods | Select-Object -First 1).Values[0] -join " "
                        } | ConvertTo-Json | ConvertFrom-Json
                    }
                    $Return | Select-Object Endpoint,Description
                }
            }
        } else {
            $Apps = Query-CSP GET "$(Get-B1CSPUrl)/apidoc/docs/list/products" | Where-Object {$_.title -eq $($PSBoundParameters['Product'])} | Select-Object -ExpandProperty apps
            Write-Host "Available Apps: " -ForegroundColor Green
            $Apps | Format-Table -AutoSize
        }
    } else {
        $Products = Query-CSP GET "$(Get-B1CSPUrl)/apidoc/docs/list/products"
        Write-Host "Available Products: " -ForegroundColor Green
        $Products.title
    }
}