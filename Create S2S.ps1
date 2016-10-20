Login-AzureRmAccount
Get-AzureRmSubscription | Out-GridView -PassThru | Select-AzureRmSubscription

## PARAMETERS
$rgName = "S2S"
$location = Get-AzureRmLocation | Out-GridView -PassThru
$vnetName = "vnet"
$vnetPrefix = "192.168.0.0/16"
$subnetAName = "backend"
$subnetAPrefix = "192.168.0.0/24"
$subnetBName = "frontend"
$SubnetBPrefix = "192.168.1.0/24"
$subnetCName = "dmz"
$subnetCPrefix = "192.168.2.0/24"
$gwSubnetName = "GatewaySubnet"
$gwSubnetPrefix = "192.168.254.0/24"
$LocalGatewayName = "local-gw"
$LocalGatewayIP = "" 
$LocalGatewayAddressPrefix = "10.0.0.0/24"
$gwPubIPName = "gw-pip"
$gWIPconfigName = "gw-pip-config"
$gwName = "azure-gw"

## Create ResourceGroup
New-AzureRmResourceGroup -Name $rgName -Location $location.Location -Verbose

### Network Config
## Create Network
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location.Location -AddressPrefix $vnetPrefix -Verbose

## Create Subnets
Add-AzureRmVirtualNetworkSubnetConfig -Name $subnetAName -VirtualNetwork $vnet -AddressPrefix $subnetAPrefix -Verbose
Add-AzureRmVirtualNetworkSubnetConfig -Name $subnetBName -VirtualNetwork $vnet -AddressPrefix $subnetBPrefix -Verbose
Add-AzureRmVirtualNetworkSubnetConfig -Name $subnetCName -VirtualNetwork $vnet -AddressPrefix $subnetCPrefix -Verbose
Add-AzureRmVirtualNetworkSubnetConfig -Name $gwSubnetName -VirtualNetwork $vnet -AddressPrefix $gwSubnetPrefix -Verbose
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet -Verbose

# Add your local network gateway
New-AzureRmLocalNetworkGateway -Name $LocalGatewayName -ResourceGroupName $rgName -Location $location.Location -GatewayIpAddress $LocalGatewayIP -AddressPrefix $LocalGatewayAddressPrefix -Verbose

# Request a public IP address for the VPN gateway
$gwPip = New-AzureRmPublicIpAddress -Name $gwPubIPName  -ResourceGroupName $rgName -Location $location.Location -AllocationMethod Dynamic -Verbose

# Create the gateway IP addressing configuration
$vnet = Get-AzureRmVirtualNetwork -Name $VnetName -ResourceGroupName $rgName
$gwSubnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $gwSubnetName -VirtualNetwork $vnet
$gwipconfig = New-AzureRmVirtualNetworkGatewayIpConfig -Name $gWIPconfigName -SubnetId $gwSubnet.Id -PublicIpAddressId $gwPip.Id 

# Create the virtual network gateway
New-AzureRmVirtualNetworkGateway -Name $gwName -ResourceGroupName $rgName -Location $location.Location -IpConfigurations $gwipconfig -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard
