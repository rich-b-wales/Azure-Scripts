$report = @()
$csv = Import-Csv c:\temp\ad-groups-26-07.csv
$csv.ObjectId | ForEach-Object {
    # In here, we do whatever want to the 'cell' that's currently in the pipeline
    # For now, let's just output it.
    $_
    $groupmembers = get-azureadgroupmember -ObjectId $_
    $groupname = Get-AzureADGroup -objectid $_
   
   foreach ($groupmember in $groupmembers) {
      
    $reportoutput = New-Object psobject
    $reportoutput | Add-member NoteProperty "Group Name" $groupname.displayname
    $reportoutput | Add-member NoteProperty "Name" $groupmember.displayname
    $reportoutput | Add-member NoteProperty "UPN" $groupmember.Userprincipalname
    $report += $reportoutput
    }
    }
    
    $report |Format-table
$report | Export-Csv -NoTypeInformation "c:\temp\groupmembers-26-07.csv"




    # And to prove that we processed each 'cell' one at a time, let's also output...
  
