public with sharing class NEU_Save_All_Delivery_Note {


    public Shipment_Program__c record;

    ApexPages.StandardController con;
            
    public NEU_Save_All_Delivery_Note(ApexPages.StandardController stdController) {

        con = stdController;
        
       try { 
        record = [select Id, Name  from Shipment_Program__c where id =: con.getRecord().id limit 1 for update];
        } catch( Exception ee) { 
            record = new Shipment_Program__c();
        }
    }
    
    public PageReference  generar_todos()
    {
        
            List<Folder> directorio = [Select Id, Name from Folder where Name =:'Associated Documents'];
            List<Associated_Document__c> todos_los_documentos_asociados = new List<Associated_Document__c>();
            List<Shipment__c> todos_los_shipment =[select id, Name, Account_for__c, Outbound_Consolidation_Program__c from Shipment__c where Outbound_Consolidation_Program__c =: record.Id];
            
            for(Shipment__c ship : todos_los_shipment)
            {
                //crear documento
                PageReference pdf = Page.NEU_DeliveryNote_pdf;
                pdf.getParameters().put('id',ship.Id);
                Blob body;
                try {
             
                    body = pdf.getContent();
             
                } catch (VisualforceException e) {
                    body = Blob.valueOf('Some Text');
                }
                //guardar documento
                    Document documento_asociado = new Document();
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
                    return null;
                }
            
                //relacionar documento con objeto
                Associated_Document__c new_document = new Associated_Document__c();
                new_document.Account__c = ship.Account_for__c;
                new_document.Name =ship.Name +' DeliveryNote.pdf';
                new_document.Shipment__c = ship.Id;
                new_document.Consolidation_Program__c = record.Id;
                new_document.Document_URL__c = '/servlet/servlet.FileDownload?file='+documento_asociado.Id+'&oid=' + UserInfo.getOrganizationId(); 
                todos_los_documentos_asociados.add(new_document);
                
            
            }
            
            List<Shipment_Line__c> lista_shipments_lines = [select Id, Name, Delivered__c, Quote_Item_Line__c, Quote_Item_Line__r.Delivered__c, Shipment__c, Shipment__r.Outbound_Consolidation_Program__c from Shipment_Line__c where Shipment__r.Outbound_Consolidation_Program__c =: record.Id];
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
            
            //insersiones y actualizaciones
            try
            {
                if(todos_los_documentos_asociados != null && todos_los_documentos_asociados.size()>0)
                    insert todos_los_documentos_asociados;
                if(lista_shipments_lines != null && lista_shipments_lines.size()>0) 
                    update lista_shipments_lines;
                if(lista_shipments_lines != null && lista_shipments_lines.size()>0) 
                    update lista_shipments_lines;
            }
            catch(Exception ex)
            {
                return null;
            }   
        return new PageReference('/'+record.Id);
    }
}