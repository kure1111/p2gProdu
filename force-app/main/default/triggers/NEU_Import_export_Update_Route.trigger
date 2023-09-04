trigger NEU_Import_export_Update_Route on Customer_Quote__c (before insert, before update) {

	if(NEU_StaticVariableHelper.getBoolean1())
        return;	
	
	list<Id> import_export_to_update= new list<Id>();

	  
  	if(trigger.isInsert)
  	{
    	for(Customer_Quote__c s : trigger.new)
	    { 
        	if(s.Route__c == null)
	        {
            	if(s.Site_of_Load__c != null && s.Site_of_Discharge__c != null && s.Country_ofLoad__c != null && s.Country_ofDischarge__c != null)
	            {  
              		List<Carrier_Line_Load_Point__c> listado_routes = null;
              		String query = 'select Id, Name, Country_of_Load__c, Port_Airport_of_Load__c, State_of_Load__c, Country_of_Discharge__c,'; 
          			query += ' Port_Airport_of_Discharge__c, State_of_Discharge__c from Carrier_Line_Load_Point__c';
		            query += ' where Country_of_Discharge__c =\''+ s.Country_ofDischarge__c+'\'';
					query += ' and Country_of_Load__c =\''+ s.Country_ofLoad__c+'\'';
					query += ' and Port_Airport_of_Discharge__c =\''+ s.Site_of_Discharge__c+'\'';
					query += ' and Port_Airport_of_Load__c =\''+ s.Site_of_Load__c+'\'';
					if (s.State_of_Discharge__c != null)
						query += ' and State_of_Discharge__c =\''+ s.State_of_Discharge__c+'\'';
					if (s.State_of_Load__c != null)
						query += ' and State_of_Load__c =\''+ s.State_of_Load__c+'\'';
					listado_routes = Database.query(query);
		              
	              	if(listado_routes != null && listado_routes.size()>0)
	              	{
				  		for(Carrier_Line_Load_Point__c cllp: listado_routes)
				  		{
			  				if(cllp.Country_of_Discharge__c == s.Country_ofDischarge__c && cllp.Port_Airport_of_Discharge__c == s.Site_of_Discharge__c && cllp.State_of_Discharge__c == s.State_of_Discharge__c &&
				      		   cllp.Country_of_Load__c == s.Country_ofLoad__c && cllp.Port_Airport_of_Load__c == s.Site_of_Load__c && cllp.State_of_Load__c == s.State_of_Load__c)
			      		   	{
  			   	   				s.Route__c = cllp.Id;
				      			break;
				      		}
				  		}
              		}
	              	else
	              	{
			  			Carrier_Line_Load_Point__c new_route = new Carrier_Line_Load_Point__c();
			            new_route.Name='route';
			            new_route.Country_of_Discharge__c =s.Country_ofDischarge__c;
			            new_route.Country_of_Load__c =s.Country_ofLoad__c;
			            if (s.State_of_Discharge__c != null)
			            	new_route.State_of_Discharge__c =s.State_of_Discharge__c;
			            if (s.State_of_Load__c != null)
			            	new_route.State_of_Load__c =s.State_of_Load__c;
			            new_route.Port_Airport_of_Discharge__c = s.Site_of_Discharge__c;
			            new_route.Port_Airport_of_Load__c =s.Site_of_Load__c;
			            insert new_route;
			            s.Route__c = new_route.Id;	
              		}   
				}
     		}
  		}
	}  
    
    if(trigger.isUpdate)
    {
  		for(Customer_Quote__c s : trigger.new)
      	{
     		Customer_Quote__c old_shipment = Trigger.oldMap.get(s.ID);
         	if(s.Route__c == old_shipment.Route__c)
         	{
         		if(s.Site_of_Load__c != null && s.Site_of_Discharge__c != null && s.Country_ofLoad__c != null && s.Country_ofDischarge__c != null)
             	{
               		if(s.Site_of_Load__c != old_shipment.Site_of_Load__c || s.Site_of_Discharge__c != old_shipment.Site_of_Discharge__c || s.State_of_Load__c != old_shipment.State_of_Load__c || s.State_of_Discharge__c != old_shipment.State_of_Discharge__c || s.Country_ofLoad__c != old_shipment.Country_ofLoad__c || s.Country_ofDischarge__c != old_shipment.Country_ofDischarge__c)
               		{
                 		List<Carrier_Line_Load_Point__c> listado_routes = null;
                 		String query = 'select Id, Name, Country_of_Discharge__c, Country_of_Load__c, State_of_Discharge__c, State_of_Load__c, Port_Airport_of_Discharge__c, Port_Airport_of_Load__c from Carrier_Line_Load_Point__c ';
		            	query += ' where Country_of_Discharge__c =\''+ s.Country_ofDischarge__c+'\'';
						query += ' and Country_of_Load__c =\''+ s.Country_ofLoad__c+'\'';
						query += ' and Port_Airport_of_Discharge__c =\''+ s.Site_of_Discharge__c+'\'';
						query += ' and Port_Airport_of_Load__c =\''+ s.Site_of_Load__c+'\'';
						if (s.State_of_Discharge__c != null)
							query += ' and State_of_Discharge__c =\''+ s.State_of_Discharge__c+'\'';
						if (s.State_of_Load__c != null)
							query += ' and State_of_Load__c =\''+ s.State_of_Load__c+'\'';
						listado_routes = Database.query(query);
			                 
                 		if(listado_routes != null && listado_routes.size()>0)
  			 			{
		              		for(Carrier_Line_Load_Point__c cllp: listado_routes)
		              		{
		              			if(cllp.Country_of_Discharge__c == s.Country_ofDischarge__c && cllp.State_of_Discharge__c == s.State_of_Discharge__c && cllp.Port_Airport_of_Discharge__c == s.Site_of_Discharge__c &&
			              		cllp.Country_of_Load__c == s.Country_ofLoad__c && cllp.State_of_Load__c == s.State_of_Load__c && cllp.Port_Airport_of_Load__c == s.Site_of_Load__c)
			              		{
			              			s.Route__c = cllp.Id;
			              			break;
			              		}
		              		}
      			 		}
	              		else
          			 	{
	              			Carrier_Line_Load_Point__c new_route = new Carrier_Line_Load_Point__c();
			                new_route.Name='route';
			                new_route.Country_of_Discharge__c =s.Country_ofDischarge__c;
			                new_route.Country_of_Load__c =s.Country_ofLoad__c;
			                if (s.State_of_Discharge__c != null)
			            		new_route.State_of_Discharge__c =s.State_of_Discharge__c;
			            	if (s.State_of_Load__c != null)
			            		new_route.State_of_Load__c =s.State_of_Load__c;
			                new_route.Port_Airport_of_Discharge__c = s.Site_of_Discharge__c;
			                new_route.Port_Airport_of_Load__c =s.Site_of_Load__c;
			                insert new_route;
			                s.Route__c = new_route.Id;
          			 	}
           			}
         		}
     		}
  		}
	}
}