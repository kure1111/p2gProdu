public with sharing class NEU_OM_Save_Generate_Quote_Shipment {

public Shipment__c record;

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
            
    public NEU_OM_Save_Generate_Quote_Shipment(ApexPages.StandardController stdController) {

        con = stdController;
        
        try { 
        record = [select Id, Name, Account_for__c, Account_for__r.Name from Shipment__c where id =: con.getRecord().id limit 1 for update];
        } catch( Exception ee) { 
            record = new Shipment__c();
        }
        
            
    
    }
    
    public PageReference crear()
    {
        PageReference pdf = Page.NEU_OM_GenerateQuote_Shipment;
            pdf.getParameters().put('id',record.Id);
                
            Blob body;
            
            try 
            {
                body = pdf.getContent();
            } 
            catch (VisualforceException e) 
            {
                body = Blob.valueOf('Some Text');
            }
            
            List<Folder> directorio = new List<Folder>();
            directorio = [Select Id, Name from Folder where Name =:'Associated Documents'];
                documento_asociado.Body = body;
                documento_asociado.Name = record.name +'Quote.pdf';
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

            new_document.Account__c = record.Account_for__c;
            new_document.Name = record.Name +' Quote.pdf';
            new_document.Shipment__c=record.Id;
                
            new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
            
            try
            {
                insert new_document;
            }
            catch(Exception ex){}
            
            return new PageReference('/'+new_document.Id);
    }
    
}