public with sharing class NEU_Waybill_Steps 
{
    public Air_Waybill__c record;
    public String step_1 {get;set;}
    public String step_2 {get;set;}
    public String step_3 {get;set;}
    public String step_4 {get;set;}
    public String step_5 {get;set;}
    public String step_6 {get;set;}
    public String step_7 {get;set;}
    public String awb;
    
    ApexPages.StandardController con;
            
    public NEU_Waybill_Steps(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        try { 
        	record = [select Id, Name, Airline_Code_Number__c, Serial_Number__c from Air_Waybill__c where Id =: con.getRecord().id];
        } catch( Exception ee) { 
            record = new Air_Waybill__c();
        }
        
        step_1 = 'step_active';
        step_2 = 'step_active';
        step_3 = 'step_active';
        step_4 = 'step_active';
        step_5 = 'step_active';
        step_6 = 'step_active';
        step_7 = 'step_active';
        
        List<Associated_Document__c> documentos_asociados_1 = new List<Associated_Document__c>();
        documentos_asociados_1 = [select Id, Name, Air_Waybill__c
        from Associated_Document__c where Air_Waybill__c =: record.Id and name like '%Master Waybill%'];
        if(documentos_asociados_1.size() > 0){
        	step_1 = 'step_inactive';
        }
        
        List<Associated_Document__c> documentos_asociados_2 = new List<Associated_Document__c>();
        documentos_asociados_2 = [select Id, Name, Air_Waybill__c
        from Associated_Document__c where Air_Waybill__c =: record.Id and name like '%House Waybill%'];
        if(documentos_asociados_2.size() > 0){
        	step_2 = 'step_inactive';
        }
        
        List<Associated_Document__c> documentos_asociados_3 = new List<Associated_Document__c>();
        documentos_asociados_3 = [select Id, Name, Air_Waybill__c
        from Associated_Document__c where Air_Waybill__c =: record.Id and name like '%Manifest%'];
        if(documentos_asociados_3.size() > 0){
        	step_3 = 'step_inactive';
        }
        
        awb=record.Airline_Code_Number__c+'-'+record.Serial_Number__c;
        List<Log__c> documentos_asociados_4 = new List<Log__c>();
        documentos_asociados_4 = [select Id, Name, Body__c from Log__c where Subject__c like '%FWB:%'];
        for(Log__c lg:documentos_asociados_4)
		{
			if(lg.Body__c.contains(awb)){
				step_4 = 'step_inactive';
			}
		}
        
        List<Log__c> documentos_asociados_5 = new List<Log__c>();
        documentos_asociados_5 = [select Id, Name, Body__c from Log__c where Subject__c like '%FHL:%'];
        for(Log__c lg:documentos_asociados_5)
		{
			if(lg.Body__c.contains(awb)){
				step_5 = 'step_inactive';
			}
		}
        
        List<Associated_Document__c> documentos_asociados_6 = new List<Associated_Document__c>();
        documentos_asociados_6 = [select Id, Name, Air_Waybill__c
        from Associated_Document__c where Air_Waybill__c =: record.Id and name like '%Master Label%'];
        if(documentos_asociados_6.size() > 0){
        	step_6 = 'step_inactive';
        }
        
        List<Associated_Document__c> documentos_asociados_7 = new List<Associated_Document__c>();
        documentos_asociados_7 = [select Id, Name, Air_Waybill__c
        from Associated_Document__c where Air_Waybill__c =: record.Id and name like '%House Label%'];
        if(documentos_asociados_7.size() > 0){
        	step_7 = 'step_inactive';
        }
	}   
}