public with sharing class NEU_OM_Import_ExportSteps {
    public Customer_Quote__c record;
    public string step {get;set;}
    public boolean todorelleno{get;set;}
    public string urlCQLPriceList{get;set;}
    public string urlCreateItemsLines{get;set;}
    ApexPages.StandardController con;
    public Integer stepNumber {get;set;}
    public string urlCQLPriceListM{get;set;}
    public string urlCreateItemsLinesM{get;set;}
    public Id shipmentID {get;set;}
    
    public String step_1 {get;set;}
    public String step_2 {get;set;}
    public String step_3 {get;set;}
    public String step_4 {get;set;}
    public String step_5 {get;set;}
    public String step_6 {get;set;}
    public String step_7 {get;set;}
    public String step_9 {get;set;}
    public String step_8 {get;set;}
    
    public String url_generate_shipment{get;set;}
    
    public boolean showNotifyCommunity 
	{
		get
		{
			if(record.Community_Status__c == 'SENT TO PAK2GO') //UserInfo.getUserId() == record.Account_for__r.Account_Executive_User__c
				showNotifyCommunity = true;	
			else
				showNotifyCommunity = false;
			return showNotifyCommunity;
		}
		set;
	}
            
    public String step_10
    {
        get
        {
            if(step_10==null)
            {
                List<Import_Export_Discount_Line__c> lines = [select Id from Import_Export_Discount_Line__c where Import_Export_Quote_Order__c=:record.Id limit 1];
                if(lines.size()>0)
                    step_10='step_inactive';
                else
                    step_10='step_active';
            }
            return step_10;
        }
        set;
    }

    public NEU_OM_Import_ExportSteps(ApexPages.StandardController stdController) {



        con = stdController;
        
        try {
            record = [select Id, Name, Account_for__r.Account_Executive_User__c, Community_Status__c, Freight_Mode__c, Service_Mode__c, Service_Type__c from Customer_Quote__c where Id =: con.getRecord().id];
        } catch( Exception ee) { 
            record = new Customer_Quote__c();
        }
        
        url_generate_shipment = 'apex/NEU_Generate_Shipments?id='+record.Id;

        //No damos la url de generar shipment a el usuario de Alejandro Garza unicamente para los services types FO
        //if( record.Service_Type__c != 'FO' && UserInfo.getUserId() == '0050Y000003ntxTQAQ')
        //Cambio jose@neurored: Alejandro Garza es el unico que puede generar de tipo FO
        if( record.Service_Type__c == 'FO' && UserInfo.getUserId() != '0050Y000003ntxTQAQ')
            url_generate_shipment = '';

        if( record.Service_Type__c == 'FO' && UserInfo.getProfileId() == '00e0Y000000XFLFQA4')
            url_generate_shipment = 'apex/NEU_Generate_Shipments?id='+record.Id;

        step_1 = 'step_active';
        step_2 = 'step_active';
        step_3 = 'step_active';
        step_4 = 'step_active';
        step_5 = 'step_active';
        step_6 = 'step_active';
        step_7 = 'step_active';
        step_9 = 'step_active';
        step_8 = 'step_active';
        
        boolean condescuentocreate = true;
        
        CSH_Import_Export__c sr = CSH_Import_Export__c.getInstance(userinfo.getuserid());
        if(sr == null)
        {
          sr = CSH_Import_Export__c.getInstance(userinfo.getProfileId());
          if(sr == null)
              sr = CSH_Import_Export__c.getOrgDefaults();
        }
        if(sr!=null)
            condescuentocreate=!sr.Use_Price_List_and_Dicounts__c;
        
        urlCQLPriceList =Site.getBaseUrl()+'/apex/NEU_OM_CQLPriceListYDiscount?id='+record.Id+'';
        urlCQLPriceListM=Site.getBaseUrl()+'/apex/NEU_OM_CQLPriceListYDiscount?id='+record.Id+'&sf1=1';
        
        
        if(condescuentocreate == false) 
        {
            urlCreateItemsLines = Site.getBaseUrl() + '/apex/NEU_OM_CreateItemsLinesAndDiscount?id='+record.Id+'';
            urlCreateItemsLinesM= Site.getBaseUrl() + '/apex/NEU_OM_CreateItemsLinesAndDiscount?id='+record.Id+'&sf1=1';
        }
        else
        {

            System.debug('URL val: ' + Site.getBaseUrl());
            urlCreateItemsLines = '/apex/NEU_OM_CreateItemsLines?id='+record.Id+'';
            urlCreateItemsLinesM= '/apex/NEU_OM_CreateItemsLines?id='+record.Id+'&sf1=1';
        }
        
        boolean hayduty=false;
        
        
         //-----------------------
        List<Quote_Item_Line__c> qiline = new List<Quote_Item_Line__c>();
        qiline = [select Id, Name, Import_Export_Quote__c from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id];
        if(qiline.size() > 0)
        {
            step_1 = 'step_inactive';
        }
        
        List<Quote_Item_Line__c> qiline2 = new List<Quote_Item_Line__c>();
        qiline2 = [select Id, Name, Import_Export_Quote__c, Delivery_Date__c, Delivery_Number__c from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id];
        boolean tienen_fecha=false;
        for(Quote_Item_Line__c quiline: qiline2)
        {
                if(quiline.Delivery_Date__c != null || quiline.Delivery_Number__c != null)
                {
                    tienen_fecha = true;
                    break;
                }
        }
        
        if(tienen_fecha == true)
        {
           step_2 ='step_inactive';
        }
        
        List<Import_Export_Fee_Line__c> impexpfeeli = new List<Import_Export_Fee_Line__c>();
        impexpfeeli = [select Id, Name, Import_Export_Quote__c from Import_Export_Fee_Line__c where Import_Export_Quote__c =: record.Id];
        if(impexpfeeli.size() > 0)
        {
            step_3='step_inactive';
        }
        
        List<Quote_Item_Line__c> qilines = new List<Quote_Item_Line__c>();
        qilines = [select Id, Name, Import_Export_Quote__c, Customs_Value__c from Quote_Item_Line__c where Import_Export_Quote__c =: record.Id];
        for(Quote_Item_Line__c qil : qilines)
        {
            if(qil.Customs_Value__c > 0 && qil.Customs_Value__c != null)
                hayduty = true;
        }
        
        if(hayduty == true)
        {
            step_4='step_inactive';
        }
        
        List<Associated_Document__c> documentos_asociados2 = new List<Associated_Document__c>();
        documentos_asociados2 = [select Id, Name, Import_Export_Quote__c from Associated_Document__c where Import_Export_Quote__c =: record.Id and Name like :record.Name+'%IEQ%'];
        if(documentos_asociados2.size()>0)
        {
            step_5 = 'step_inactive';
        }
        
        List<Associated_Document__c> documentos_asociados = new List<Associated_Document__c>();
        documentos_asociados = [select Id, Name, Import_Export_Quote__c from Associated_Document__c where Import_Export_Quote__c =: record.Id];
        stepNumber=0;
        if(documentos_asociados.size()>0)
        {
            step_6 = 'step_inactive';
        }
        
        List<Task> tareas = new List<Task>();
        tareas = [select Id, WhatId from Task where WhatId =: record.Id];
        if(tareas.size()>0)
        {
            step_7 ='step_inactive';
        }
        
        List<Fee__c> listado_fees = new List<Fee__c>();
        listado_fees = [select Id, Name from Fee__c where Import_Export_Quoted_Marketplace__c =: record.Id];
        if(listado_fees.size()>0)
        {
            step_9 = 'step_inactive';
        }
        
        List<Shipment_Consolidation_Data__c> shipment_consolidation_data = [select Id, Name, Shipment__c 
        from Shipment_Consolidation_Data__c where Shipment__c != null and Import_Export_Quote__c =: record.Id];
        if(record.Freight_Mode__c == 'Road' && record.Service_Mode__c == 'NATIONAL')
        {
        	step_8 = 'step_active';
        }
        else
        {
        	if(shipment_consolidation_data.size() > 0)
        	{
	            shipmentID = shipment_consolidation_data[0].Shipment__c;
	            step_8 ='step_inactive';
        	}
        }
        
        //----------------------------
    }   
}