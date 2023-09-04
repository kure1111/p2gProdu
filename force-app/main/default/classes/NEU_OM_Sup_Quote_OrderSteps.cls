public with sharing class NEU_OM_Sup_Quote_OrderSteps {
    
    public Supplier_Quote__c record;
    public string step {get;set;}
    public boolean todorelleno{get;set;}
    public boolean condescuento{get;set;}
    public boolean condescuentocreate{get;set;}
    public string urlCQLPriceList{get;set;}
    
    public String step_1 {get;set;}
    public String step_2 {get;set;}
    public String step_3 {get;set;}
    public String step_4 {get;set;}
    public String step_5 {get;set;}
    public String step_6 {get;set;}
    
    public string urlCreateItemsLines{get;set;}
    ApexPages.StandardController con;
            
    public NEU_OM_Sup_Quote_OrderSteps(ApexPages.StandardController stdController) {

        con = stdController;
        
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, RecordTypeId from Supplier_Quote__c where Id =: con.getRecord().id];
        } catch( Exception ee) { 
            record = new Supplier_Quote__c();
        }
        
        boolean hayduty=false;
        
        step_1 = 'step_active';
        step_2 = 'step_active';
        step_3 = 'step_active';
        step_4 = 'step_active';
        step_5 = 'step_active';
        step_6 = 'step_active';
            
        //COMPROBACIÓN ORDER
        List<Supplier_Quote_Line__c> qilines = new List<Supplier_Quote_Line__c>();
        qilines = [select Id, Name, Supplier_Quote__c, Customs_Value__c from Supplier_Quote_Line__c where Supplier_Quote__c =: record.Id];
        for(Supplier_Quote_Line__c qil : qilines)
        {
            step_1 = 'step_inactive';
            if(qil.Customs_Value__c > 0 && qil.Customs_Value__c != null)
                step_3 = 'step_inactive';
        }
        List<Supplier_Quote_Order_Fee_Line__c> supquorfeeli = new List<Supplier_Quote_Order_Fee_Line__c>();
        supquorfeeli = [select Id, Name, Supplier_Quote_Order__c from Supplier_Quote_Order_Fee_Line__c where Supplier_Quote_Order__c =: record.Id];
        if(supquorfeeli.size() > 0)
        {
            step_2 = 'step_inactive';
        }
        List<Associated_Document__c> documentos_asociados = new List<Associated_Document__c>();
        documentos_asociados = [select Id, Name, Supplier_Quote__c from Associated_Document__c where Supplier_Quote__c =: record.Id];
        if(documentos_asociados.size()>0)
        {
            step_4 = 'step_inactive';
        }
        qilines = [select Id, Name, Supplier_Quote__c, Customs_Value__c from Supplier_Quote_Line__c where Supplier_Quote__c =: record.Id and Delivery_Number__c != null];
        if(qilines.size()>0)
        {
            step_5 ='step_inactive';
        }
        
        documentos_asociados = [select Id, Name, Supplier_Quote__c from Associated_Document__c where Supplier_Quote__c =: record.Id and Name like :record.Name+'%'];
        if(documentos_asociados.size()>0)
        {
            step_6 ='step_inactive';
        }
        
      /*  string nombrequote = record.Name+'%';
        
        documentos_asociados = [select Id, Name, Supplier_Quote__c from Associated_Document__c where Supplier_Quote__c =: record.Id and Name like :record.Name+'%'];
        if(documentos_asociados.size()>0)
        {
            step ='ImportExportStep6';
        }
        else
        {
            if(record.RecordTypeId == Schema.SobjectType.Supplier_Quote__c.getRecordTypeInfosByName().get('Supplier Order').getRecordTypeId())
            {
                step ='ImportExportStep5';
            }
            else
            {
                documentos_asociados = [select Id, Name, Supplier_Quote__c from Associated_Document__c where Supplier_Quote__c =: record.Id];
                if(documentos_asociados.size()>0)
                {
                    step ='ImportExportStep4';
                }
                else
                {
                    if(hayduty == true)
                    {
                        step ='ImportExportStep3';
                    }
                    else
                    {
                        //COMPROBACIÓN QUOTATION
                        List<Supplier_Quote_Order_Fee_Line__c> supquorfeeli = new List<Supplier_Quote_Order_Fee_Line__c>();
                        supquorfeeli = [select Id, Name, Supplier_Quote_Order__c from Supplier_Quote_Order_Fee_Line__c where Supplier_Quote_Order__c =: record.Id];
                        if(supquorfeeli.size() > 0)
                        {
                            step ='ImportExportStep2';
                        }
                        else
                        {
                            List<Supplier_Quote_Line__c> suquoteitem = new List<Supplier_Quote_Line__c>();
                            suquoteitem = [select Id, Name, Supplier_Quote__c from Supplier_Quote_Line__c where Supplier_Quote__c =: record.Id];
                            if(suquoteitem.size() > 0)
                                step ='ImportExportStep1';
                            else
                                step ='ImportExportStep0';
                
                        }
                    }
                }
            }
        }*/
    }   
}