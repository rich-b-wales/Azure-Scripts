$report1 = @()
$subs = Get-AzSubscription 
 
foreach ($Sub in $Subs) { 
   #Set the subscription to be checked
   $SelectSub = Select-AzSubscription -SubscriptionName $Sub.Name 

   #Extract high level app GW information     
   $appgws = get-azapplicationgateway

   foreach($appgw in $appgws){
   #Loop the appgw and collect the information needed. 
   $AppGwdetail = Get-AzApplicationGateway -Name $appgw.name -ResourceGroupName $appgw.ResourceGroupName
   $SettingsList  = Get-AzApplicationGatewayBackendHttpSetting -ApplicationGateway $AppGwdetail

   #Output data needed. 
   $reportoutput1 = New-Object psobject
   $reportoutput1 | Add-member NoteProperty "Subscription" $Sub.Name
   $reportoutput1 | Add-member NoteProperty "ResourceGroup" $appgw.ResourceGroupName
   $reportoutput1 | Add-Member NoteProperty "AppGwy Name" $appgw.name
   $reportoutput1 | Add-member NoteProperty "Cookie Setting" $SettingsList.CookieBasedAffinity
   $report1 += $reportoutput1
   }

}
      
#Write Values to a file.
$report1 | Export-csv -NoTypeInformation "c:\temp\Appgw-cookie-infitity.csv"

