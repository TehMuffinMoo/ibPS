function Clear-FederatedGrid {
    param (
    )
    
    $ENV:B1FederatedGrid = $null
    Write-Host "Selected Federated Grid Cleared." -ForegroundColor Green
}