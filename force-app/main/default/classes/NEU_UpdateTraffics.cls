public with sharing class NEU_UpdateTraffics 
{
	public string resultado {get;set;}
	
	public pagereference update_traffics()
	{
		List<Traffic__c> traffics = [select Id, Name, N_Import_Exports__c from Traffic__c where N_Import_Exports__c = null limit 50];
		if(traffics.size() > 0)
		{
			List<AggregateResult> results = [select count(Id) total_ie, Traffic__c from Customer_Quote__c where Traffic__c IN : traffics group by Traffic__c];
			for(Traffic__c t : traffics)
			{
				t.N_Import_Exports__c = 0;
				for(AggregateResult r : results)
				{
					if(t.Id == string.valueof(r.get('Traffic__c')))
					{
						t.N_Import_Exports__c = integer.valueof(string.valueof(r.get('total_ie')));
						break;
					}
				}
			}
			update traffics;
			
			PageReference pgReturnPage;
			String returnUrl = '/apex/NEU_UpdateTraffics';
	    	pgReturnPage = new PageReference(returnUrl);
	        pgReturnPage.setRedirect(true);
			return pgReturnPage;
		}
		else{resultado = 'fin'; return null;}
	}
}