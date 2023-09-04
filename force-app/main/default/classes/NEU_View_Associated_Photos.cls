public with sharing class NEU_View_Associated_Photos {

	//public Shipment__c record=null;
	Associated_Photo__c[] asso_photo;
	private List<associated_photo_s> list_associated_photo =null;
	public id shipment_id {get; set;}
	public id shipment_prog_id {get; set;}
	public string shipment_prog_name {get; set;}
	public string name_shipment {get; set;}
	
	  //clase nuevo objeto
    public class associated_photo_s
    {
        public String Name{get; set;}
        public Associated_Photo__c associated_photo{get; set;}
        
        public associated_photo_s(String Name, Associated_Photo__c associated_photo)
        {
            this.Name=Name;
            this.associated_photo=associated_photo;
        }
    }
    
    public List<associated_photo_s> getlist_associated_photo()
    {
        list_associated_photo = new List<associated_photo_s>();
        List<Associated_Photo__c> query_associated_photo = null;
        if(string.isnotempty(shipment_id))
        	query_associated_photo = [select Id, Name, Account__c, Photo_URL__c, Shipment__c from Associated_Photo__c where Shipment__c =: shipment_id];
       	else if(string.isnotempty(shipment_prog_id))
       		query_associated_photo = [select Id, Name, Account__c, Photo_URL__c, Shipment__c from Associated_Photo__c where Shipments_Program__c =: shipment_prog_id];
        for(Associated_Photo__c ap: query_associated_photo)
        {
        	list_associated_photo.add(new associated_photo_s(ap.Name, ap));
        }
          
        return list_associated_photo;
    }
    
    public NEU_View_Associated_Photos(ApexPages.StandardSetController stdController) 
    {
        asso_photo = stdController.getSelected();
        name_shipment = '';
        shipment_prog_name = '';
        if(ApexPages.currentPage().getParameters().get('id') != null)
        {
        	id tipo_de_objeto = ApexPages.currentPage().getParameters().get('id');
          	string tipo_de_objeto_string = string.valueof(tipo_de_objeto.getSobjectType());
          	if(tipo_de_objeto_string == 'Shipment__c')
          	{
	        	shipment_id =  ApexPages.currentPage().getParameters().get('id');
	        	if(string.isnotempty(shipment_id))
	        	{
	        		Shipment__c query_shipment = [select id, Name from Shipment__c where id =:shipment_id limit 1];
	        		name_shipment = query_shipment.Name;
	        	}
          	}
          	else if(tipo_de_objeto_string == 'Shipment_Program__c')
          	{
          		shipment_prog_id =  ApexPages.currentPage().getParameters().get('id');
	        	if(string.isnotempty(shipment_prog_id))
	        	{
	        		Shipment_Program__c query_shipment_prog = [select id, Name from Shipment_Program__c where id =:shipment_prog_id limit 1];
	        		shipment_prog_name = query_shipment_prog.Name;
	        	}
          	}
        }
    }
}