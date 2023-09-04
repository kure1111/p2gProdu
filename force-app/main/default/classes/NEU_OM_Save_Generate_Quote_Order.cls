public with sharing class NEU_OM_Save_Generate_Quote_Order {
public Supplier_Quote__c record;

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
            
    public NEU_OM_Save_Generate_Quote_Order(ApexPages.StandardController stdController) {

        con = stdController;
        
        try { 
        record = [select Id, Name, Supply_Project__c, Supply_Project__r.Name, Supplier_Request_RFP__c, Supplier_Request_RFP__r.Name, Supplier__c from Supplier_Quote__c where id =: con.getRecord().id limit 1 for update];
        } catch( Exception ee) { 
            record = new Supplier_Quote__c();
        }
        
            
    
    }
    
    public PageReference crear()
    {
        PageReference pdf = Page.NEU_OM_Save_Generate_Quote_Order_pdf;
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
                documento_asociado.Name = record.name +' Supplier Quote.pdf';
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
            
            new_document.Account__c = record.Supplier__c;
            new_document.Name = record.Name +' Supplier Quote.pdf';
            new_document.Supplier_Quote__c=record.Id;
            if(record.Supply_Project__r.Name != null)
                new_document.Supply_Project__c =record.Supply_Project__c;
            if(record.Supplier_Request_RFP__r.Name != null)
                new_document.Supplier_Request_RFP__c =record.Supplier_Request_RFP__c;
                    
            new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
            
            try
            {
                insert new_document;
            }
            catch(Exception ex){}
            
            return new PageReference('/'+new_document.Id);
    }
    
}