public  with sharing class P2G_CreacionCargoLines {
    
    @AuraEnabled(cacheable=true)
    public static list<Catalogo_SAT__c> getClaveSAT(string sat,String record){
        list<Catalogo_SAT__c> ListClaveSAT = new list<Catalogo_SAT__c>();
        String recordTypeId = Schema.SObjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Productos y Servicios cP').getRecordTypeId();
        if(record == '1'){
            recordTypeId = Schema.SObjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Productos y Servicios cP').getRecordTypeId();
        }
        if(record == '2'){
            recordTypeId = Schema.SObjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Material Peligroso').getRecordTypeId();
        }
        if(record == '3'){
            recordTypeId = Schema.SObjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Embalaje').getRecordTypeId();
        }
        
        if(record == '4'){
            recordTypeId = Schema.SObjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Unidad Peso').getRecordTypeId();
        }
			  ListClaveSAT = getClaveSATRecord(sat,recordTypeId);    
        return  ListClaveSAT;
    }
    
    public static list<Catalogo_SAT__c> getClaveSATRecord(String searchKey,String recorType){
        string searchKeyword = '%' + searchKey + '%';
        list<Catalogo_SAT__c> ListClaveSAT = new list<Catalogo_SAT__c>();
        for(Catalogo_SAT__c sideClaveSAT : [SELECT Id, Name, Clave_SAT__c FROM Catalogo_SAT__c 
                                            where Name LIKE : searchKeyword and RecordTypeId =: recorType limit 20]){
                                                ListClaveSAT.add(sideClaveSAT);
                                            }
        
        if(ListClaveSAT.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return ListClaveSAT;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<Container_Type__c> getContainerType(string Container){
        string searchKeyword = '%' + Container + '%';
        list<Container_Type__c> ListContainerType = new list<Container_Type__c>();
        for(Container_Type__c sideContainerType : [SELECT Id, Name , Cargo_Weight_Kg__c, Cargo_Volume_m3__c 
                                                   FROM Container_Type__c where Name LIKE : searchKeyword limit 20]){
                                                       ListContainerType.add(sideContainerType);
                                                   }
        
        if(ListContainerType.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return ListContainerType;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static list<Quote_Item_Line__c> getCargoLine(List<Customer_Quote__c> listaFolio){
        List<Quote_Item_Line__c> conItem = new List<Quote_Item_Line__c>();
        
        Customer_Quote__c idName = [SELECT Id FROM Customer_Quote__c where Id =: listaFolio limit : 1];
           
         for(Quote_Item_Line__c consulta : [SELECT Id ,CE_Descripcion_de_Producto_PAK__c,Name,Container_Type__r.Name, Clave_de_Servicio__r.Name,
										   Extension_Item_Name__c,CurrencyIsoCode,Units__c,Total_Shipping_Weight_Kgs__c,Peso_Neto__c,Total_Shipping_Volume_m3__c,
                                           Material_Peligroso_Cat__r.Name,Embalaje_Cat__r.Name FROM Quote_Item_Line__c WHERE Import_Export_Quote__c =: idName.Id]){
                                           conItem.add(consulta);
                                       }
        for(Quote_Item_Line__c item:conItem){
        }
        return conItem;
    }   
    
    @AuraEnabled(cacheable=true)
    public static Import_Export_Fee_Line__c getServiceLine(String idQuote){
        Import_Export_Fee_Line__c consulta = [SELECT Id, Name, Conversion_Rate_to_Currency_Header__c,Service_Rate_Category__c,Sell_Rate__c,
                                              Tarifario__c, route__c, Quote_Sell_Price__c,Units__c,CurrencyIsoCode,Service_Rate_Name__r.Name
                                              FROM Import_Export_Fee_Line__c WHERE Import_Export_Quote__c =: idQuote 
                                              order by CreatedDate desc limit 1];
        return consulta;
    } 
    @AuraEnabled
    public static list<Customer_Quote__c> getCustomerQuote(string folio, string Customer){
        string searchKeyword = '%' + folio + '%';
        list<Customer_Quote__c> CustomerListRecord = new list<Customer_Quote__c>();
        for(Customer_Quote__c customerSearch : [SELECT Id, Name FROM Customer_Quote__c 
                                                WHERE Account_for__c = :Customer and name LIKE : searchKeyword 
                                                order by name desc LIMIT 10]){
                                                    CustomerListRecord.add(customerSearch);
                                                }
        if(CustomerListRecord.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return CustomerListRecord;
    }
    @AuraEnabled
    public static void updatePriceList(List<Customer_Quote__c> listaFolio,String price, String sapType){
        System.debug('Lista folios: ' + listaFolio +' Sap service type: '+sapType);
        list<Import_Export_Fee_Line__c> serviceLine = [Select Quote_Sell_Price__c,Service_Rate_Name__c From Import_Export_Fee_Line__c 
                                                       Where Import_Export_Quote__c =: listaFolio AND Sap_Service_Type__c =: sapType];
        set<id> busquedaId= new set<id>();
        for(Import_Export_Fee_Line__c line:serviceLine){
            busquedaId.add(line.Service_Rate_Name__c);
        	line.Quote_Sell_Price__c = Double.valueOf(price);
        }
        update serviceLine;
        list<Fee__c> serviceRate = [Select Id, Fee_Rate__c FROM Fee__c WHERE Id IN:busquedaId];
        for(Fee__c rate:serviceRate){
        	rate.Fee_Rate__c = Double.valueOf(price);
        }
        update serviceRate;
    }
        @AuraEnabled
    public static void updatePrice(List<Customer_Quote__c> listaFolio,String price, String sapType){
        
        list<Import_Export_Fee_Line__c> serviceLine = [Select Quote_Sell_Price__c From Import_Export_Fee_Line__c 
                                                       Where Import_Export_Quote__c =: listaFolio AND Sap_Service_Type__c =: sapType];
        for(Import_Export_Fee_Line__c line:serviceLine){
        	line.Quote_Sell_Price__c = Double.valueOf(price);
        }
        update serviceLine;
    }
    
        @AuraEnabled
    public static list<Location__c> getSideCountry(string country){
        string searchKeyword = '%' + country + '%';
        list<Location__c> contactListRecord = new list<Location__c>();
        for(Location__c sideCountry : [SELECT Id, Name, Country__c, State__c FROM Location__c
                                       WHERE name LIKE : searchKeyword]){
                                           contactListRecord.add(sideCountry);
                                       }
        
        if(contactListRecord.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return contactListRecord;
    }
    @AuraEnabled
    public static list<Account> getAccount(string account){
        string searchKeyword = '%' + account + '%';
        list<Account> AccountListRecord = new list<Account>();
        for(Account accountSearch : [SELECT Id, Name, Customer_Id__c FROM Account
                                     WHERE Name LIKE : searchKeyword limit 20]){
                                         AccountListRecord.add(accountSearch);
                                     }
        if(AccountListRecord.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return AccountListRecord;
    }
    @AuraEnabled
    public static list<Account_Address__c> getAccountAddress(string address, string account){
        string searchKeyword = '%' + address + '%';
        list<Account_Address__c> addressListRecord = new list<Account_Address__c>();
        for(Account_Address__c addressSearch : [SELECT Id, Name FROM Account_Address__c
                                     WHERE Name LIKE : searchKeyword AND Account__c =: account limit 20]){
                                         addressListRecord.add(addressSearch);
                                     }
        if(addressListRecord.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return addressListRecord;
    }
    @AuraEnabled(cacheable=true)
    public static list<SAP_Service_Type__c> getSapServiceType(string sapServiceT){
        string searchKeyword = '%' + sapServiceT + '%';
        list<SAP_Service_Type__c> ListSapServiceT = new list<SAP_Service_Type__c>();
        for(SAP_Service_Type__c sapService : [SELECT Id, Name FROM SAP_Service_Type__c where Name LIKE : searchKeyword AND Group__c='SP-FN-FLETE NACIONAL' limit 20]){
                                                       ListSapServiceT.add(sapService);
                                                   }
        
        if(ListSapServiceT.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return ListSapServiceT;
    }
}