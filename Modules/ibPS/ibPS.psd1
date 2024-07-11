#
# Module manifest for module 'ibPS'
#
# Generated by: Mat Cox
#
# Generated on: 07/11/2024
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'BloxOne-Main.psm1'

# Version number of this module.
ModuleVersion = '1.9.7.5'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '4ac3b7ae-457e-4335-b68f-7bba1ba2c337'

# Author of this module
Author = 'Mat Cox'

# Company or vendor of this module
CompanyName = 'TMM Networks'

# Copyright statement for this module
Copyright = '(c) 2021-2024 Mat Cox. All rights reserved.'

# Description of the functionality provided by this module
Description = 'InfoBlox BloxOne PowerShell Module'

# Minimum version of the PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

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
FunctionsToExport = 'Get-B1APIKey', 'Get-B1AuditLog', 'Get-B1BulkOperation', 
               'Get-B1Compartment', 'Get-B1CSPCurrentUser', 'Get-B1DFPLog', 
               'Get-B1DHCPLog', 'Get-B1DiagnosticTask', 'Get-B1DNSEvent', 
               'Get-B1DNSLog', 'Get-B1Export', 'Get-B1Licenses', 'Get-B1Location', 
               'Get-B1SecurityLog', 'Get-B1ServiceLog', 'Get-B1Tag', 'Get-B1User', 
               'Get-B1UserAPIKey', 'New-B1APIKey', 'New-B1Location', 'Remove-B1APIKey', 
               'Remove-B1Location', 'Search-B1', 'Set-B1APIKey', 'Set-B1Location', 
               'Start-B1Export', 'ConvertTo-PunyCode', 'ConvertTo-RNAME', 
               'Get-B1Address', 'Get-B1AddressBlock', 
               'Get-B1AddressBlockNextAvailable', 'Get-B1AddressNextAvailable', 
               'Get-B1AuthoritativeNSG', 'Get-B1AuthoritativeZone', 
               'Get-B1CloudProvider', 'Get-B1DelegatedZone', 'Get-B1DFP', 
               'Get-B1DHCPConfigProfile', 'Get-B1DHCPGlobalConfig', 
               'Get-B1DHCPHardwareFilter', 'Get-B1DHCPHost', 'Get-B1DHCPLease', 
               'Get-B1DHCPOptionCode', 'Get-B1DHCPOptionGroup', 
               'Get-B1DHCPOptionSpace', 'Get-B1DNSACL', 'Get-B1DNSConfigProfile', 
               'Get-B1DNSHost', 'Get-B1DNSUsage', 'Get-B1DNSView', 
               'Get-B1DTCHealthCheck', 'Get-B1DTCLBDN', 'Get-B1DTCPolicy', 
               'Get-B1DTCPool', 'Get-B1DTCServer', 'Get-B1DTCStatus', 
               'Get-B1FixedAddress', 'Get-B1ForwardNSG', 'Get-B1ForwardZone', 
               'Get-B1GlobalNTPConfig', 'Get-B1HAGroup', 'Get-B1IPAMChild', 
               'Get-B1NTPServiceConfiguration', 'Get-B1Range', 'Get-B1Record', 
               'Get-B1Space', 'Get-B1Subnet', 'Get-B1SubnetNextAvailable', 
               'Get-B1ThirdPartyProvider', 'Get-B1TopMetrics', 'Get-B1ZoneChild', 
               'Grant-B1DHCPConfigProfile', 'Grant-B1DNSConfigProfile', 
               'New-B1AddressBlock', 'New-B1AddressReservation', 
               'New-B1AuthoritativeZone', 'New-B1DelegatedZone', 
               'New-B1DHCPConfigProfile', 'New-B1DNSACLItem', 'New-B1DNSView', 
               'New-B1DTCHealthCheck', 'New-B1DTCLBDN', 'New-B1DTCPolicy', 
               'New-B1DTCPool', 'New-B1DTCServer', 'New-B1DTCTopologyRule', 
               'New-B1FixedAddress', 'New-B1ForwardZone', 'New-B1HAGroup', 
               'New-B1Range', 'New-B1Record', 'New-B1Space', 'New-B1Subnet', 
               'Remove-B1AddressBlock', 'Remove-B1AddressReservation', 
               'Remove-B1AuthoritativeZone', 'Remove-B1DelegatedZone', 
               'Remove-B1DHCPConfigProfile', 'Remove-B1DNSConfigProfile', 
               'Remove-B1DNSView', 'Remove-B1DTCHealthCheck', 'Remove-B1DTCLBDN', 
               'Remove-B1DTCPolicy', 'Remove-B1DTCPool', 'Remove-B1DTCServer', 
               'Remove-B1FixedAddress', 'Remove-B1ForwardZone', 'Remove-B1HAGroup', 
               'Remove-B1Range', 'Remove-B1Record', 'Remove-B1Space', 
               'Remove-B1Subnet', 'Revoke-B1DHCPConfigProfile', 
               'Revoke-B1DNSConfigProfile', 'Set-B1AddressBlock', 
               'Set-B1AuthoritativeZone', 'Set-B1DHCPConfigProfile', 
               'Set-B1DHCPGlobalConfig', 'Set-B1DNSACL', 'Set-B1DNSHost', 
               'Set-B1DTCHealthCheck', 'Set-B1DTCLBDN', 'Set-B1DTCPolicy', 
               'Set-B1DTCPool', 'Set-B1DTCServer', 'Set-B1FixedAddress', 
               'Set-B1ForwardNSG', 'Set-B1ForwardZone', 'Set-B1HAGroup', 
               'Set-B1NTPServiceConfiguration', 'Set-B1Range', 'Set-B1Record', 
               'Set-B1Subnet', 'Deploy-B1Appliance', 'Disable-B1HostLocalAccess', 
               'Enable-B1HostLocalAccess', 'Get-B1Applications', 
               'Get-B1BootstrapConfig', 'Get-B1HealthCheck', 'Get-B1Host', 
               'Get-B1HostLocalAccess', 'Get-B1Service', 'New-B1Host', 'New-B1Service', 
               'Remove-B1Host', 'Remove-B1Service', 'Restart-B1Host', 'Set-B1Host', 
               'Start-B1DiagnosticTask', 'Start-B1Service', 'Stop-B1Service', 
               'Disable-B1Lookalike', 'Disable-B1LookalikeTargetCandidate', 
               'Enable-B1Lookalike', 'Enable-B1LookalikeTargetCandidate', 
               'Get-B1ApplicationFilter', 'Get-B1BypassCode', 'Get-B1CategoryFilter', 
               'Get-B1ContentCategory', 'Get-B1CustomList', 'Get-B1DossierLookup', 
               'Get-B1DossierSupportedFeedback', 'Get-B1DossierSupportedSources', 
               'Get-B1DossierSupportedTargets', 'Get-B1Endpoint', 
               'Get-B1EndpointGroup', 'Get-B1InternalDomainList', 
               'Get-B1LookalikeDomains', 'Get-B1Lookalikes', 
               'Get-B1LookalikeTargetCandidates', 'Get-B1LookalikeTargets', 
               'Get-B1LookalikeTargetSummary', 'Get-B1NetworkList', 
               'Get-B1PoPRegion', 'Get-B1RPZFeed', 'Get-B1SecurityPolicy', 
               'Get-B1SecurityPolicyRules', 'Get-B1SOCInsight', 
               'Get-B1SOCInsightAssets', 'Get-B1SOCInsightComments', 
               'Get-B1SOCInsightEvents', 'Get-B1SOCInsightIndicators', 
               'Get-B1ThreatFeeds', 'Get-B1ThreatIntel', 'Get-B1TideDataProfile', 
               'Get-B1TideFeeds', 'Get-B1TideInfoRank', 'Get-B1TideThreatClass', 
               'Get-B1TideThreatClassDefaultTTL', 'Get-B1TideThreatCounts', 
               'Get-B1TideThreatEnrichment', 'Get-B1TideThreatInsightClass', 
               'Get-B1TideThreatProperty', 'Get-B1TideThreats', 'New-B1CustomList', 
               'New-B1DoHFQDN', 'New-B1InternalDomainList', 'New-B1LookalikeTarget', 
               'New-B1SecurityPolicy', 'New-B1SecurityPolicyIPAMNetwork', 
               'New-B1SecurityPolicyRule', 'New-B1TideDataProfile', 
               'Remove-B1BypassCode', 'Remove-B1CustomList', 
               'Remove-B1InternalDomainList', 'Remove-B1LookalikeTarget', 
               'Remove-B1NetworkList', 'Remove-B1SecurityPolicy', 'Set-B1CustomList', 
               'Set-B1InternalDomainList', 'Set-B1LookalikeTarget', 
               'Set-B1SecurityPolicy', 'Set-B1SOCInsight', 'Set-B1TideDataProfile', 
               'Start-B1DossierBatchLookup', 'Start-B1DossierLookup', 
               'Submit-B1TideData', 'Get-B1ConnectionProfile', 
               'New-B1ConnectionProfile', 'Remove-B1ConnectionProfile', 
               'Switch-B1ConnectionProfile', 'Get-B1Object', 'Get-B1Schema', 
               'New-B1Object', 'Remove-B1Object', 'Set-B1Object', 
               'Get-NIOSConnectionProfile', 'New-NIOSConnectionProfile', 
               'Remove-NIOSConnectionProfile', 'Switch-NIOSConnectionProfile', 
               'Convert-RecordsToBloxOne', 'Copy-NIOSDTCToBloxOne', 'Get-NIOSObject', 
               'Get-NIOSSchema', 'Invoke-NIOS', 'New-NIOSObject', 'Remove-NIOSObject', 
               'Set-NIOSObject', 'Get-ibPSConfiguration', 'Get-ibPSVersion', 
               'Get-NetworkInfo', 'Get-NetworkTopology', 'Resolve-DoHQuery', 
               'Set-ibPSConfiguration', 'Invoke-CSP'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'Apply-B1HostDHCPConfigProfile', 'Apply-B1HostDNSConfigProfile', 
               'dohdig', 'Get-BCP', 'Get-NCP', 'New-BCP', 'New-NCP', 
               'Remove-B1HostDHCPConfigProfile', 'Remove-B1HostDNSConfigProfile', 
               'Remove-BCP', 'Remove-NCP', 'Switch-BCP', 'Switch-NCP'

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
        Tags = 'Infoblox','BloxOne','BloxOneDDI','ThreatDefense','REST','Windows','MacOS','API'

        # A URL to the license for this module.
        LicenseUri = 'https://raw.githubusercontent.com/TehMuffinMoo/ibPS/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/TehMuffinMoo/ibPS'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = 'https://ibps.readthedocs.io/en/latest/Change%20Log/'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

