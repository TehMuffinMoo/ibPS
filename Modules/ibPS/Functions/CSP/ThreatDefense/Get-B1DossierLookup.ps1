function Get-B1DossierLookup {
    <#
    .SYNOPSIS
        Retrieves details about a Infoblox Threat Defense Dossier Lookup

    .DESCRIPTION
        This function is used to retrieve details about a Infoblox Threat Defense Dossier Lookup

    .PARAMETER job_id
        The job ID given when starting the lookup using Start-B1DossierLookup. Accepts pipeline input from Start-B1DossierLookup cmdlet

    .PARAMETER Status
        Using this switch will return whether the job has completed or is still pending

    .PARAMETER Results
        Using this switch will return the results for the lookup job

    .PARAMETER TaskResults
        Using this switch will return the results for the tasks associated with the lookup job

    .PARAMETER task_id
        Used to filter the results by individual task ID

    .EXAMPLE
        PS> Get-B1DossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -Results

    .EXAMPLE
        PS> Get-B1DossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -Status

    .EXAMPLE
        PS> Get-B1DossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -task_id b1234567-0012-456a-98da-4a3323dds3

    .EXAMPLE
        PS> $Lookup = Start-B1DossierLookup -Type ip 1.1.1.1
        PS> ($Lookup | Get-B1DossierLookup -Results).results

        task_id : 86655f48-944b-4871-9483-de1f0f0f820f
        params  : @{type=ip; target=1.1.1.1; source=whois}
        status  : success
        time    : 47
        v       : 3.0.0
        data    : @{response=}

        task_id : fa7b0d3e-68a5-4d15-a2e1-42e791fc76d1
        params  : @{type=ip; target=1.1.1.1; source=atp}
        status  : success
        time    : 230
        v       : 3.0.0
        data    : @{record_count=2771; threat=System.Object[]}

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param(
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        Mandatory=$true
      )]
      [Alias('JobID')]
      [String]$job_id,
      [Parameter(ParameterSetName="Status")]
      [Switch]$Status,
      [Switch]$Results,
      [Switch]$TaskResults,
      [Parameter(
        ParameterSetName="TaskID",
        ValueFromPipelineByPropertyName = $true,
        Mandatory=$true
      )]
      [String]$task_id
    )

    begin {
        $WebResponse = @()
    }
    process {
        if ($job_id) {
            $AppendToURI = ""
            if ($Status) {
                $AppendToURI += "/pending"
            }
            if ($task_id) {
                $AppendToURI += "/tasks/$task_id"
            }
            if ($Results) {
                $AppendToURI += "/results"
            }
            $WebResponse = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/tide/api/services/intel/lookup/jobs/$job_id$AppendToURI" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            if ($WebResponse.GetType().Name -eq 'String') {
                try {
                    Write-Debug 'Invoke response failed to convert JSON. Attempting alternative conversion..'
                    if ($PSVersionTable.PSVersion.Major -le 5) {
                        $WebResponse = ConvertFrom-ComplexJSON $WebResponse
                    } else {
                        $WebResponse = $WebResponse | ConvertFrom-Json -AsHashtable | ConvertFrom-HashTable
                    }
                } catch {
                    Write-Error "Failed to convert JSON response."
                    Write-Error $_
                    return $null
                }
            }
            if ($TaskResults) {
                $Tasks = @()
                $WebResponse.tasks.PSObject.Properties.Name | ForEach-Object {
                    $Tasks += [PSCustomObject]@{
                        'task_id' = $_
                    }
                }
                $ReturnData = $Tasks | Get-B1DossierLookup -job_id $WebResponse.job_id -Results
            } else {
                $ReturnData = $WebResponse
            }
        }

        if ($ReturnData) {
            $ReturnData
        }
    }
}