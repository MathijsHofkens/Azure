$vms = get-azurermvm
$alertName = "Threshold_Alert_Memory_Over_85"
$metricName = "\Memory\% Committed Bytes In Use"
$alertDescription = "Memory Percentage > 85%"
$email = "mathijs.hofkens@realdolmen.com" 

$action = New-AzureRmAlertRuleEmail -CustomEmails $email
foreach ($vm in $vms){
    Add-AzureRmMetricAlertRule -Name $($vm.Name + '_' + $alertName) -Location $vm.Location -ResourceGroup $vm.ResourceGroupName -Description $alertDescription -WindowSize 00:15:00 -TargetResourceId $vm.Id -Operator GreaterThan -Threshold 85 -MetricName $metricName -TimeAggregationOperator Average -Actions $action -Verbose
}
