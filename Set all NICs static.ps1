# Login with your account
Login-AzureRmAccount

# Get all your available azure subscriptions and select the one you need
Get-AzureRmSubscription | Out-GridView -PassThru | Select-AzureRmSubscription

# Get all your VMs
$vms = Get-AzureRmVM
# Get all your NetworkInterfaces
$allNics = Get-AzureRmNetworkInterface

# Loop all your NICs, if the PRIMARY configuration of this NIC is dynamic, set it to static
foreach ($nic in $allNics){
    $ipconfig = Get-AzureRmNetworkInterfaceIpConfig -NetworkInterface $nic
    if ($ipconfig.PrivateIpAllocationMethod -eq "Dynamic"){
        $ipconfig.Name + " has a dynamic internal IP! Setting it to static ..."
        $nic.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
        Set-AzureRmNetworkInterface -NetworkInterface $nic
    }
}
