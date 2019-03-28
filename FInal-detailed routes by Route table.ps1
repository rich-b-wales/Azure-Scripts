# This code displays a list of all the routes that exist in a routing table
$report = @()
$subs = Get-AzureRmSubscription 
foreach ($Sub in $Subs) { 
   $SelectSub = Select-AzureRmSubscription -SubscriptionName $Sub.Name 
   $routes=Get-AzureRmRouteTable
   foreach ($route in $routes) {
   $details2 =Get-AzureRmRouteTable -ResourceGroupName $route.ResourceGroupName -name $route.Name
    $routetables = $details2.Routes
    foreach ($detailedroute in $routetables) {
    $reportoutput = New-Object psobject
    $reportoutput | Add-member NoteProperty "Route table" $details2.Name
    $reportoutput | Add-member Noteproperty "Address Prefix" $detailedroute.AddressPrefix
    $reportoutput | Add-member Noteproperty "Name" $detailedroute.Name
    $reportoutput | Add-Member Noteproperty "Next Hop Type" $detailedroute.NextHopType
    $reportoutput | Add-Member NoteProperty "Next Hop IP Address" $detailedroute.NextHopIpAddress
    $report += $reportoutput
    }
    }
    }
  
        
#$report
$report | Export-Csv -NoTypeInformation "routes in a route table.csv"