public with sharing class NEU_Shipping_Marks_save_pdf {

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
            
    public NEU_Shipping_Marks_save_pdf(ApexPages.StandardController stdController) {

        con = stdController;
        
       try { 
        record = [select Id, Name, Account_for__c,
        Account_for__r.Phone, Account_for__r.BillingStreet,
        Account_for__r.BillingCity, Account_for__r.BillingState,
        Account_for__r.BillingCountry ,Account_for__r.Name,Supplier_Account__c, Supplier_Account__r.Name,
        Contact__r.Name, SUM_Sell_Origin_Amount__c from Shipment__c where id =: con.getRecord().id limit 1 for update];
        } catch( Exception ee) { 
            record = new Shipment__c();
        }
        
            
    
    }
    
    public PageReference crear()
    {
        PageReference pdf = Page.NEU_Shipping_Marks_pdf;
            pdf.getParameters().put('id',record.Id);
                
            Blob body;
            
            try {
         
                body = pdf.getContent();
         
            } catch (VisualforceException e) {
                body = Blob.valueOf('Some Text');
            }
            List<Folder> directorio = new List<Folder>();
            directorio = [Select Id, Name from Folder where Name =:'Associated Documents'];
                documento_asociado.Body = body;
                documento_asociado.Name = record.name +' Shipping_Marks.pdf';
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
            new_document.Name = record.Name +' Shipping Marks.pdf';
            new_document.Shipment__c =record.Id;
                    
            new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
            
            try
           {
                insert new_document;
                return new PageReference('/'+record.Id);
            }
            catch(Exception ex){return null;}
            
    }
}