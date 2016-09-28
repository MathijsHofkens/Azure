Login-AzureRmAccount
Get-AzureRmSubscription | Out-GridView -PassThru | Select-AzureRmSubscription

## Params
$recoveryVaultName = "RecoveryServices"
$rg = Get-AzureRmResourceGroup | out-gridview -PassThru
$location = Get-AzureRmLocation | Out-GridView -PassThru

New-AzureRmRecoveryServicesVault -Name $recoveryVaultName -ResourceGroupName $rg.ResourceGroupName -Location $location.Location -Verbose
