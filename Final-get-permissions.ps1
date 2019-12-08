# This code displays a list of all the routes that exist in a routing table
$report = @()
$subs = Get-AzureRmSubscription 
foreach ($Sub in $Subs) { 
   $SelectSub = Select-AzureRmSubscription -SubscriptionName $Sub.Name 
   $roles=Get-AzureRmroleassignment
   $subid=$Sub.id
   $scope="/subscriptions/"+$subid
   echo "SCOP" $scope
   foreach ($role in $roles) 
    {
   if ($role.scope -eq $scope -OR $role.scope -like "*/providers/Microsoft.Management/managementGroups*") 
    {
    $ln = $role.SignInName
    $ln = if ($role.SignInName -eq $null) 
    {$ln="Group"} 
    else 
    {$ln}
    
$reportoutput = New-Object psobject
    $reportoutput | Add-member NoteProperty "Resource Group" $sub.NAme
    $reportoutput | Add-member NoteProperty "Role Name" $role.displayname
    $reportoutput | Add-member NoteProperty "Permissions Name" $role.RoleDefinitionName
    $reportoutput | Add-Member NoteProperty " Login Name" $ln
    $reportoutput | Add-Member NoteProperty " Object Type" $role.ObjectType
    $reportoutput | Add-member NoteProperty "Scope" $role.scope
    $report += $reportoutput
    }
	else 
    {echo "SKIPPING########################"}
    }
    }
  
        
$report |Format-table
$report | Export-Csv -NoTypeInformation "c:\temp\permissions-all-04-09.csv"