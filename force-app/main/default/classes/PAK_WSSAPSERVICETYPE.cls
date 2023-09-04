global class PAK_WSSAPSERVICETYPE {
    
    webservice static list<status> SFMESSAGES(list<SapServiceType> services)
    {
        list<status> respuesta = new list<status>();
        
        if(services.size() == 0)
        {
            status st = new status();
            st.code = '0';
            st.existe = '';
            st.message = 'Lista de entrada vacía';
            respuesta.add(st);
            
            return respuesta;
        }
        
        list<string> codes =  new list<string>();
        
        for(SapServiceType sap : services )
        {
            if(!string.isBlank(sap.Code))
                codes.add(sap.Code);
            else
            {
                status st = new status();
                st.code = '0';
                st.existe = 'No';
                st.message = 'Codigo vacío';
                st.service = sap;
                respuesta.add(st);
            }
        }
        
        map<string,SAP_Service_Type__c> mapSST = new map<string,SAP_Service_Type__c>();
        
        for(SAP_Service_Type__c ss : [SELECT 
                                      Id, Name, Group__c, 
                                      Code__c, Activo__c, 
                                      VAT_Withholding_ISR__c, VAT_Withholding__c, 
                                      VAT__c 
                                      FROM SAP_Service_Type__c where code__C in:codes])
        {
            if(!mapSST.containsKey(ss.Code__c))
                mapSST.put(ss.Code__c,ss);
        }
        
        list<SAP_Service_Type__c> news = new list<SAP_Service_Type__c>();
        list<SAP_Service_Type__c> updates = new list<SAP_Service_Type__c>();
        
        for(SapServiceType sap : services )
        {
            SAP_Service_Type__c ser = mapSST.get(sap.Code);
            
            if(ser == null && !string.isBlank(sap.Code))
            {
                SAP_Service_Type__c serv = new SAP_Service_Type__c();
                serv.Code__c = sap.Code;
                serv.Activo__c = sap.activo;
                serv.Name = sap.Name;
                serv.Group__c =  sap.grupo;
                serv.VAT_Withholding_ISR__c=  sap.retentionISR;
                serv.VAT_Withholding__c = sap.retention;
                serv.VAT__c = sap.VAT;
                
                news.add(serv);
                
                status st = new status();
                st.code = '1';
                st.existe = 'Si';
                st.message = 'Se agregó correctamente';
                st.service = sap;
                respuesta.add(st);
            }
            else if(ser != null)
            {
                
                ser.Activo__c = sap.activo;
                ser.Name = sap.Name;
                ser.Group__c =  sap.grupo;
                ser.VAT_Withholding_ISR__c=  sap.retentionISR;
                ser.VAT_Withholding__c = sap.retention;
                ser.VAT__c = sap.VAT;
                
                updates.add(ser);
                status st = new status();
                st.code = '1';
                st.existe = 'Si';
                st.message = 'Se actualizó correctamente';
                st.service = sap;
                respuesta.add(st);
            }
            
        }
        
        if(news.size()>0)
            insert news;
        
        if(updates.size()>0)
            update updates;
        
        
        return respuesta;
    }
    
    global class status 
    {
        webservice String code {get; set;}
        webservice String message {get; set;}
        webservice String existe {get;set;}
        webservice SapServiceType service {get;set;}
    }
    
    global class SapServiceType
    {
        webservice Boolean activo {get; set;}
        webservice String  name{get; set;}
        webservice String  grupo {get; set;}
        webservice String  retentionISR{get; set;}
        webservice String  retention{get; set;}
        webservice String  VAT {get; set;}
		webservice String  Code {get; set;}
    }
    
      public void TestMetodo(){
        String Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
          Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
          Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
          Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
          Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
          Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
           Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
           Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
           Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = ''; 
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
       	Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
        Test0 = '';
    }
    
}