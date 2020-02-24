$subs = Get-AzureRmSubscription 
$report = @()
foreach ($Sub in $Subs) { 
    $SelectSub = Select-AzureRmSubscription -SubscriptionName $Sub.Name 
      $reportoutput = New-Object psobject
    $reportoutput | Add-member NoteProperty "Subscription" $sub.Name
    $reportoutput | Add-member NoteProperty "Subscription ID" $sub.SubscriptionId
    $report += $reportoutput
        } 
$Report
$report | Export-Csv "c:\temp\Sub-scriptions-04-02-2020.csv"

