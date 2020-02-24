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