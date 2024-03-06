function Get-B1TDDossierSupportedSources {
    <#
    .SYNOPSIS
        Queries a list of available dossier sources

    .DESCRIPTION
        The Dossier Sources cmdlet returns a list of all Dossier (sometimes referred to as Intel Lookup) sources and whether or not they are available for the caller.

    .PARAMETER Target
        List the supported sources relating to the target type (ip/host/url/email/hash)

    .EXAMPLE
        PS> Get-B1TDDossierSupportedSources -Target ip

    .EXAMPLE
        PS> Get-B1TDDossierSupportedSources 

        acs                 : True
        activity            : True
        atp                 : True
        ccb                 : True
        custom_lists        : True
        dns                 : True
        gcs                 : True
        geo                 : True
        gsb                 : True
        infoblox_web_cat    : True
        inforank            : True
        isight              : False
        malware_analysis    : True
        malware_analysis_v3 : True
        pdns                : True
        ptr                 : True
        rlabs               : False
        rpz_feeds           : True
        rwhois              : False
        whitelist           : True
        whois               : True
        ssl_cert            : True
        urlhaus             : True
        nameserver          : True
        threatfox           : True
        tld_risk            : True
        mandiant            : True
        screenshot          : True
        threat_actor        : True

    .EXAMPLE
        PS> Get-B1TDDossierSupportedSources -Target ip

        acs                 : True
        activity            : True
        atp                 : True
        ccb                 : True
        custom_lists        : True
        gcs                 : True
        geo                 : True
        isight              : True
        malware_analysis    : True
        malware_analysis_v3 : True
        mandiant            : True
        pdns                : True
        ptr                 : True
        rpz_feeds           : True
        threatfox           : True
        urlhaus             : True
        whitelist           : True
        whois               : True
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
        [ValidateSet("ip","host","url","email","hash")]
        [String]$Target
    )
 
    if ($Target) {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/services/intel/lookup/sources/target/$Target" -Method GET
    } else {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/services/intel/lookup/sources" -Method GET
    }
  
    if ($Results) {
      return $Results
    }
}