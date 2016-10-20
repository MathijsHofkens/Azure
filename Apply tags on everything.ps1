# Login with your account
Login-AzureRmAccount

# Get all your available azure subscriptions and select the one you need
Get-AzureRmSubscription | Out-GridView -PassThru | Select-AzureRmSubscription

# Get all VMs per environment
$resources = Get-AzureRmResource

# Apply tag on every development VM
foreach ($res in $resources)
{
    Set-AzureRmResource -Tag @{Name="Environment"; Value="Development"} -ResourceId $res.ResourceId -Force -Verbose
}

