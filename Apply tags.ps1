# Login with your account
Login-AzureRmAccount

# Get all your available azure subscriptions and select the one you need
Get-AzureRmSubscription | Out-GridView -PassThru | Select-AzureRmSubscription

# Get all VMs per environment
$DevelopmentVMs = Get-AzureRmVM | ? {$_.Name -like "..."}
$AcceptanceVMs = Get-AzureRmVM | ? {$_.Name -like "..."}

# Apply tag on every development VM
foreach ($devvm in $DevelopmentVMs)
{
    Set-AzureRmResource -Tag @{Name="Environment"; Value="Development"} -ResourceId $devvm.Id -Force -Verbose
}

# Apply tag on every acceptance VM
foreach ($accvm in $AcceptanceVMs)
{
    Set-AzureRmResource -Tag @{Name="Environment"; Value="Acceptance"} -ResourceId $accvm.Id -Force -Verbose
}



