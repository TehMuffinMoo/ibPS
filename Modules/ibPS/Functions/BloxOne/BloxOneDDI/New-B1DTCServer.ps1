function New-B1DTCServer {
    <#
    .SYNOPSIS
        Creates a new server object within BloxOne DTC

    .DESCRIPTION
        This function is used to create a new server object within BloxOne DTC
    
    .PARAMETER Name
        The name of the DTC server object to create

    .PARAMETER Description
        The description for the new zone

    .PARAMETER FQDN
        The FQDN of the server to associate the DTC object with. The -FQDN and -IP option are mutually exclusive.

    .PARAMETER IP
        The IP of the server to associate the DTC object with. The -IP and -FQDN option are mutually exclusive.

    .PARAMETER AutoCreateResponses
        The DTC response will contain an auto-created A (IPv4), AAAA (IPv6), CNAME(FQDN) record with endpoint defined using -IP or -FQDN.

    .PARAMETER SynthesizedCNAME
        The Synthesized CNAME record to add to the DTC Server. This cannot be used in conjunction with -AutoCreateResponses

    .PARAMETER SynthesizedA
        The Synthesized A record(s) to add to the DTC Server.

    .PARAMETER State
        Whether or not the new server is created as enabled or disabled. Defaults to enabled

    .PARAMETER Tags
        Any tags you want to apply to the DTC Server

    .EXAMPLE
       PS> New-B1DTCServer -Name 'Exchange Server A' -Description 'Exchange Server - Active Node' -FQDN 'exchange-1.company.corp' -AutoCreateResponses

        id                           : dtc/server/fsfsef8f3-3532-643h-jhjr-sdgfrgrg51349
        name                         : Exchange Server A
        comment                      : Exchange Server - Active Node
        tags                         : 
        disabled                     : False
        address                      : 
        records                      : {@{type=CNAME; rdata=; dns_rdata=exchange-1.company.corp}}
        fqdn                         : exchange-1.company.corp.
        endpoint_type                : fqdn
        auto_create_response_records : False
        metadata                     :
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [Parameter(ParameterSetName="FQDN",Mandatory=$true)]
      [String]$FQDN,
      [Parameter(ParameterSetName="IP",Mandatory=$true)]
      [IPAddress]$IP,
      [Switch]$AutoCreateResponses,
      [IPAddress[]]$SynthesizedA,
      [String]$SynthesizedCNAME,
      [ValidateSet("Enabled","Disabled")]
      [String]$State = 'Enabled',
      [System.Object]$Tags
    )

    $splat = @{
        "name" = $Name
        "comment" = $Description
        "disabled" = $(if ($State -eq 'Enabled') { $false } else { $true })
        "endpoint_type" = $(if ($FQDN) { "fqdn" } elseif ($IP) { "address" })
        "auto_create_response_records" = $(if ($AutoCreateResponses) { $true } else { $false })
        "records" = @()
    }
    if ($FQDN) {
        $splat += @{
            "fqdn" = $FQDN
        }
    }
    if ($IP) {
        $splat += @{
            "address" = $IP.IPAddressToString
        }
    }
    $Records = @()
    if ($SynthesizedA -and $SynthesizedCNAME) {
        Write-Error 'You cannot specify both A and CNAME records for synthesized responses.'
        break
    }
    if ($SynthesizedA) {
        foreach ($SynthesizedARecord in $SynthesizedA) {
            $Records += @{
                "type" = "A"
                "rdata" = @{
                    "address" = $SynthesizedARecord.IPAddressToString
                }
            }
        }
    }
    if ($SynthesizedCNAME) {
        if ($AutoCreateResponses) {
            Write-Error 'You cannot specify both -AutoCreateResponses and -SynthesizedCNAME parameters as they are mutually exclusive.'
            break
        }
        $Records += @{
            "type" = "CNAME"
            "rdata" = @{
                "cname" = $SynthesizedCNAME
            }
        }
    }

    $splat.records = $Records

    $JSON = $splat | ConvertTo-Json -Depth 5 -Compress

    $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dtc/server" -Data $JSON
    if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
        $Results | Select-Object -ExpandProperty result
    } else {
        $Results
    }

}