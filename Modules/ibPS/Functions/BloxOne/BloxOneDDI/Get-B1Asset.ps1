function Get-B1AssetSummary {
    <#
    .SYNOPSIS
        Summerise a list of Assets discovered by BloxOne

    .DESCRIPTION
        This function is used to summerise a list of Assets discovered by BloxOne

    .EXAMPLE
        Get-B1Asset ByRegion

        assets doc_asset_region doc_asset_vendor
        ------ ---------------- ----------------
        140    us-east-1        aws
        121    us-east-2        aws
        68     us-west-1        aws
        42     us-west-2        aws
        23     eu-north-1       aws
        18     ap-southeast-2   aws
        18     eu-west-1        aws
        10                      azure
        7                       aws
        17     ap-northeast-1   aws
        14     ap-northeast-2   aws
        13     westeurope       azure
        12     ap-northeast-3   aws
        12     ap-south-1       aws
        12     ap-southeast-1   aws
        12     ca-central-1     aws
        12     eu-west-2        aws
        12     eu-west-3        aws
        12     sa-east-1        aws
        7      global           azure
        6      eu-central-1     aws
        1      uksouth          azure

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Discovery

    #>
    [CmdletBinding()]
    param(
      [ValidateSet('ByCategory','ByVendor','ByRegion','ByAccount')]
      [String]$Type
    )
    Switch($Type) {
        "ByCategory" {
            ## List Asset Count, Category & Context
            Invoke-B1CubeJS -Cube CloudDiscoveryResources -Measures assets -Dimensions doc_asset_category,doc_asset_context -Segments countable -Grouped
            break
        }
        "ByVendor" {
            # List Cloud Asset Count by Vendor
            $Filters = @(
                @{
                    "member" = "CloudDiscoveryResources.doc_asset_vendor"
                    "operator" = "set"
                }
                @{
                    "member" = "CloudDiscoveryResources.doc_asset_context"
                    "operator" = "equals"
                    "values" = @("cloud")
                }
            )
            Invoke-B1CubeJS -Cube CloudDiscoveryResources -Measures assets -Dimensions doc_asset_vendor -Segments countable -Filters $Filters -Grouped
            break
        }
        "ByRegion" {
            # List Cloud Asset Count by Region & Vendor
            $Filters = @(
                @{
                    "member" = "CloudDiscoveryResources.doc_asset_context"
                    "operator" = "equals"
                    "values" = @("cloud")
                }
            )
            Invoke-B1CubeJS -Cube CloudDiscoveryResources -Measures assets -Dimensions doc_asset_region,doc_asset_vendor -Segments countable -Filters $Filters -Grouped
            break
        }
        "ByAccount" {
            # List Cloud Asset Count by Azure Subscription, GCP Project and AWS Account ID.
            $Filters = @(
                @{
                    "member" = "CloudDiscoveryResources.doc_asset_context"
                    "operator" = "equals"
                    "values" = @("cloud")
                }
            )
            Invoke-B1CubeJS -Cube CloudDiscoveryResources -Measures assets -Dimensions doc_asset_aws_account_id,doc_asset_gcp_project_id,doc_asset_azure_subscription_id,doc_asset_vendor -Filters $Filters -Segments countable -Grouped
            break
        }
    }
}