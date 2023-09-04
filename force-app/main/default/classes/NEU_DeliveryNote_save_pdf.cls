public with sharing class NEU_DeliveryNote_save_pdf {

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
            
    public NEU_DeliveryNote_save_pdf(ApexPages.StandardController stdController) {

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
        PageReference pdf = Page.NEU_DeliveryNote_pdf;
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
                documento_asociado.Name = record.name +' DeliveryNote.pdf';
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
            new_document.Name = 'DeliveryNote_'+record.Name +'.pdf';
            new_document.Shipment__c =record.Id;
                    
            new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
            
            try
            {
                insert new_document;
            
                List<Shipment_Line__c> lista_shipments_lines = [select Id, Name, Delivered__c, Quote_Item_Line__c, Quote_Item_Line__r.Delivered__c  from Shipment_Line__c where Shipment__c =: record.Id];
                List<Quote_Item_Line__c> lista_quote_lines = new List<Quote_Item_Line__c>();
                for(Shipment_Line__c ship_li : lista_shipments_lines )
                {
                    ship_li.Delivered__c = true;
                    if(ship_li.Quote_Item_Line__c != null)
                    {
                        ship_li.Quote_Item_Line__r.Delivered__c = true;
                        lista_quote_lines.add(ship_li.Quote_Item_Line__r);
                    }
                }
            
                update lista_shipments_lines;
                if(lista_quote_lines.size()>0)
                    update lista_quote_lines;
            
                return new PageReference('/'+record.Id);
            }
            catch(Exception ex){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,' '+ex)); return null;}
            
    }
}