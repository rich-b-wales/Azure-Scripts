$subs = Get-AzureRmSubscription 
$report = @()
foreach ($Sub in $Subs) { 
    $SelectSub = Select-AzureRmSubscription -SubscriptionName $Sub.Name 
    $VNETs = Get-AzureRmVirtualNetwork 
    foreach ($VNET in $VNETs) { 
    $Subnets = $VNET.Subnets
    Foreach ($subnet in $Subnets) {
    $reportoutput = New-Object psobject
    $reportoutput | Add-member NoteProperty "Subscription Name" $sub.name
    $reportoutput | Add-member NoteProperty "Vnet Name" $VNET.name
    $reportoutput | Add-member NoteProperty "Subnet Name" $subnet.name
    $subnetarray=@($subnet.AddressPrefix)
    $subnetarray= $subnetarray -join '-'
    $reportoutput | Add-member NoteProperty "Subnet" $subnetarray
    #write-output $subnet.RouteTable.id
    $reportoutput | Add-Member Noteproperty "route Table" $subnet.RouteTable.ID
    $tablename = $subnet.routetable.id -replace '.*/'
     $reportoutput | add-member Noteproperty "route table short" $tablename
       $report += $reportoutput
        } 
        }
} 
$Report
$report | Export-Csv -NoTypeInformation "subnets with Route table.csv"