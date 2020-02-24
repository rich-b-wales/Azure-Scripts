#This Powershell creates all the files needed for the monthly reporting. 
$file1="C:\temp\list-of-vms.csv"
$file2="c:\temp\list-of-aks-instances.csv"
$file3="C:\temp\list-of-vmss-instances.csv"
$file4="C:\temp\list-of-vmss-server-instances.csv"

write-output "Creating List of Virtual Machines"

# This section outputs a list of Virtual machines from all subscriptions
$report = @()
$subs = Get-AzSubscription 

foreach ($Sub in $Subs) {
    $status="Collecting information from " + $sub.name
    Write-output $status 
   $SelectSub = Select-AzSubscription -SubscriptionName $Sub.Name 
   $vms=Get-AzVM
   foreach ($vm in $vms) {
   $status="Collecting information from " + $vm.name
    Write-output $status 
    $sizeinfo=Get-AzVMSize -VMName $vm.Name -ResourceGroupName $vm.ResourceGroupName | Where-Object {$_.Name -eq $vm.HardwareProfile.VmSize}
    $privateIP = (Get-AzNetworkInterface | Where-Object {$_.id -eq $vm.NetworkProfile.NetworkInterfaces[0].id}).IpConfigurations[0].PrivateIpAddress
    $datadisk = ($vm.StorageProfile.datadisks.DiskSizeGB) -join '-'
    $disktypes = ($vm.StorageProfile.DataDisks.manageddisk.storageaccounttype) -join '-' 
    $zones = ($vm.Zones) -join '-' 

    $reportoutput = New-Object psobject
    $reportoutput | Add-member NoteProperty "Subscription" $Sub.Name
    $reportoutput | Add-member NoteProperty "Resource Group" $vm.ResourceGroupName
    $reportoutput | Add-member NoteProperty "VMname" $vm.Name
    $reportoutput | Add-member Noteproperty "OS Type" $vm.storageprofile.osdisk.ostype
    $reportoutput | Add-member Noteproperty "Location" $vm.Location
    $reportoutput | Add-Member Noteproperty "Zone" $zones
    $reportoutput | Add-Member Noteproperty "Size" $vm.hardwareprofile.vmsize
    $reportoutput | Add-Member Noteproperty "CPU (cores)" $sizeinfo.numberofcores
    $reportoutput | Add-Member Noteproperty "Memory (MB)"  $sizeinfo.MemoryInMB
    $reportoutput | Add-Member Noteproperty "Internal IP"  $privateip   
    $reportoutput | Add-Member Noteproperty "OS Disk Size (GB)" $vm.StorageProfile.OsDisk.DiskSizeGB
    $reportoutput | Add-Member Noteproperty "OS Disk Type" $vm.StorageProfile.OsDisk.manageddisk.StorageAccountType
    $reportoutput | Add-Member Noteproperty "Data Disk Size (GB)" $datadisk 
    $reportoutput | Add-Member Noteproperty "Disk Type" $disktypes
    $report += $reportoutput
    }
    }

#$report |Format-table
write-output "exporting list of machines"
$report | Export-Csv -NoTypeInformation $file1


# This code extracts information about the AKS environment. 
write-output "Collating list of AKS instances"
$report1 = @()
$report1 = @()
$subs = Get-AzSubscription 
 
foreach ($Sub in $Subs) { 
   #Set the subscription to be checked
   $SelectSub = Select-AzSubscription -SubscriptionName $Sub.Name 

   # The below command will extract AKS high level information inclding the node pool and also the quantity of machines.
   # This currently only works for a single node pool per AKS instance. 
   $aksinstances = get-azaks
   foreach($aksinstance in $aksinstances){
   $reportoutput1 = New-Object psobject
   $reportoutput1 | Add-member NoteProperty "Subscription" $Sub.Name
   $reportoutput1 | Add-member NoteProperty "ResourceGroup" $Sub.Name
   $reportoutput1 | Add-Member NoteProperty "AKS Name" $aksinstance.Name
   $reportoutput1 | Add-member NoteProperty "Machine Pool Name" $aksinstance.agentpoolprofiles.name
   $Reportoutput1 | Add-Member NoteProperty "Machine Pool Size" $aksinstance.agentpoolprofiles.vmsize
   $reportoutput1 | Add-member NoteProperty "Quantity of Machines" $aksinstance.agentpoolprofiles[0].count
   $report1 += $reportoutput1
   }

}
   
   
write-output "exporting list of AKS Instances"

#$report1 | Format-table
$report1 | Export-csv -NoTypeInformation $file2


# This code extracts information about the AKS environment. 
$report = @()
$report2 =@()
$subs = Get-AzSubscription 
 
 write-output "Collating all VMSS Information"

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

write-output "Exporting VMSS Information"
#$report |Format-table
$report | Export-Csv -NoTypeInformation $file4
#$report2 | Format-table
$report2 | Export-Csv -NoTypeInformation $file3

