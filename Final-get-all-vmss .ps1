# This code extracts information about the AKS environment. 
$report = @()
$report2 =@()
$subs = Get-AzSubscription 
 
foreach ($Sub in $Subs) { 
   #Set the subscription to be checked
   $SelectSub = Select-AzSubscription -SubscriptionName $Sub.Name 

   
   # The below command extracts high level information about the Scalesets. .
   # This currently only works for a single node pool per AKS instance. 
   $vmss=Get-AzVMss
   foreach($item in $vmss){
   $reportoutput2 = New-Object psobject
   $reportoutput2 | Add-member NoteProperty "Subscription" $Sub.Name
   $reportoutput2 | Add-member NoteProperty "ResourceGroup" $Sub.Name
   $reportoutput2 | Add-Member NoteProperty "VMScalesetname" $item.Name
   $reportoutput2 | Add-member NoteProperty "Machine type" $item.sku.name
   $reportoutput2 | Add-member NoteProperty "Capacity" $item.sku.capacity
   $report2 += $reportoutput2
   
   # The below command extracts information about every node that is currrently active in a scaleset.
    $vmssinstances = Get-AzVmssVM -ResourceGroupName $item.ResourceGroupName -VMScaleSetName $item.Name
    Foreach($vmssinstance in $vmssinstances){
    $reportoutput = New-Object psobject
    $reportoutput | Add-member NoteProperty "Subscription" $Sub.Name
    $reportoutput | Add-member NoteProperty "Resource Group" $item.ResourceGroupName
    $reportoutput | Add-member NoteProperty "VMscalesetname" $vmssinstance.Name
    $reportoutput | Add-member NoteProperty "VM Instance" $vmssinstance.InstanceID
    $reportoutput | Add-member Noteproperty "Location" $vmssinstance.Location
    $reportoutput | Add-member Noteproperty "SKU" $vmssinstance.sku.name
    $reportoutput | Add-member Noteproperty "State" $vmssinstance.provisioningstate
     $report += $reportoutput
     }
     }
   }


#$report |Format-table
$report | Export-Csv -NoTypeInformation "c:\temp\vmss-Sever-listing.csv"
#$report2 | Format-table
$report2 | Export-Csv -NoTypeInformation "c:\temp\vmss-VMSS-Summary.csv"
