trigger NEU_AssignCreateRouteFromTraffic on Traffic__c (before insert, before update) 
{
	if(!RecursiveCheck.triggerMonitor.contains('NEU_AssignCreateRouteFromTraffic')){
        RecursiveCheck.triggerMonitor.add('NEU_AssignCreateRouteFromTraffic');
		for(Traffic__c traffic : trigger.new)
		{
			if(traffic.Site_of_Load__c != null && traffic.Site_of_Discharge__c != null)
			{
				List<Carrier_Line_Load_Point__c> routes = [select Id, Name 
				from Carrier_Line_Load_Point__c where Port_Airport_of_Load__c =: traffic.Site_of_Load__c and Port_Airport_of_Discharge__c =: traffic.Site_of_Discharge__c];
				
				if(routes.size() > 0)
					traffic.Route__c = routes[0].Id;
				else
				{
					Carrier_Line_Load_Point__c new_route = new Carrier_Line_Load_Point__c();
					new_route.Country_of_Load__c = traffic.Country_of_Load__c;
					new_route.Country_of_Discharge__c = traffic.Country_of_Discharge__c;
					new_route.State_of_Load__c = traffic.State_of_Load__c;
					new_route.State_of_Discharge__c = traffic.State_of_Discharge__c;
					new_route.Port_Airport_of_Load__c = traffic.Site_of_Load__c;
					new_route.Port_Airport_of_Discharge__c = traffic.Site_of_Discharge__c;
					
					try
					{
						insert new_route;
						traffic.Route__c = new_route.Id;
					}
					catch(Exception ex){trigger.new[0].addError('Error: '+ex);}
				}
			}
		}
	}
}