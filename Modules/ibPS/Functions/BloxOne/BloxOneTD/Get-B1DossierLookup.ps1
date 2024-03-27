function Get-B1DossierLookup {
    <#
    .SYNOPSIS
        Retrieves details about a BloxOne Threat Defense Dossier Lookup

    .DESCRIPTION
        This function is used to retrieve details about a BloxOne Threat Defense Dossier Lookup

    .PARAMETER job_id
        The job ID given when starting the lookup using Start-B1DossierLookup. Accepts pipeline input from Start-B1DossierLookup cmdlet

    .PARAMETER Pending
        Using this switch will return whether the job has completed or is still pending

    .PARAMETER Results
        Using this switch will return the results for the lookup job

    .PARAMETER task_id
        Used to filter the results by individual task ID

    .EXAMPLE
        PS> Get-B1DossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -Results

    .EXAMPLE
        PS> Get-B1DossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -Pending

    .EXAMPLE
        PS> Get-B1DossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -task_id b1234567-0012-456a-98da-4a3323dds3

    .EXAMPLE
        PS> $Lookup = Start-B1DossierLookup -Type ip 1.1.1.1
        PS> $Lookup | Get-B1DossierLookup -Results

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
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param(
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        Mandatory=$true
      )]
      [String]$job_id,
      [Parameter(ParameterSetName="Pending")]
      [Switch]$Pending,
      [Parameter(ParameterSetName="Results")]
      [Switch]$Results,
      [Parameter(ParameterSetName="TaskID")]
      [String]$task_id
    )

    if ($job_id) {
        $AppendToURI = ""
        if ($Pending) {
            $AppendToURI = $AppendToURI + "/pending"
        }
        if ($Results) {
            $AppendToURI = $AppendToURI + "/results"
        }
        if ($task_id) {
            $AppendToURI = $AppendToURI + "/tasks/$task_id"
        }
        $ReturnResults = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/tide/api/services/intel/lookup/jobs/$job_id$AppendToURI" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    if ($ReturnResults) {
        if ($Results) {
            return $ReturnResults | Select-Object -ExpandProperty results
        } else {
            return $ReturnResults
        }
    }
}