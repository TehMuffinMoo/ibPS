function Get-B1Tokens {
    <#
    .SYNOPSIS
        Provides a summary of token utilization

    .DESCRIPTION
        This function is used to provide a summary of token utilization

    .PARAMETER Bucket
        Management, Server or Reporting

    .PARAMETER Granularity
        The grouping granularity of the data to retrieve. Valid values are: second, minute, hour, day, week, month, quarter, year

    .PARAMETER Start
        The start date/time for the data to retrieve. If not specified, defaults to 1 month ago. The date/time must be in UTC format.

    .PARAMETER End
        The end date/time for the data to retrieve. If not specified, defaults to now. The date/time must be in UTC format.

    .EXAMPLE
        PS> Get-B1Tokens -Bucket Management

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Infoblox Portal

    .FUNCTIONALITY
        Licenses
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)]
        [ValidateSet('Management','Server','Reporting')]
        [String]$Bucket,
        [ValidateSet('now','daily','monthly')]
        [String]$Granularity = 'now',
        [DateTime]$Start = (Get-Date).AddMonths(-1),
        [DateTime]$End = (Get-Date)
    )

    DynamicParam {
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        ## Object Type ##
        $ObjectTypeAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ObjectTypeAttribute.Position = 3
        $ObjectTypeAttribute.HelpMessage = "The ObjectType parameter is used to filter by the type of object for the specified token utilization bucket."
        $ObjectTypeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
        $ObjectTypeCollection.Add($ObjectTypeAttribute)

        Switch($Bucket) {
            "Management" {
                ## Object Type ##
                $ObjectTypeValidateSet = New-Object System.Management.Automation.ValidateSetAttribute("Active IPs","DDI","Assets")
                $ObjectTypeCollection.Add($ObjectTypeValidateSet)
                $ObjectTypeParam = New-Object System.Management.Automation.RuntimeDefinedParameter('ObjectType', [string], $ObjectTypeCollection)
                $paramDictionary.Add('ObjectType', $ObjectTypeParam)
            }
            "Server" {
                ## Instance Type ##
                $InstanceTypeAttribute = New-Object System.Management.Automation.ParameterAttribute
                $InstanceTypeAttribute.Position = 3
                $InstanceTypeAttribute.HelpMessage = "The InstanceType parameter is used to filter by the type of instance for the specified token utilization bucket."
                $InstanceTypeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
                $InstanceTypeCollection.Add($InstanceTypeAttribute)
                $InstanceTypeValidateSet = New-Object System.Management.Automation.ValidateSetAttribute("XXS","XS","S","M","L","XL")
                $InstanceTypeCollection.Add($InstanceTypeValidateSet)
                $InstanceTypeParam = New-Object System.Management.Automation.RuntimeDefinedParameter('InstanceType', [string], $InstanceTypeCollection)
                $paramDictionary.Add('InstanceType', $InstanceTypeParam)

                ### Server Type
                $ServerTypeAttribute = New-Object System.Management.Automation.ParameterAttribute
                $ServerTypeAttribute.Position = 4
                $ServerTypeAttribute.HelpMessage = "The ServerType parameter is used to filter by the type of server for the specified token utilization bucket."

                $ServerTypeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
                $ServerTypeCollection.Add($ServerTypeAttribute)

                $ServerTypeValidateSet = New-Object System.Management.Automation.ValidateSetAttribute("Self Managed","As a Service")
                $ServerTypeCollection.Add($ServerTypeValidateSet)

                $ServerTypeParam = New-Object System.Management.Automation.RuntimeDefinedParameter('ServerType', [string], $ServerTypeCollection)
                $paramDictionary.Add('ServerType', $ServerTypeParam)
            }
            "Reporting" {
                ## Object Type ##
                $ObjectTypeValidateSet = New-Object System.Management.Automation.ValidateSetAttribute("Active Search","Ecosystem")
                $ObjectTypeCollection.Add($ObjectTypeValidateSet)
                $ObjectTypeParam = New-Object System.Management.Automation.RuntimeDefinedParameter('ObjectType', [string], $ObjectTypeCollection)
                $paramDictionary.Add('ObjectType', $ObjectTypeParam)
            }
        }
        return $paramDictionary
    }

    process {
        Switch($Bucket) {
            "Management" {
                switch ($Granularity) {
                    "now" {
                        $Result = Invoke-B1CubeJS -Cube TokenUtilManagement -Measures tokens -Dimensions timestamp,object_type -Grouped -Start $Start -End $End -TimeDimension timestamp
                    }
                    "daily" {
                        $Result = Invoke-B1CubeJS -Cube TokenUtilManagementDaily -Measures tokens -Dimensions timestamp,object_type -Grouped -Start $Start -End $End -TimeDimension timestamp
                    }
                    "monthly" {
                        $Result = Invoke-B1CubeJS -Cube TokenUtilManagementMonthly -Measures tokens -Dimensions timestamp,object_type -Grouped -Start $Start -End $End -TimeDimension timestamp
                    }
                }
                if ($PSBoundParameters['ObjectType']) {
                    $Result = $Result | Where-Object {$_.object_type -eq $PSBoundParameters['ObjectType']}
                }
                $Result | Select-Object timestamp,object_type,tokens | Sort-Object timestamp
            }
            "Server" {
                switch ($Granularity) {
                    "now" {
                        $SelfManaged = Invoke-B1CubeJS -Cube TokenUtilProtoSrvSM -Measures count,tokens -Dimensions timestamp,instance_type -Grouped -Start $Start -End $End -TimeDimension timestamp
                        $AsAService = Invoke-B1CubeJS -Cube TokenUtilProtoSrvAAS -Measures count,tokens -Dimensions timestamp,instance_type -Grouped -Start $Start -End $End -TimeDimension timestamp
                    }
                    "daily" {
                        $SelfManaged = Invoke-B1CubeJS -Cube TokenUtilProtoSrvSMDaily -Measures count,tokens -Dimensions timestamp,instance_type -Grouped -Start $Start -End $End -TimeDimension timestamp
                        $AsAService = Invoke-B1CubeJS -Cube TokenUtilProtoSrvAASDaily -Measures count,tokens -Dimensions timestamp,instance_type -Grouped -Start $Start -End $End -TimeDimension timestamp
                    }
                    "monthly" {
                        $SelfManaged = Invoke-B1CubeJS -Cube TokenUtilProtoSrvSMMonthly -Measures count,tokens -Dimensions timestamp,instance_type -Grouped -Start $Start -End $End -TimeDimension timestamp
                        $AsAService = Invoke-B1CubeJS -Cube TokenUtilProtoSrvAASMonthly -Measures count,tokens -Dimensions timestamp,instance_type -Grouped -Start $Start -End $End -TimeDimension timestamp
                    }
                }
                $SelfManaged | ForEach-Object {
                    $_ | Add-Member -MemberType NoteProperty -Name 'server_type' -Value "Self Managed" -Force
                }
                $AsAService | ForEach-Object {
                    $_ | Add-Member -MemberType NoteProperty -Name 'server_type' -Value "As a Service" -Force
                }
                if ($PSBoundParameters['ServerType']) {
                    $SelfManaged = $SelfManaged | Where-Object {$_.server_type -eq $PSBoundParameters['ServerType']}
                    $AsAService = $AsAService | Where-Object {$_.server_type -eq $PSBoundParameters['ServerType']}
                }
                if ($PSBoundParameters['InstanceType']) {
                    $SelfManaged = $SelfManaged | Where-Object {$_.instance_type -eq $PSBoundParameters['InstanceType']}
                    $AsAService = $AsAService | Where-Object {$_.instance_type -eq $PSBoundParameters['InstanceType']}
                }
                $Result = $SelfManaged + $AsAService
                $Result | Select-Object timestamp,instance_type,count,server_type,tokens | Sort-Object timestamp

            }
            "Reporting" {
                Write-Warning 'Not implemented'
            }
        }
    }
}