function Get-B1Asset {
    <#
    .SYNOPSIS
        Queries a list of Assets discovered by BloxOne

    .DESCRIPTION
        This function is used to query a list of Assets discovered by BloxOne

    .PARAMETER Summary
        Provides a summary of discovered asset counts by category

    .EXAMPLE
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Discovery

    #>
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





    # $Filters = @(
    #     @{
    #         "member" = "asset_daily_counts.asset_context"
    #         "operator" = "equals"
    #         "values" = @("cloud","onprem")
    #     }
    # )
    # Invoke-B1CubeJS -Cube asset_daily_counts -Measures asset_count -Dimensions asset_context -TimeDimension asset_date -Granularity day -Start (Get-Date).AddDays(-30) -Filters $Filters -Grouped

}