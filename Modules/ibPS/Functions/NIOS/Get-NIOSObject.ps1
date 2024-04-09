function Get-NIOSObject {
    <#
    .SYNOPSIS
        Generic Wrapper for interaction with the NIOS WAPI

    .DESCRIPTION
        This is a Generic Wrapper for interaction with the NIOS WAPI

    .PARAMETER Object
        Specify the object URI / API endpoint and query parameters here

    .EXAMPLE
        PS> Get-NIOSObject 'network?_max_results=1000&_return_as_object=1'

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Core
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Object
    )

    ## Get Saved CSP URL
    $Results = Query-NIOS -Method GET -Uri $Object
    if ($Results) {
        $Results
    }
}