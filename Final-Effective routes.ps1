
$subs = Get-AzureRmSubscription 
$report = @()
foreach ($Sub in $Subs) { 
    $SelectSub = Select-AzureRmSubscription -SubscriptionName $Sub.Name 
    $vms = GET-AZURERMVM 
    foreach ($VM in $VMS) {
    $NICNAME = $VM.NetworkProfile.NetworkInterfaces.id -replace '.*/'
    #$NICNAME
    $routetable = Get-AzureRmEffectiveRouteTable -NetworkInterfaceName $nicname -ResourceGroupName  $vm.ResourceGroupName | Select-Object -PROPERTY NAME, ADDRESSPREFIX, STATE, SOURCE, nEXTHOPTYPE
    #$routetable 
    $routecount=0
    While ($routecount -lt $routetable.count) {
    #$routecount
    $reportoutput = New-Object psobject
    $reportoutput | Add-member NoteProperty "Subscription Name" $Sub.Name
    $reportoutput | Add-member NoteProperty "Resource Group Name" $vm.ResourceGroupName
    $reportoutput | Add-member NoteProperty "VMName" $vm.name
    $reportoutput | Add-member NoteProperty "Nic Name" $Nicname
    $reportoutput | Add-member NoteProperty "State" $routetable[$routecount].state
    $reportoutput | Add-member NoteProperty "Source" $routetable[$routecount].source
    $reportoutput | Add-member NoteProperty "Next Hop type" $routetable[$routecount].nexthoptype
    $subnetarray=@($Routetable[$routecount].AddressPrefix)
    $subnetarray= $subnetarray -join '-'
    $reportoutput | Add-member NoteProperty "Subnet" $subnetarray
    #write-output $subnet.RouteTable.id
    #$reportoutput | Add-Member Noteproperty "route Table" $subnet.RouteTable.ID
    #$tablename = $subnet.routetable.id -replace '.*/'
     #$reportoutput | add-member Noteproperty "route table short" $tablename
       $report += $reportoutput
    $routecount++
    }
     
        }
} 
#$Report
$report | Export-Csv -NoTypeInformation "c:\temp\effective-routes.csv"