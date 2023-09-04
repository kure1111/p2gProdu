public with sharing class NEU_ShipmentRequestSteps
{
    public Shipment__c record;
    public String step_1 {get;set;}
    public String step_2 {get;set;}
    public String step_3 {get;set;}
    public String step_4 {get;set;}
    public String step_5 {get;set;}

    ApexPages.StandardController con;
            
    public NEU_ShipmentRequestSteps(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name from Shipment__c where Id =: con.getRecord().id];
        } catch( Exception ee) { 
            record = new Shipment__c();
        }
        
        step_1 = 'step_active';
        step_2 = 'step_active';
        step_3 = 'step_active';
        step_4 = 'step_active';
        step_5 = 'step_active';
 
        List<Associated_Document__c> documentos_asociados = [select Id, Name, Shipment__c from Associated_Document__c where Shipment__c =: record.Id];
        if(documentos_asociados.size() > 0)
            step_1 = 'step_inactive';
        
        List<Fee__c> service_rates = [select Id, Name from Fee__c where Shipment_Quoted_Marketplace__c =: record.Id];
        if(service_rates.size() > 0)
          step_2 = 'step_inactive';
        
        List<Shipment_Fee_Line__c> shipfeeli = new List<Shipment_Fee_Line__c>();
        shipfeeli = [select Id, Name, Shipment__c from Shipment_Fee_Line__c where Shipment__c =: record.Id];
        if(shipfeeli.size() > 0)
        {
            step_3 = 'step_inactive';
        }
        
        List<Task> tareas = [select Id, WhatId from Task where WhatId =: record.Id and Send_Emails__c =: true];
        if(tareas.size() > 0)
          step_4 = 'step_inactive';
    }   
}