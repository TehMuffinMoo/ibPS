function Set-B1FixedAddress {
    <#
    .SYNOPSIS
        Updates an existing fixed addresses in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to update an existing fixed addresses in BloxOneDDI IPAM

    .PARAMETER IP
        The IP of the fixed address

    .PARAMETER Name
        The name of the fixed address

    .PARAMETER NewName
        The new name for the fixed address

    .PARAMETER Description
        The new description of the fixed address

    .PARAMETER MatchType
        The match type for the new fixed address (i.e MAC)

    .PARAMETER MatchValue
        The match value for the new fixed address (i.e ab:cd:ef:ab:cd:ef)

    .PARAMETER DHCPOptions
        A list of DHCP Options you want to apply to the existing fixed address. This will overwrite any existing DHCP options.

    .PARAMETER Tags
        Any tags you want to apply to the fixed address

    .PARAMETER Space
        Use this parameter to filter the list of fixed addresses by Space

    .PARAMETER Object
        The Fixed Address Object to update. Accepts pipeline input

    .EXAMPLE
        PS> Set-B1FixedAddress -IP 10.10.100.12 -Name "New name" -Description "A new description"

    .EXAMPLE
        PS> Get-B1FixedAddress -IP 10.10.100.12 | Set-B1FixedAddress -MatchValue "ab:cd:ef:ab:cd:ef"

    .EXAMPLE
        ## Example usage when combined with Get-B1DHCPOptionCode

        $DHCPOptions = @()
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

        PS> Set-B1FixedAddress -IP 10.10.100.12 -Name "New name" -Description "A new description" -DHCPOptions $DHCPOptions

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DHCP
    #>
    param(
      [Parameter(ParameterSetName="IP",Mandatory=$true)]
      [String]$IP = $null,
      [Parameter(ParameterSetName="Name",Mandatory=$true)]
      [String]$Name,
      [Parameter(ParameterSetName="IP",Mandatory=$true)]
      [Parameter(ParameterSetName="Name",Mandatory=$true)]
      [String]$Space,
      [String]$NewName,
      [String]$Description,
      [ValidateSet("mac","client_text","client_hex","relay_text","relay_hex")]
      [String]$MatchType,
      [String]$MatchValue,
      [System.Object]$DHCPOptions,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Object",
        Mandatory=$true
      )]
      [System.Object]$Object
    )

    process {
      if ($Object) {
          $SplitID = $Object.id.split('/')
          if (("$($SplitID[0])/$($SplitID[1])") -ne "dhcp/fixed_address") {
              Write-Error "Error. Unsupported pipeline object. This function only supports 'dhcp/fixed_address' objects as input"
              return $null
          }
      } else {
          $Object = Get-B1FixedAddress -IP $IP -Space $Space -Name $Name -Strict
          if (!($Object)) {
              Write-Error "Unable to find Fixed Address: $($IP)$($Name) in Space: $($Space)"
              return $null
          }
      }
      $NewObj = $Object | Select-Object * -ExcludeProperty id,inheritance_assigned_hosts,inheritance_parent,inheritance_sources,parent

      if ($NewName) {
        $NewObj.name = $NewName
      }
      if ($Description) {
        $NewObj.comment = $Description
      }
      if ($MatchType) {
        $NewObj.match_type = $MatchType
      }
      if ($MatchValue) {
        $NewObj.match_value = $MatchValue
      }
      if ($DHCPOptions) {
        $NewObj.dhcp_options = $DHCPOptions
      }
      if ($Tags) {
        $NewObj.tags = $Tags
      }
      $JSON = $NewObj | ConvertTo-Json -Depth 10 -Compress
      $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
      if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
        $Results | Select-Object -ExpandProperty result
      } else {
          $Results
      }
    }
}