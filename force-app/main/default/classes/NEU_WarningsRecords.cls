public with sharing class NEU_WarningsRecords 
{
	public List<string> messages {get;set;}
	
	public string object_selected;
	 
    public void setobject_selected(string s) 
    {
    	object_selected = s;
  	}
    
  	public string getobject_selected() 
  	{
    	return object_selected;    	
  	} 
  	
  	public string id_record_selected;
  	
  	public void setid_record_selected(string s) 
    {
    	id_record_selected = s;	
    	
    	load_warnings();	
  	}
    
  	public string getid_record_selected() 
  	{
    	return id_record_selected;
  	}
  	
  	public void load_warnings()
  	{
  		messages = new List<string>();

  		if(object_selected == 'Shipment__c')
  		{
  			List<Shipment_Fee_Line__c> service_lines = [select Id, Name
			from Shipment_Fee_Line__c where Shipment__c =: id_record_selected];
			if(service_lines.size() == 0)
				messages.add('SHIPMENT SERVICE LINES ARE MISSING.');
  		}	
  	}  
}