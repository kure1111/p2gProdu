public with sharing class NEU_Shipment_Exporter_Steps
{
    public Shipment__c record;
    public String step_1 {get;set;}
    public String step_2 {get;set;}
    public String step_3 {get;set;}
    public String step_4 {get;set;}
    public String step_5 {get;set;}
    public String step_6 {get;set;}
    public String step_7 {get;set;}
    public String step_8 {get;set;}
    public String step_9 {get;set;}
    public String step_10 {get;set;}
    public String step_11 {get;set;}
    public String step_12 {get;set;}
    public String step_13 {get;set;}
    public String step_14 {get;set;}
    public String step_15 {get;set;}
    public String step_16 {get;set;}
    public String step_17 {get;set;}
    public String step_18 {get;set;}
    public String step_19 {get;set;}    
    public boolean condescuentocreate{get;set;}
    public String url_createItems{get;set;}
    Public User u {get;set;}

    ApexPages.StandardController con;
            
    public NEU_Shipment_Exporter_Steps(ApexPages.StandardController stdController) 
    {
        con = stdController;
        
        system.debug( con.getRecord() );
        try { 
        record = [select Id, Name, MAWB_Number__c, Warehouse__c from Shipment__c where Id =: con.getRecord().id];
        } catch( Exception ee) { 
            record = new Shipment__c();
        }

        //check new version SSL
        u = [select Id, username, New_Shipment_Service_Line__c from User where Id = :UserInfo.getUserId()];

        step_1 = 'step_active';
        step_2 = 'step_active';
        step_3 = 'step_active';
        step_4 = 'step_active';
        step_5 = 'step_active';
        step_6 = 'step_active';
        step_7 = 'step_active';
        step_8 = 'step_active';
        step_9 = 'step_active';
        step_10 = 'step_active';
        step_11 = 'step_active';
        step_12 = 'step_active';
        step_13 = 'step_active';
        step_14 = 'step_active';
        step_15 = 'step_active';
        step_16 = 'step_active';
        step_17 = 'step_active';
        step_18 = 'step_active';
        step_19 = 'step_active';
        
        url_createItems = '';
        condescuentocreate = true;
        
        CSH_Import_Export__c sr = CSH_Import_Export__c.getInstance(userinfo.getuserid());
        if(sr == null)
        {
          sr = CSH_Import_Export__c.getInstance(userinfo.getProfileId());
          if(sr == null)
              sr = CSH_Import_Export__c.getOrgDefaults();
        }
        if(sr!=null)
            condescuentocreate=!sr.Use_Price_List_and_Dicounts__c;
            
        if(condescuentocreate == false) 
            url_createItems = '/apex/NEU_OM_CreateShipmenItemsLineDiscount?id='+record.Id+'';
        else
            url_createItems = '/apex/NEU_OM_CreateShipmentsItemsLines?id='+record.Id+''; 
            
        List<Associated_Document__c> documentos_asociados_1 = new List<Associated_Document__c>();
        documentos_asociados_1 = [select Id, Name, Shipment__c from Associated_Document__c where Shipment__c =: record.Id];
        if(documentos_asociados_1.size()>0)
        {

            step_1 = 'step_inactive';
        }
        
        List<Shipment_Line__c> qilines = new List<Shipment_Line__c>();
        qilines = [select Id, Name, Shipment__c from Shipment_Line__c where Shipment__c =: record.Id];
        if(qilines.size() > 0)
        {
              step_2 = 'step_inactive';
        }
        
        List<Shipment_Fee_Line__c> shipfeeli = new List<Shipment_Fee_Line__c>();
        shipfeeli = [select Id, Name, Shipment__c from Shipment_Fee_Line__c where Shipment__c =: record.Id];
        if(shipfeeli.size() > 0)
        {
            step_3 = 'step_inactive';
        }
        
        List<Shipment_Line__c> shiplines = new List<Shipment_Line__c>();
        shiplines = [select Id, Name, Shipment__c,Customs_Value__c from Shipment_Line__c where Shipment__c =: record.Id];
        for(Shipment_Line__c qil : shiplines )
        {
            if(qil.Customs_Value__c > 0 && qil.Customs_Value__c != null)
            {
                step_4 = 'step_inactive';
                break;
            }
                
        }
        
        List<Associated_Document__c> documentos_asociados_2 = new List<Associated_Document__c>();
        documentos_asociados_2 = [select Id, Name, Shipment__c 
        from Associated_Document__c where Shipment__c =: record.Id and Document_Type__c =: 'Order Confirmation'];
        if(documentos_asociados_2.size()>0)
        {
          step_5 = 'step_inactive';
        }
        
        List<Associated_Document__c> documentos_asociados_3 = new List<Associated_Document__c>();
        documentos_asociados_3 = [select Id, Name, Shipment__c 
        from Associated_Document__c where Shipment__c =: record.Id and Document_Type__c =: 'Proforma Invoice'];
        if(documentos_asociados_3.size()>0)
        {
          step_6 = 'step_inactive';
        }
        
        List<Task> tareas = new List<Task>();
        tareas = [select Id, WhatId from Task where WhatId =: record.Id and Send_Emails__c =: true];
        if(tareas.size()>0)
        {
          step_7 = 'step_inactive';
        }
        
         List<Task> tareas2 = new List<Task>();
        tareas2 = [select Id, WhatId from Task where WhatId =: record.Id and Send_Shipping_Order__c =: true];
        if(tareas2.size()>0)
        {
          step_8 = 'step_inactive';
        }
      
        List<Associated_Document__c> documentos_asociados_4 = new List<Associated_Document__c>();
        documentos_asociados_4 = [select Id, Name, Shipment__c 
        from Associated_Document__c where Shipment__c =: record.Id and name like: '%Shipping_Marks%'];
        if(documentos_asociados_4.size()>0)
        {
          step_9 = 'step_inactive';
        }
        
         List<Task> tarea = new List<Task>();
        tarea = [select Id, WhatId from Task where WhatId =: record.Id and Send_Inspection_Booking__c =: true];
        if(tarea .size()>0)
        {
          step_10 = 'step_inactive';
        }
        
        List<Fee__c> listado_fees = new List<Fee__c>();
        listado_fees = [select Id, Name from Fee__c where Shipment_Quoted_Marketplace__c =: record.Id];
        if(listado_fees.size()>0)
        {
            step_12 = 'step_inactive';
        }
        
        List<Associated_Document__c> documentos_asociados_5 = new List<Associated_Document__c>();
        documentos_asociados_5 = [select Id, Name, Shipment__c 
        from Associated_Document__c where Shipment__c =: record.Id and name like: '%DeliveryNote%'];
        if(documentos_asociados_5.size()>0)
        {
          step_11 = 'step_inactive';
        }
      
        List<Associated_Document__c> documentos_asociados_6 = new List<Associated_Document__c>();
        documentos_asociados_6 = [select Id, Name, Shipment__c 
        from Associated_Document__c where Shipment__c =: record.Id and name like: '%HBL%'];
        if(documentos_asociados_6.size()>0)
        {
          step_13 = 'step_inactive';
        }

        List<Air_Waybill__c> waybills = new List<Air_Waybill__c>();
        waybills = [select Id, Shipment__c from Air_Waybill__c where Shipment__c =: record.Id];
        if(waybills.size()>0)
        {
            step_14 = 'step_inactive';
        }
        
        List<Shipment_Track__c> lst_track = new List<Shipment_Track__c>();
        lst_track = [select Id, Shipment__c from Shipment_Track__c where Shipment__c =: record.Id];
        if(lst_track.size()>0)
        {
            step_15 = 'step_inactive';
        }
        
        if(record.MAWB_Number__c != null && record.MAWB_Number__c != '')
        {
	        List<Shipment__c>shs=[select Id,FSR_Message__c from Shipment__c where MAWB_Number__c=:record.MAWB_Number__c];
	        if(shs.size() > 0)
	        {
	            step_16 = 'step_inactive';
	        }
        }
    }   
}