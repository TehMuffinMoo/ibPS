function New-B1Record {
    <#
    .SYNOPSIS
        Creates a new DNS record in BloxOneDDI

    .DESCRIPTION
        This function is used to create a new DNS record in BloxOneDDI

    .PARAMETER Type
        The record type to create

    .PARAMETER Name
        The name of the record to create

    .PARAMETER Zone
        The zone which the record will be created in

    .PARAMETER rdata
        The RDATA for the record to be created

    .PARAMETER View
        The DNS View the record will be created in

    .PARAMETER TTL
        Use this parameter to set a custom TTL when creating the record

    .PARAMETER Description
        The description of the record to be created

    .PARAMETER CreatePTR
        Whether to create an associated PTR record (where applicable). This defaults to $true

    .PARAMETER Priority
        Used to set the priority for SRV records

    .PARAMETER Weight
        Used to set the weight for SRV records

    .PARAMETER Port
        Used to set the port for SRV records

    .PARAMETER CAFlag
        Used to set the CA Flag value for CAA records

    .PARAMETER CATag
        Used to set the CA Tag value for CAA records

    .PARAMETER CAValue
        Used to set the CA value for CAA records

    .PARAMETER Tags
        Any tags you want to apply to the record

    .PARAMETER SkipExistsErrors
        Whether to skip errors if the record already exists. Default is $false

    .PARAMETER IgnoreExists
        Whether to ignore if a record already exists and attempt to create it anyway

    .EXAMPLE
        PS> New-B1Record -Type A -Name "myArecord" -Zone "corp.mydomain.com" -View "default" -rdata "10.10.30.10" -TTL 300
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("A","AAAA","CNAME","PTR","TXT","SRV","MX","CAA","NS")] ## To be added "HTTPS","NAPTR","SVCB"
      [String]$Type,
      [Parameter(Mandatory=$true)]
      [AllowEmptyString()]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Zone,
      [Parameter(Mandatory=$true)]
      [String]$view,
      [int]$TTL,
      [string]$Description,
      [bool]$CreatePTR = $true,
      [System.Object]$Tags,
      [switch]$SkipExistsErrors = $false,
      [switch]$IgnoreExists = $false
    )

    DynamicParam {
        switch ($Type) {
          "SRV" {
             $priorityAttribute = New-Object System.Management.Automation.ParameterAttribute
             $priorityAttribute.Position = 2
             $priorityAttribute.Mandatory = $true
             $priorityAttribute.HelpMessage = "The Priority parameter is required when creating an SRV Record."

             $weightAttribute = New-Object System.Management.Automation.ParameterAttribute
             $weightAttribute.Position = 3
             $weightAttribute.Mandatory = $true
             $weightAttribute.HelpMessage = "The Weight parameter is required when creating an SRV Record."

             $portAttribute = New-Object System.Management.Automation.ParameterAttribute
             $portAttribute.Position = 4
             $portAttribute.Mandatory = $true
             $portAttribute.HelpMessage = "The Port parameter is required when creating an SRV Record."

             $weightAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
             $weightAttributeCollection.Add($weightAttribute)

             $priorityAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
             $priorityAttributeCollection.Add($priorityAttribute)

             $portAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
             $portAttributeCollection.Add($portAttribute)

             $priorityParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Priority', [Int], $priorityAttributeCollection)
             $weightParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Weight', [Int], $weightAttributeCollection)
             $portParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Port', [Int], $portAttributeCollection)

             $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
             $paramDictionary.Add('Priority', $priorityParam)
             $paramDictionary.Add('Weight', $weightParam)
             $paramDictionary.Add('Port', $portParam)
             break
         }
         "MX" {
             $preferenceAttribute = New-Object System.Management.Automation.ParameterAttribute
             $preferenceAttribute.Mandatory = $true
             $preferenceAttribute.HelpMessage = "The -Preference parameter is required when creating an MX Record."

             $exchangeAttribute = New-Object System.Management.Automation.ParameterAttribute
             $exchangeAttribute.Mandatory = $true
             $exchangeAttribute.HelpMessage = "The -Exchange parameter is required when creating an MX Record."

             $preferenceAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
             $preferenceAttributeCollection.Add($preferenceAttribute)

             $exchangeAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
             $exchangeAttributeCollection.Add($exchangeAttribute)

             $preferenceParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Preference', [Int], $preferenceAttributeCollection)
             $exhangeparamParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Exchange', [String], $exchangeAttributeCollection)

             $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
             $paramDictionary.Add('Preference', $preferenceParam)
             $paramDictionary.Add('Exchange', $exhangeparamParam)
             break
         }
         "CAA" {
            $caflagAttribute = New-Object System.Management.Automation.ParameterAttribute
            $caflagAttribute.Mandatory = $true
            $caflagAttribute.HelpMessage = "The CAFlag parameter is required when creating a CAA Record."

            $catagAttribute = New-Object System.Management.Automation.ParameterAttribute
            $catagAttribute.Mandatory = $true
            $catagAttribute.HelpMessage = "The CATag parameter is required when creating a CAA Record."

            $catagValidateSet = New-Object System.Management.Automation.ValidateSetAttribute -ArgumentList @("issue", "issuewild", "iodef")

            $cavalueAttribute = New-Object System.Management.Automation.ParameterAttribute
            $cavalueAttribute.Mandatory = $true
            $cavalueAttribute.HelpMessage = "The CAValue parameter is required when creating a CAA Record."

            $catagAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
            $catagAttributeCollection.Add($catagAttribute)
            $catagAttributeCollection.Add($catagValidateSet)

            $caflagAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
            $caflagAttributeCollection.Add($caflagAttribute)

            $cavalueAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
            $cavalueAttributeCollection.Add($cavalueAttribute)

            $caflagParam = New-Object System.Management.Automation.RuntimeDefinedParameter('CAFlag', [Int], $caflagAttributeCollection)
            $catagParam = New-Object System.Management.Automation.RuntimeDefinedParameter('CATag', [String], $catagAttributeCollection)
            $cavalueParam = New-Object System.Management.Automation.RuntimeDefinedParameter('CAValue', [String], $cavalueAttributeCollection)

            $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add('CAFlag', $caflagParam)
            $paramDictionary.Add('CATag', $catagParam)
            $paramDictionary.Add('CAValue', $cavalueParam)
            break
         }
        }
        if ($Type -notin "CAA","MX") { ## Ignore -rdata param for these types
            $rdataattribute = New-Object System.Management.Automation.ParameterAttribute
            $rdataattribute.Mandatory = $true
            $rdataattribute.HelpMessage = "Record Value"

            $rdataAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
            $rdataAttributeCollection.Add($rdataAttribute)

            $rdataParam = New-Object System.Management.Automation.RuntimeDefinedParameter('rdata', [String], $rdataAttributeCollection)
            if (!$paramDictionary) {
                $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            }
            $paramDictionary.Add('rdata', $rdataParam)
        }
        if ($paramDictionary) {
            return $paramDictionary
        }
    }

    process {

    if ($view) {
        $viewId = (Get-B1DNSView -Name $view -Strict).id
    }

    $TTLAction = "inherit"
    $FQDN = $Name+"."+$Zone
    if ($PSBoundParameters['rdata']) {$rdata = $PSBoundParameters['rdata']}
    $Record = Get-B1Record -Name $Name -View $view -Strict -Type $Type -Zone $Zone
    if ($Record -and -not $IgnoreExists) {
        if (!$SkipExistsErrors -and !$Debug) {Write-Host "DNS Record $($Name).$($Zone) already exists." -ForegroundColor Yellow}
        return $false
    } else {
        $AuthZoneId = (Get-B1AuthoritativeZone -FQDN $Zone -Strict -View $view).id
        if (!($AuthZoneId)) {
            Write-Host "Error. Authorative Zone not found." -ForegroundColor Red
        } else {
            switch ($Type) {
                "A" {
                    if ([bool]($rdata -as [ipaddress])) {
                        $rdataSplat = @{
                            "address" = $rdata
	                    }
                        $Options = @{
	                        "create_ptr" = $CreatePTR
	                        "check_rmz" = $false
	                    }
                    } else {
                        Write-Host "Error. Invalid IP Address." -ForegroundColor Red
                        break
                    }
                }
                "AAAA" {
                    if ([bool]($rdata -as [ipaddress])) {
                        $rdataSplat = @{
                            "address" = $rdata
	                    }
                        $Options = @{
	                        "create_ptr" = $CreatePTR
	                        "check_rmz" = $false
	                    }
                    }    else {
                        Write-Host "Error. Invalid IP Address." -ForegroundColor Red
                        break
                    }
                }
                "CNAME" {
                    if ($rdata -match "(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}(\.)?$)") {
                        if (!($rdata.EndsWith("."))) {
                            $rdata = "$rdata."
                        }
                        $rdataSplat = @{
	                        "cname" = $rdata
	                    }
                    } else {
                        Write-Host "Error. CNAME must be an FQDN: $rdata" -ForegroundColor Red
                        break
                    }
                }
                "TXT" {
                    $rdataSplat = @{
                        "text" = $rdata
	                }
                }
                "PTR" {
                    $rdataSplat = @{
                        "dname" = $rdata
	                }
                }
                "SRV" {
                    if ($rdata -match "(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)") {
                        if ($PSBoundParameters['Priority'] -ge 0 -and $PSBoundParameters['Weight'] -ge 0 -and $PSBoundParameters['Port'] -ge 0) {
                            if (!($rdata.EndsWith("."))) {
                                $rdata = "$rdata."
                            }
                            $rdataSplat = @{
		                        "priority" = $PSBoundParameters['Priority']
		                        "weight" = $PSBoundParameters['Weight']
		                        "port" = $PSBoundParameters['Port']
		                        "target" = $rdata
	                        }
                        } else {
                            Write-Host "Error. When creating SRV records, -Priority, -Weight & -Port parameters are all required." -ForegroundColor Red
                            break
                        }
                    } else {
                        Write-Host "Error. SRV target must be an FQDN: $rdata" -ForegroundColor Red
                        break
                    }
                }
                "MX" {
                    if (!($rdata.EndsWith("."))) {
                        $rdata = "$rdata."
                    }
                    $rdataSplat = @{
                        "exchange" = $PSBoundParameters['Exchange']
	                    "preference" = $PSBoundParameters['Preference']
	                }
                }
                "CAA" {
                    $rdataSplat = @{
                        "flags" = $PSBoundParameters['CAFlag']
	                    "tag" = $PSBoundParameters['CATag']
                        "value" = $PSBoundParameters['CAValue']
	                }
                }
                "NS" {
                    if (!($rdata.EndsWith("."))) {
                        $rdata = "$rdata."
                    }
                    $rdataSplat = @{
                        "dname" = $rdata
	                }
                }
                default {
                    Write-Host "Error. Invalid record type: $Type" -ForegroundColor Red
                    break
                }
            }
            if ($rdataSplat) {
                Write-Host "Creating $Type Record for $FQDN.." -ForegroundColor Gray
            
                if ($TTL) {
                    $TTLAction = "override"
                }
                $splat = @{
	                "name_in_zone" = $Name
	                "zone" = $AuthZoneId
	                "type" = $Type
	                "rdata" = $rdataSplat
	                "inheritance_sources" = @{
		                "ttl" = @{
			                "action" = $TTLAction
		                }
	                }
                }
                if ($Options) {
                    $splat | Add-Member -Name "options" -Value $Options -MemberType NoteProperty
                }               
                if ($TTL) {
                    $splat | Add-Member -Name "ttl" -Value $TTL -MemberType NoteProperty
                }
                if ($viewId) {
                    #$splat | Add-Member -Name "view" -Value $viewId -MemberType NoteProperty
                }
                if ($Description) {
                    $splat | Add-Member -Name "comment" -Value $Description -MemberType NoteProperty
                }
                if ($Tags) {
                    $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
                }

                $splat = $splat | ConvertTo-Json
                $Result = Query-CSP -Method POST -Uri "dns/record" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
                if ($Result.dns_rdata -match $rdata) {
                    Write-Host "DNS $Type Record has been successfully created for $FQDN." -ForegroundColor Green
                    return $Result
                } else {
                    Write-Host "Failed to create DNS $Type Record for $FQDN." -ForegroundColor Red
                }

            }
        }
    }

  }

}