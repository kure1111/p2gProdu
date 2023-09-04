public with sharing class NEU_OM_ProjectSteps {

    public Supply_Project__c record;
    public string step {get;set;}
    public String step_1 {get;set;}
    public String step_2 {get;set;}
    public String step_3 {get;set;}
    public String step_4 {get;set;}
    public String step_5 {get;set;}
    public String step_6 {get;set;}
    public String step_7 {get;set;}
    public String step_8 {get;set;}
    public boolean todorelleno{get;set;}
    
    ApexPages.StandardController con;
            
    public NEU_OM_ProjectSteps(ApexPages.StandardController stdController) {

        con = stdController;
        
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name from Supply_Project__c where Id =: con.getRecord().id];
        } catch( Exception ee) { 
            record = new Supply_Project__c();
        }
        
        boolean target_price = true;
        todorelleno = true;
        
        step_1 = 'step_active';
        step_2 = 'step_active';
        step_3 = 'step_active';
        step_4 = 'step_active';
        step_5 = 'step_active';
        step_6 = 'step_active';
        step_7 = 'step_active';
        step_8 = 'step_active';
         
        //COMPROBACIÓN AUCTION SETUP
            todorelleno = false;
        
        List<Items_to_Supply__c> project_item = new List<Items_to_Supply__c>();
        project_item = [select Id, Name, Target_Price__c, Supply_Project__c, Quantity__c from Items_to_Supply__c where Supply_Project__c =: record.Id];
        if(project_item.size() > 0)
        {
            step_1 = 'step_inactive';
        }
            
        //COMPROBACIÓN ORDER
        List<Associated_Document__c> documentos_asociados = new List<Associated_Document__c>();
        documentos_asociados = [select Id, Name, Supply_Project__c from Associated_Document__c where Supply_Project__c =: record.Id ];//and Name like:'%Supplier Quote.pdf'
        if(documentos_asociados.size() > 0)
        {
            step_2= 'step_inactive';
        }
        
         //COMPROBACIÓN PARTICIPANTS
        List<Supplier_to_Invite__c> Supplier_to_Invite = new List<Supplier_to_Invite__c>();
        Supplier_to_Invite = [select Id, Name, Supply_Project__c from Supplier_to_Invite__c where Supply_Project__c =: record.Id];
        if(Supplier_to_Invite.size() > 0)
        {
            step_3= 'step_inactive';
        }
        
        //COMPROBACIÓN RFP REQUEST
        List<Supplier_Request_RFP__c> supplier_requests = new List<Supplier_Request_RFP__c>();
        supplier_requests = [select Id, Name, Supply_Project__c from Supplier_Request_RFP__c where Supply_Project__c =: record.Id];
        if(supplier_requests.size() > 0)
        {
            step_4 = 'step_inactive';
        }
        
        //COMPROBACIÓN SUPPLIER OFFERS
        List<Supplier_Quote__c> Supplier_Quote = new List<Supplier_Quote__c>();
        Supplier_Quote = [select Id, Name, Supply_Project__c from Supplier_Quote__c where Supply_Project__c =: record.Id];
        if(Supplier_Quote.size() > 0)
        {
            step_5 = 'step_inactive';
        }
        
        
        //COMPROBACIÓN SUPPLIER OFFERS aprobadas
        List<Supplier_Quote__c> Supplier_Quote2 = new List<Supplier_Quote__c>();
        Supplier_Quote2 = [select Id, Name, Supply_Project__c from Supplier_Quote__c where Supply_Project__c =: record.Id and Supplier_Quote_Status__c='Approved'];
        if(Supplier_Quote2.size() > 0)
        {
            step_6 = 'step_inactive';
            step_7 = 'step_inactive';
        }
        
         //COMPROBACIÓN QUOTATION
        List<Supplier_Quote__c> quotations = new List<Supplier_Quote__c>();
        quotations = [select Id, Name, Supply_Project__c from Supplier_Quote__c where Supply_Project__c =: record.Id and RecordTypeId =: Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Order').getRecordTypeId()];
        if(quotations.size() > 0)
        {
            step_8= 'step_inactive';
        }
        
                
              
                /*List<Associated_Document__c> new_associated_document = new List<Associated_Document__c>();
                new_associated_document = [select Id, Name, Supply_Project__c from Associated_Document__c where Supply_Project__c =: record.Id];
                if(new_associated_document.size()>0)
                {
                    step = 'paso2';
                }*/
            
    }   

}