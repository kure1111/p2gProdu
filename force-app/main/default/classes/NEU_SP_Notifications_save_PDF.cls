public with sharing class NEU_SP_Notifications_save_PDF {
   
	public Shipment_Program__c record;
	public string language {get;set;}
    
    public Document documento_asociado 
    {
		get 
		{
	  		if (documento_asociado == null)
	    		documento_asociado = new Document();
	  		return documento_asociado;
		}
        set;
    }
    
    ApexPages.StandardController con;
            
    public NEU_SP_Notifications_save_PDF(ApexPages.StandardController stdController) 
    {
        con = stdController;
        try { 
        	record = [select Id, Name from Shipment_Program__c where id =: con.getRecord().id limit 1 for update];
        } catch( Exception ee) { 
            record = new Shipment_Program__c();
        }
    }
    
    public PageReference return_page()
    {
    	return con.view();
    }
    
    public PageReference crear()
    {
        PageReference pdf = null;
        pdf = Page.NEU_SP_Notifications_PDF;
        pdf.getParameters().put('id',record.Id);
        Blob body;
        
        try 
        {
            body = pdf.getContent();
        } 
        catch (VisualforceException e) { body = Blob.valueOf('Some Text');}
        
        List<Folder> directorio = new List<Folder>();
        directorio = [Select Id, Name from Folder where Name =:'Shipments Program'];
        documento_asociado.Body = body;
        documento_asociado.Name = record.name +'.pdf';
        documento_asociado.AuthorId = UserInfo.getUserId();
        if(directorio.size()>0)
       		documento_asociado.FolderId = directorio[0].Id;
        documento_asociado.IsPublic = true; 
        
        try 
        {
            if(documento_asociado.Name != '' && documento_asociado.Name != null)
                insert documento_asociado;
        }  
        catch (DMLException e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));}
        
        Associated_Document__c new_document = new Associated_Document__c();
        new_document.Name = record.Name +'.pdf';
        new_document.Consolidation_Program__c=record.Id;
            
        new_document.Document_URL__c = '/servlet/servlet.ImageServer?id='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
        
        try
        {
        	insert new_document;
            return new PageReference('/'+record.Id);
        }
        catch(Exception ex){return null;} 
    }   
    
}