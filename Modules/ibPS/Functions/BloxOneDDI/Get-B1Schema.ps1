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
        PS> Get-B1Schema -Product 'BloxOne DDI'

        Available Apps: 

        app                     label
        ---                     -----
        Ipamsvc                 IP Address Management
        DnsConfig               DNS Configuration
        DnsData                 DNS Data
        DhcpLeases              DHCP Leases
        DDIKeys                 DDI Keys
        ThirdPartyProviders     Third Party Providers
        CloudDiscoveryProviders Cloud Discovery Providers

    .EXAMPLE
        PS> Get-B1Schema -Product 'BloxOne DDI' -App DnsConfig | Select Endpoint,Description  

        Endpoint                               Description
        --------                               -----------
        /dns/global/{id}                       Use this method to read the Global configuration object.…
        /dns/acl/{id}                          Use this method to move an ACL object to Recyclebin.…
        /dns/global                            Use this method to read the Global configuration object.…
        /dns/cache_flush                       Use this method to create a Cache Flush object.…
        /dns/auth_nsg/{id}                     Use this method to move an AuthNSG object to Recyclebin.…
        /dns/server                            Use this method to list Server objects.…
        /dns/auth_zone                         Use this method to list AuthZone objects.…
        /dns/service/{id}                      Use this method to read a DNS Service object.…
        /dns/server/{id}                       Use this method to move a Server object to Recyclebin.…
        /dns/service                           Use this method to list DNS Service objects.…
        /dns/forward_nsg                       Use this method to list ForwardNSG objects.…
        /dns/view/{id}                         Use this method to move a View object to Recyclebin.…
        /dns/forward_zone                      Use this method to list Forward Zone objects.…
        /dns/acl                               Use this method to list ACL objects.…
        /dns/view                              Use this method to list View objects.…
        /dns/forward_zone/{id}                 Use this method to move a Forward Zone object to Recyclebin.…
        /dns/host                              Use this method to list DNS Host objects.…
        /dns/forward_nsg/{id}                  Use this method to move a ForwardNSG object to Recyclebin.…
        /dns/forward_zone/copy                 Use this method to copy an __ForwardZone__ object to a different __View__.…
        /dns/auth_zone/{id}                    Use this method to move an AuthZone object to Recyclebin.…
        /dns/convert_rname/{email_address}     Use this method to convert email address to the master file RNAME format.
        /dns/view/bulk_copy                    Use this method to bulk copy __AuthZone__ and __ForwardZone__ objects from one __View__ object to another __View__ object.…
        /dns/auth_zone/copy                    Use this method to copy an __AuthZone__ object to a different __View__.…
        /dns/delegation/{id}                   Use this method to move a Delegation object to Recyclebin.…
        /dns/auth_nsg                          Use this method to list AuthNSG objects.…
        /dns/convert_domain_name/{domain_name} Use this method to convert between Internationalized Domain Name (IDN) and ASCII domain name (Punycode).
        /dns/delegation                        Use this method to list Delegation objects.…
        /dns/host/{id}                         Use this method to read a DNS Host object.…

    .EXAMPLE
        PS> Get-B1Schema -Product 'BloxOne Cloud' -App 'CDC' -Endpoint /v2/flows/data -Method get -ListParameters

        name    type   description
        ----    ----   -----------
        _filter string
                    
                    A collection of response resources can be filtered by a logical expression string that includes JSON tag references to values in each resource, literal values, and logical operators. If a resource does not have the specified tag, its value is assumed to be null.
                    
                    Literal values include numbers (integer and floating-point), and quoted (both single- or double-quoted) literal strings, and 'null'. The following operators are commonly used in filter expressions:
                    
                    |  Op   |  Description               |
                    |  --   |  -----------               |
                    |  ==   |  Equal                     |
                    |  !=   |  Not Equal                 |
                    |  >    |  Greater Than              |
                    |   >=  |  Greater Than or Equal To  |
                    |  <    |  Less Than                 |
                    |  <=   |  Less Than or Equal To     |
                    |  and  |  Logical AND               |
                    |  ~    |  Matches Regex             |
                    |  !~   |  Does Not Match Regex      |
                    |  or   |  Logical OR                |
                    |  not  |  Logical NOT               |
                    |  ()   |  Groupping Operators       |
                    
                    
        _fields string
                    
                    A collection of response resources can be transformed by specifying a set of JSON tags to be returned. For a “flat” resource, the tag name is straightforward. If field selection is allowed on non-flat hierarchical resources, the service should implement a qualified
                    naming scheme such as dot-qualification to reference data down the hierarchy. If a resource does not have the specified tag, the tag does not appear in the output resource.
                    
                    Specify this parameter as a comma-separated list of JSON tag names.

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