#
# Module manifest for module 'PSGet_ibPS'
#
# Generated by: Mat Cox
#
# Generated on: 07/12/2023
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'BloxOne-Main.psm1'

# Version number of this module.
ModuleVersion = '1.9.0.77'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '4ac3b7ae-457e-4335-b68f-7bba1ba2c337'

# Author of this module
Author = 'Mat Cox'

# Company or vendor of this module
CompanyName = 'TMM Networks'

# Copyright statement for this module
Copyright = '(c) 2022 Mat Cox. All rights reserved.'

# Description of the functionality provided by this module
Description = 'BloxOne REST API for PowerShell'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Get-B1BootstrapConfig', 'Get-B1CSPUrl', 'Get-B1Export', 
               'Remove-B1AddressReservation', 'Remove-B1AuthoritativeZone', 
               'Remove-B1FixedAddress', 'Remove-B1ForwardZone', 'Remove-B1Host', 
               'Set-B1CSPUrl', 'Start-B1Export', 'Get-B1Applications', 
               'Get-B1TDDossierSupportedFeedback', 
               'Get-B1TDDossierSupportedSources', 
               'Get-B1TDDossierSupportedTargets', 'Get-B1AuditLog', 
               'Get-B1TDNetworkList', 'Get-B1TDPoPRegion', 'Get-B1TDSecurityPolicy', 
               'Get-B1TDSecurityPolicyRules', 'Remove-B1TDNetworkList', 
               'Remove-B1TDSecurityPolicy', 'Get-B1CSPAPIKey', 
               'Get-B1TDDossierLookup', 'Search-B1', 'Set-B1Range', 
               'Start-B1TDDossierBatchLookup', 'Start-B1TDDossierLookup', 
               'Store-B1CSPAPIKey', 'New-B1APIKey', 'Remove-B1APIKey', 'Set-B1APIKey', 
               'Get-B1APIKey', 'Get-B1DNSEvent', 'Get-B1User', 'Get-B1UserAPIKey', 
               'Deploy-B1Appliance', 'Get-B1AddressBlockNextAvailable', 
               'Get-B1BulkOperation', 'Get-B1DFPLog', 'Get-B1DHCPGlobalConfig', 
               'Get-B1DHCPLease', 'Get-B1DHCPLog', 'Get-B1DHCPOptionCode', 
               'Get-B1DHCPOptionGroup', 'Get-B1DHCPOptionSpace', 'Get-B1DNSACL', 
               'Get-B1DNSLog', 'Get-B1DNSUsage', 'Get-B1DiagnosticTask', 
               'Get-B1GlobalNTPConfig', 'Get-B1HealthCheck', 
               'Get-B1NTPServiceConfiguration', 'Get-B1SecurityLog', 
               'Get-B1ServiceLog', 'Get-B1TDLookalikeDomains', 
               'Get-B1TDLookalikeTargetCandidates', 'Get-B1TDLookalikeTargets', 
               'Get-B1TDLookalikes', 'Get-B1TDThreatFeeds', 
               'Get-B1TDTideDataProfile', 'Get-B1TDTideFeeds', 
               'Get-B1TDTideInfoRank', 'Get-B1TDTideThreatClass', 
               'Get-B1TDTideThreatClassDefaultTTL', 'Get-B1TDTideThreatCounts', 
               'Get-B1TDTideThreatEnrichment', 'Get-B1TDTideThreatProperty', 
               'Get-B1TDTideThreats', 'Get-B1Tag', 'Grant-B1DHCPConfigProfile', 
               'Grant-B1DNSConfigProfile', 'New-B1AddressReservation', 
               'New-B1DHCPConfigProfile', 'New-B1FixedAddress', 'New-B1ForwardZone', 
               'New-B1HAGroup', 'New-B1Host', 'New-B1Range', 'New-B1Service', 
               'New-B1Subnet', 'New-B1TDTideDataProfile', 'Reboot-B1Host', 
               'Remove-B1AddressBlock', 'Remove-B1Range', 'Remove-B1Record', 
               'Remove-B1Service', 'Remove-B1Subnet', 'Revoke-B1DHCPConfigProfile', 
               'Revoke-B1DNSConfigProfile', 'Set-B1AddressBlock', 
               'Set-B1AuthoritativeZone', 'Set-B1DHCPConfigProfile', 
               'Set-B1DHCPGlobalConfig', 'Set-B1DNSHost', 'Set-B1FixedAddress', 
               'Set-B1ForwardNSG', 'Set-B1ForwardZone', 
               'Set-B1NTPServiceConfiguration', 'Set-B1Record', 'Set-B1Subnet', 
               'Set-B1TDTideDataProfile', 'Start-B1DiagnosticTask', 
               'Start-B1Service', 'Stop-B1Service', 'Get-B1TDContentCategory', 
               'Get-B1Address', 'Get-B1AddressBlock', 'Get-B1AuthoritativeNSG', 
               'Get-B1AuthoritativeZone', 'Get-B1DFP', 'Get-B1DHCPConfigProfile', 
               'Get-B1DHCPHost', 'Get-B1DNSConfigProfile', 'Get-B1DNSHost', 
               'Get-B1DNSView', 'Get-B1DelegatedZone', 'Get-B1FixedAddress', 
               'Get-B1ForwardNSG', 'Get-B1ForwardZone', 'Get-B1HAGroup', 'Get-B1Host', 
               'Get-B1Range', 'Get-B1Record', 'Get-B1Service', 'Get-B1Subnet', 
               'Get-B1TopMetrics', 'Remove-B1DHCPConfigProfile', 
               'Remove-B1DNSConfigProfile', 'Remove-B1HAGroup', 'Set-B1Host', 
               'Get-B1Space', 'New-B1AddressBlock', 'New-B1AuthoritativeZone', 
               'New-B1Record', 'New-B1Space', 'Copy-NIOSSubzoneToBloxOne', 
               'Get-NIOSAuthoritativeZone', 'Get-NIOSConfiguration', 
               'Get-NIOSCredentials', 'Get-NIOSDelegatedZone', 'Get-NIOSForwardZone', 
               'New-NIOSDelegatedZone', 'Set-NIOSConfiguration', 
               'Store-NIOSCredentials', 'Get-ibPSVersion', 'Query-CSP'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = '*'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # External dependent modules of this module
        # ExternalModuleDependencies = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

