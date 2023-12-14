function Set-B1Object {
    <#
    .SYNOPSIS
        Generic Wrapper for interaction with the CSP (Cloud Services Portal) via GET requests

    .DESCRIPTION
        This is a Generic Wrapper for getting objects from the BloxOne CSP (Cloud Services Portal).

    .PARAMETER _ref
        The base URL of the object to update

    .PARAMETER id
        The id of the object to update

    .PARAMETER Data
        The data to update

    .EXAMPLE
        $Records = Get-B1Object -Product 'BloxOne DDI' -App DnsConfig -Endpoint /dns/record -Filters @('absolute_zone_name~"mydomain.corp." and type=="a"')
        foreach ($Record in $Records) {
            if (!($Record.tags)) {
                $Record.tags = @{}
            }
            $Record.tags.newtag = "Tag Value"
        }
        $Records | select id,_ref,tags | Set-B1Object

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Core
    #>
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline = $true)]
        $Data,
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory=$true
          )]
          [String]$_ref,
        [Parameter(
          ValueFromPipelineByPropertyName = $true,
          Mandatory=$true
        )]
        [String]$id
    )

    process {
        $Results = Query-CSP -Method PATCH -Uri "$($_ref)/$($id)" -Data ($Data | Select-Object -ExcludeProperty _ref,id | ConvertTo-Json -Depth 10 -Compress) | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue
        if ($Results) {
            return $Results
        }
    }
}