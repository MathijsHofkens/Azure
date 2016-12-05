$vms = get-azurermvm
$alertName = "Threshold_Alert_CPU_Over_85"
$metricName = "\Processor(_Total)\% Processor Time"
$alertDescription = "CPU Percentage > 85%"
$email = "" 

$action = New-AzureRmAlertRuleEmail -CustomEmails $email
foreach ($vm in $vms){
    Add-AzureRmMetricAlertRule -Name $alertName -Location $vm.Location -ResourceGroup $vm.ResourceGroupName -Description $alertDescription -WindowSize 00:15:00 -TargetResourceId $vm.Id -Operator GreaterThan -Threshold 85 -MetricName $metricName -TimeAggregationOperator Average -Actions $action -Verbose
}
