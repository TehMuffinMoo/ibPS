function Get-B1TDDossierLookup {
    <#
    .SYNOPSIS
        Retrieves details about a BloxOne Threat Defense Dossier Lookup

    .DESCRIPTION
        This function is used to retrieve details about a BloxOne Threat Defense Dossier Lookup

    .PARAMETER job_id
        The job ID given when starting the lookup using Start-B1TDDossierLookup. Accepts pipeline input from Start-B1TDDossierLookup cmdlet

    .PARAMETER Pending
        Using this switch will return whether the job has completed or is still pending

    .PARAMETER Results
        Using this switch will return the results for the lookup job

    .PARAMETER task_id
        Used to filter the results by individual task ID

    .EXAMPLE
        Get-B1TDDossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -Results

    .EXAMPLE
        Get-B1TDDossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -Pending

    .EXAMPLE
        Get-B1TDDossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -task_id b1234567-0012-456a-98da-4a3323dds3

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