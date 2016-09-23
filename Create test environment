Login-AzureRmAccount
Get-AzureRmSubscription | Out-GridView -PassThru | Select-AzureRmSubscription

## PARAMETERS
$rgName = "ApplicationA"
$location = Get-AzureRmLocation | Out-GridView -PassThru
$vnetName = "VNET"
$vnetPrefix = "192.168.0.0/16"
$subnetAName = "Backend"
$subnetAPrefix = "192.168.0.0/24"
$subnetBName = "Frontend"
$SubnetBPrefix = "192.168.1.0/24"
$subnetCName = "DMZ"
$subnetCPrefix = "192.168.2.0/24"
$storageAccVHDName = "appavhd"
$storageAccDiagName = "appadiag"
$vmAName = "DC01"
$vmSizes = Get-AzureRmVMSize -Location $location.Location

## Create ResourceGroup
New-AzureRmResourceGroup -Name $rgName -Location $location.Location -Verbose

### Network Config
## Create Network
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location.Location -AddressPrefix $vnetPrefix -Verbose

## Create Subnets
Add-AzureRmVirtualNetworkSubnetConfig -Name $subnetAName -VirtualNetwork $vnet -AddressPrefix $subnetAPrefix -Verbose
Add-AzureRmVirtualNetworkSubnetConfig -Name $subnetBName -VirtualNetwork $vnet -AddressPrefix $subnetBPrefix -Verbose
Add-AzureRmVirtualNetworkSubnetConfig -Name $subnetCName -VirtualNetwork $vnet -AddressPrefix $subnetCPrefix -Verbose
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet -Verbose


### Storage Config
## Create Storage Accounts
$storageAccVHD = New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $storageAccVHDName -SkuName Standard_LRS -Location $location.Location -Kind Storage -Verbose
Get-AzureRmStorageAccount | ft
$storageAccDiag = New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $storageAccDiagName -SkuName Standard_LRS -Location $location.Location -Kind Storage -Verbose

### VM Config
# Create a public IP for VM A
$vmApipName = $vmAName + "-PUBIP"
$vmApip = New-AzureRmPublicIpAddress -Name $vmApipName.ToUpper() -ResourceGroupName $rgName -Location $location.Location -AllocationMethod Dynamic

# Create a NIC for VM A
$vmAnicName = $vmAName + "-NIC1"
$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName
$subnetAid = (Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName).Subnets[0].Id

$vmanicConfigName = $vmAnicName + "-config"
$vmAnicConfig = New-AzureRmNetworkInterfaceIpConfig -Name $vmanicConfigName -PrivateIpAddressVersion IPv4 -SubnetId $subnetAid -PublicIpAddressId $vmApip.Id
$vmAnic = New-AzureRmNetworkInterface -Name $vmAnicName -ResourceGroupName $rgName -Location $location.Location -IpConfiguration $vmaNicConfig

$vmAnic.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
Set-AzureRmNetworkInterface -NetworkInterface $vmAnic

# Create VM A config
$vmASize = $vmSizes | Out-GridView -Title "Choose the VM size" -PassThru
$credvma = Get-Credential -Message "Type the name and password of the local administrator account."
$vmA = New-AzureRmVMConfig -VMName $vmAName -VMSize $vmASize.Name -Verbose
$vmA = Set-AzureRmVMOperatingSystem -VM $vmA -Windows -ComputerName $vmAName -Credential $credvma -ProvisionVMAgent -EnableAutoUpdate -TimeZone "Romance Standard Time" -Verbose
$vmA = Set-AzureRmVMSourceImage -VM $vmA -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest" -Verbose
$vmA = Add-AzureRmVMNetworkInterface -vm $vmA -Id $vmAnic.Id

# Create proper name for OS disk, VM A
$blobPath = "vhds/" + $vmAName + "osdisk.vhd"
$osDiskUri = $storageAccVHD.PrimaryEndpoints.Blob.ToString() + $blobPath
$vmAdiskName = $vmAName + "osdisk"
$vmA = Set-AzureRmVMOSDisk -VM $vmA -Name $vmAdiskName -VhdUri $osDiskUri -CreateOption fromImage

# Create VM A
New-AzureRmVM -ResourceGroupName $rgName -Location $location.Location -VM $vmA -Verbose

# Configure Diagnostics
$vmA.DiagnosticsProfile.BootDiagnostics.StorageUri = "https://" + $storageAccDiagName + ".blob.core.windows.net/"
$vmA = Get-AzureRmVM -ResourceGroupName $rgName -Name $vmAName -Verbose
Update-AzureRmVM -VM $vmA -ResourceGroupName $rgName
