$subs = Get-AzureRmSubscription 
$report = @()
foreach ($Sub in $Subs) { 
    $SelectSub = Select-AzureRmSubscription -SubscriptionName $Sub.Name 
    $VNETs = Get-AzureRmVirtualNetwork 
    foreach ($VNET in $VNETs) { 
    $vnetpeerinfo = Get-AzureRmVirtualNetworkPeering -ResourceGroupName $vnet.ResourceGroupName -VirtualNetworkName $vnet.name
    $reportoutput = New-Object psobject
    $reportoutput | Add-member NoteProperty "VNET NAme" $VNET.name
    $Vnetpeerlist=@($VNETpeerinfo.Name)
    $vnetpeerlist=$Vnetpeerlist -join ' , '
    $reportoutput | Add-member NoteProperty "Vnet peering" $VNETpeerlist
    $report += $reportoutput
        } 
        } 
$Report
$report | Export-Csv "vnet Peering by Vnet.csv"