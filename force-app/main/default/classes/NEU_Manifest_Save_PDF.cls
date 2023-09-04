public with sharing class NEU_Manifest_Save_PDF 
{    
    public Air_Waybill__c record;
    
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
            
    public NEU_Manifest_Save_PDF(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        try 
        { 
        	record = [select Id, Name, Carrier_Account__c from Air_Waybill__c where id =: con.getRecord().id];
        } 
        catch(Exception ee){record = new Air_Waybill__c();}
    }
    
    public PageReference return_page()
    {
    	return con.view();
    }
    
    public PageReference crear()
    {
        PageReference pdf = null;
        pdf = Page.NEU_Manifest_PDF;
        pdf.getParameters().put('id',record.Id);
        
        Blob body;
        
        try 
        {
            body = pdf.getContent();
        } 
        catch (VisualforceException e) { body = Blob.valueOf('Some Text');}
        
        List<Folder> directorio = new List<Folder>();
        directorio = [Select Id, Name from Folder where Name =:'Air Waybill'];
        documento_asociado.Body = body;
        documento_asociado.Name = 'Air Waybill_'+record.Name +'.pdf';
        documento_asociado.AuthorId = UserInfo.getUserId();
        if(directorio.size()>0)
           documento_asociado.FolderId = directorio[0].Id;
        documento_asociado.IsPublic = true; 
        
        try 
        {
            if(documento_asociado.Name != '' && documento_asociado.Name != null)
                insert documento_asociado;
        }  
        catch (DMLException e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));
        }
        
        Associated_Document__c new_document = new Associated_Document__c();
        new_document.Account__c = record.Carrier_Account__c;
        new_document.Name = 'Manifest '+record.Name+'.pdf';
        new_document.Air_Waybill__c = record.Id;
        new_document.Document_Type__c = 'Manifest';
            
        new_document.Document_URL__c = '/servlet/servlet.ImageServer?id='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
        
        try
        {
            insert new_document;
            return new PageReference('/'+record.Id);
        }
        catch(Exception ex){return null;}    
    }
}