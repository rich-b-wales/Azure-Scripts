# This code displays a list of all the routes that exist in a routing table
$report = @()
$subs = Get-AzureRmSubscription 
foreach ($Sub in $Subs) { 
   $SelectSub = Select-AzureRmSubscription -SubscriptionName $Sub.Name 
   $roles=Get-AzureRmroleassignment
   foreach ($role in $roles) {
    $ln = $role.SignInName
    $ln = if ($role.SignInName -eq $null) {$ln="Group"} else {$ln}
    
$reportoutput = New-Object psobject
    $reportoutput | Add-member NoteProperty "Resource Group" $sub.name
    $reportoutput | Add-member NoteProperty "Role Name" $role.displayname
    $reportoutput | Add-member NoteProperty "Permissions Name" $role.RoleDefinitionName
    $reportoutput | Add-Member NoteProperty " Login Name" $ln
    $report += $reportoutput
    }
    }
    
  
        
$report |Format-table
$report | Export-Csv -NoTypeInformation "c:\temp\permissions.csv"