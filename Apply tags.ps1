# Login with your account
Login-AzureRmAccount

# Get all your available azure subscriptions, copy the ID of the subscription you need
Get-AzureRmSubscription | ft

# Paste the needed subscription id in the field below 
Select-AzureRmSubscription -SubscriptionId ""

# Get all VMs per environment
$DevelopmentVMs = Get-AzureRmVM | ? {$_.Name -like "ENH-D*"}
$AcceptanceVMs = Get-AzureRmVM | ? {$_.Name -like "ENH-A*"}

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



