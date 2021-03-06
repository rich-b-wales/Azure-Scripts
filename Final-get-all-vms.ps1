﻿# This code extracts virtual machine information and stores in a csv file located in c:\temp
$report = @()
$subs = Get-AzureRmSubscription 
foreach ($Sub in $Subs) { 
   $SelectSub = Select-AzureRmSubscription -SubscriptionName $Sub.Name 
   $vms=Get-AzurermVM
   foreach ($vm in $vms) {
    $sizeinfo=Get-AzureRmVMSize -VMName $vm.Name -ResourceGroupName $vm.ResourceGroupName | Where-Object {$_.Name -eq $vm.HardwareProfile.VmSize}
    $privateIP = (Get-AzureRmNetworkInterface | Where-Object {$_.id -eq $vm.NetworkProfile.NetworkInterfaces[0].id}).IpConfigurations[0].PrivateIpAddress
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
    
  
        
$report |Format-table
$report | Export-Csv -NoTypeInformation "c:\temp\azure-vm.csv"
