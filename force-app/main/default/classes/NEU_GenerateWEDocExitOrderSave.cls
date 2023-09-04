public with sharing class NEU_GenerateWEDocExitOrderSave
{
    public Warehouse_Exit_Order__c record {get;set;}
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
            
    public NEU_GenerateWEDocExitOrderSave(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        try 
        { 
        	record = [select Id, Name, Warehouse__c, Account_for_Customer__c
        	from Warehouse_Exit_Order__c where id =: con.getRecord().id];
        } 
        catch(Exception ee){record = new Warehouse_Exit_Order__c();}
    }
    
    public PageReference crear()
    {
        PageReference pdf = Page.NEU_GenerateWEDocExitOrder;
        pdf.getParameters().put('id',record.Id);
            
        Blob body;
        
        try 
        {
            body = pdf.getContent();
        } 
        catch(VisualforceException e){body = Blob.valueOf('Some Text');}
        
        List<Folder> directorio = [select Id, Name from Folder where Name =:'Associated Documents'];
        documento_asociado.Body = body;
        documento_asociado.Name = record.Name +'_Warehouse_Embarque.pdf';
        documento_asociado.AuthorId = UserInfo.getUserId();
        if(directorio.size() > 0)
            documento_asociado.FolderId = directorio[0].Id;
        documento_asociado.IsPublic = true; 

        try 
        {
            if(documento_asociado.Name != '' && documento_asociado.Name != null)
                insert documento_asociado;
        }  
        catch (DMLException e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error in File Upload.'));}
    
        Associated_Document__c new_document = new Associated_Document__c();
        new_document.Account__c = record.Account_for_Customer__c;
        new_document.Warehouse_Exit_Order__c = record.Id;
        new_document.Available_for_Community__c = true;
        new_document.Name = record.Name +'_Warehouse_Embarque.pdf';
            
        new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
        
        try
        {
            insert new_document;
            return new PageReference('/'+record.Id);
        }
        catch(Exception ex){return null;}      
    }
}