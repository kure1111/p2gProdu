public with sharing class P2G_UpdateShipmentServiceLine {
    public class shipmentFeeLineWrapper {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String ServiceRateName { get; set; } 
        @AuraEnabled public String ShipmentRouteName { get; set; }
        @AuraEnabled public String ShipmentRouteId { get; set; }
        @AuraEnabled public String Account {get;set;}
        @AuraEnabled public Boolean Tarifario{get;set;}
        @AuraEnabled public String ContainerType{get;set;}
        @AuraEnabled public String ContainerTypeId{get;set;}
        @AuraEnabled public String CarrierName { get; set; }
        @AuraEnabled public String ShipmentName { get; set; }
        @AuraEnabled public String ShipmentId { get; set; }
        //mostrar listas relacionadas
        @AuraEnabled public Boolean listCarrier{get;set;}
        @AuraEnabled public Boolean listSstb{get;set;}
        @AuraEnabled public Boolean listSsts{get;set;}
        //actualizar
        @AuraEnabled public String ShipmentSellPrice { get; set; }
        @AuraEnabled public String SapServiceTypeId { get; set; }
        @AuraEnabled public String SapServiceType { get; set; }
        @AuraEnabled public String CarrierId { get; set; }
        @AuraEnabled public String ShipmentBuyPrice { get; set; }
        @AuraEnabled public String SapServiceTypeBuyId { get; set; }
        @AuraEnabled public String SapServiceTypeBuy { get; set; }
        @AuraEnabled public String ServiceRateId { get; set; }   
        @AuraEnabled public String AccountId {get;set;}
        @AuraEnabled public Boolean seModifica{get;set;}
        //Crear service line
        @AuraEnabled public String SellRate{get;set;}
        @AuraEnabled public String BuyRate{get;set;}
        @AuraEnabled public Date ValidUntil{get;set;}
        @AuraEnabled public Boolean Activo {get;set;}
        @AuraEnabled public String IdQuote {get;set;}
        @AuraEnabled public String IdQuoteName {get;set;}
        @AuraEnabled public String Moneda {get;set;}
        @AuraEnabled public String FeeCategory {get;set;}
        @AuraEnabled public String Grou {get;set;}
        @AuraEnabled public String TotalVolume {get;set;}
        @AuraEnabled public String TotalWeight { get; set; }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<ShipmentFeeLineWrapper> getLineSp(String Id) {
        List<ShipmentFeeLineWrapper> shipmentFeeLines = new List<ShipmentFeeLineWrapper>();        
        List<Shipment_Fee_Line__c> shipmentFeeLineRecords = [
            SELECT Id, Name, Sap_Service_Type_Buy__c, Sap_Service_Type__c, Service_Rate_Name__c,Service_Rate_Name__r.Account_for__c,
            Service_Rate_Name__r.CustomRate__c,Service_Rate_Name__r.Name,Service_Rate_Name__r.Account_for__r.Name,
            Shipment_Buy_Price__c,Shipment__r.Name,Shipment_Sell_Price__c,Carrier__c,Shipment__r.Route__c,
            Shipment__r.Shipment_Currency__c, Shipment__r.Freight_Mode__c,Shipment__r.Shipment_Type__c,
            Shipment__r.Route__r.Name,Service_Rate_Name__r.Sap_Service_Type__c,Service_Rate_Name__r.Carrier_Account__c,
            Service_Rate_Name__r.SAP_Service_Type_Buy__c FROM Shipment_Fee_Line__c WHERE Shipment__c =:Id];
        Shipment_Line__c shipmentCargoLine;
        if(!Test.isRunningTest()){
            shipmentCargoLine =[SELECT Container_Type__c,Container_Type__r.Name FROM Shipment_Line__c WHERE Shipment__c =: Id LIMIT 1];
        }
        for (Shipment_Fee_Line__c feeLine : shipmentFeeLineRecords) {
            ShipmentFeeLineWrapper wrapper = new ShipmentFeeLineWrapper();
            wrapper.Id = feeLine.Id;
            wrapper.Name = feeLine.Name;
            wrapper.ServiceRateName = feeLine.Service_Rate_Name__r.Name;
            wrapper.ShipmentRouteName = feeLine.Shipment__r.Route__r.Name;
            wrapper.ShipmentRouteId = feeLine.Shipment__r.Route__c;
            wrapper.Account = feeLine.Service_Rate_Name__r.Account_for__r.Name;
            wrapper.AccountId = feeLine.Service_Rate_Name__r.Account_for__c;
            wrapper.Tarifario = feeLine.Service_Rate_Name__r.CustomRate__c;
            if(!Test.isRunningTest()){
        	wrapper.ContainerType = shipmentCargoLine.Container_Type__r.Name;
            wrapper.ContainerTypeId = shipmentCargoLine.Container_Type__c;}
            wrapper.CarrierName = feeLine.Carrier__c;
            wrapper.CarrierId = feeLine.Service_Rate_Name__r.Carrier_Account__c;
            wrapper.ShipmentName = feeLine.Shipment__r.Name;
            wrapper.ShipmentSellPrice = String.valueOf(feeLine.Shipment_Sell_Price__c);
            wrapper.SapServiceType = feeLine.Sap_Service_Type__c;
            wrapper.SapServiceTypeId = feeLine.Service_Rate_Name__r.Sap_Service_Type__c;
            wrapper.ShipmentBuyPrice = String.valueOf(feeLine.Shipment_Buy_Price__c);
            wrapper.SapServiceTypeBuy = feeLine.Sap_Service_Type_Buy__c;
            wrapper.SapServiceTypeBuyId = feeLine.Service_Rate_Name__r.Sap_Service_Type_Buy__c;
            wrapper.ServiceRateId = feeLine.Service_Rate_Name__c;
            wrapper.ShipmentId = Id;
            wrapper.seModifica = false;
            wrapper.Moneda = feeLine.Shipment__r.Shipment_Currency__c;
            wrapper.FeeCategory = feeLine.Shipment__r.Freight_Mode__c;
            wrapper.Grou = feeLine.Shipment__r.Shipment_Type__c;
            shipmentFeeLines.add(wrapper);
        } 
        System.debug('Lista que se envia: '+ shipmentFeeLines);
        return shipmentFeeLines;
    }
    
    @AuraEnabled(cacheable=true)
    public static Shipment__c getShipmentName(string Id){
        return [SELECT Id, Name FROM Shipment__c WHERE Id =: Id];   
    }
    
    @AuraEnabled
    public static Boolean getStatusClose(string Id){
        Boolean status = false;
        Shipment__c shipment = [SELECT Id, Shipment_Status_Plann__c FROM Shipment__c WHERE Id =: Id];
        if(shipment.Shipment_Status_Plann__c == 'Closed'){
            status = true;
        }
        return status;
    }
    
    @AuraEnabled
    public static void updateStatus(string Id, String status){
        Shipment__c shipment = [SELECT Id, Shipment_Status_Plann__c FROM Shipment__c WHERE Id =: Id];
        shipment.Shipment_Status_Plann__c = status;
        update shipment;
    }
    
    @AuraEnabled
    public static list<Account> getCarrier(string carrier){
        string searchKeyword = '%' + carrier + '%';
        String recordCarrier = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
        list<Account> AccountListRecord = new list<Account>();
        for(Account accountSearch : [SELECT Id, Name, Customer_Id__c FROM Account
                                     WHERE RecordTypeId =: recordCarrier AND ActiveSap__c = TRUE AND Name LIKE : searchKeyword limit 15]){
                                         AccountListRecord.add(accountSearch);
                                     }
        if(AccountListRecord.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return AccountListRecord;
    } 
    /*@AuraEnabled
    public static list<SAP_Service_Type__c> getSapServiceType(string SapService){
        string searchKeyword = '%' + SapService + '%';
        list<SAP_Service_Type__c> SapServiceListRecord = new list<SAP_Service_Type__c>();
        for(SAP_Service_Type__c sapServiceSearch : [SELECT Id, Name FROM SAP_Service_Type__c
                                                    WHERE Name LIKE : searchKeyword limit 15]){
                                                        SapServiceListRecord.add(sapServiceSearch);
                                                    }
        if(SapServiceListRecord.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return SapServiceListRecord;
    } */
    @AuraEnabled
    public static list<SAP_Service_Type__c> getSapServiceTypeShipment(string SapService, String IdShip){
        Shipment__c ship =[SELECT Shipment_Type__c FROM Shipment__c WHERE Id =: IdShip LIMIT 1];
        string grou = 'SP-' + ship.Shipment_Type__c + '%';
        string searchKeyword = '%' + SapService + '%';
        list<SAP_Service_Type__c> SapServiceListRecord = new list<SAP_Service_Type__c>();
        for(SAP_Service_Type__c sapServiceSearch : [SELECT Id, Name, Code__c FROM SAP_Service_Type__c 
                                                    WHERE Activo__c =: TRUE AND Name LIKE : searchKeyword AND Group__c LIKE : grou]){
                                                        SapServiceListRecord.add(sapServiceSearch);
                                                    }
        if(SapServiceListRecord.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return SapServiceListRecord;
    }
    @AuraEnabled
    public static list<Account> getCustomer(string customer){
        string searchKeyword = '%' + customer + '%';
        String recordCustomer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        list<Account> CustomerListRecord = new list<Account>();
        for(Account customerSearch : [SELECT Id, Name, Customer_Id__c FROM Account
                                      WHERE RecordTypeId =: recordCustomer AND Name LIKE : searchKeyword limit 20]){
                                          CustomerListRecord.add(customerSearch);
                                      }
        if(CustomerListRecord.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return CustomerListRecord;
    }
    @AuraEnabled
    public static shipmentFeeLineWrapper getwrapper(){
        shipmentFeeLineWrapper service = new shipmentFeeLineWrapper();
        return service;
    }
    //metodo que realiza las modificaciones
    @AuraEnabled
    public static String ChangeLine(String line, Integer numLinea){
        //System.debug('Json que llego: '+ line);
        List<shipmentFeeLineWrapper> listWrapper = CrearListaWrapper(line,numLinea);
        System.debug('La line wrapper: '+ listWrapper);
        List<Shipment_Fee_Line__c> listaFeeLine = new List<Shipment_Fee_Line__c>();
        set<Shipment__c> listaShipSet = new set<Shipment__c>();
        List<shipmentFeeLineWrapper> listaWrapperRate = new List<shipmentFeeLineWrapper>();
        String message;
        try{
            System.debug('Entra al try');
            integer posicion = 0;
            for(shipmentFeeLineWrapper fee: listWrapper){
                //actualizacion de la Service linea
                Shipment_Fee_Line__c feeLine = listaupdateFeeLine(fee);
                listaFeeLine.add(feeLine); //Guardar en lista
                //Si no es tarifario actualiza 
                if(fee.Tarifario == false){
                    //Lista de Service Rate a modificar
                    listaWrapperRate.add(fee);
                    /*//Lista para actualizar Shipment
Shipment__c updateship = listaShipment(fee);
listaShip.add(updateship);*/
                }
            }
            //Service Rate a Modificar
            //Buscar Service Rate Repetidos en la lista
            System.debug('lista de rate a modificar: '+listaWrapperRate.size()+' '+listaWrapperRate);
            List<shipmentFeeLineWrapper> rateRepetido =  rateRepetido(listaWrapperRate);
            System.debug('lista de rate repetido: '+rateRepetido);
            //Crear nueva Service Rate y actualizar a Service Line
            CrearNuevoServiceRate(rateRepetido);
            //Lista de Service Rate a Modificar
            List<Fee__c> listUpdateRate = listaUpdateRate(listaWrapperRate, rateRepetido);
            System.debug('lista de rate a modificar: '+listUpdateRate);
            update listUpdateRate;
            //Modifica service Line
            System.debug('la lista a modificar de Service Line es: '+listaFeeLine);
            update listaFeeLine;
                        /*//Modifica Shipment
            if(listaShipSet.size() != 0){
            List<Shipment__c> listaShip = updateShipment(listaShipSet);
            update listaShip;
            }*/
            message='Modificacion exitosa';
        }catch(Exception e){
            System.debug('Entra al catch');
            message='Error al realizar la modificacion: '+e.getMessage()+e.getLineNumber();
            System.debug('Error al realizar la modificacion: '+e.getMessage()+e.getLineNumber());
        }
        
        return message;
    }
    public static List<shipmentFeeLineWrapper> CrearListaWrapper(String line, Integer numLinea){
        String getbod;
        //Acomodar el Json para la deserializacion
        for(integer i=0; i<=numLinea; i++){
            getbod = line.replace('"'+i+'":','');
            line = getbod;
        }
        System.debug('modi: '+ getbod);
        String getbody = getBod.removeStart('{');
        String getbody2 = getbody.removeEnd('}');
        String contenido = '['+getbody2+']';
        System.debug('La line contiene: '+ contenido);
        
        //Deserializar y ponerlo en una lista wrapper
        List<shipmentFeeLineWrapper> listWrapper = (List<shipmentFeeLineWrapper>)JSON.deserialize(contenido, List<shipmentFeeLineWrapper>.class);
        
        return listWrapper;
    }
    public static Shipment_Fee_Line__c listaupdateFeeLine(shipmentFeeLineWrapper wrapper){
        Shipment_Fee_Line__c feeLine = new Shipment_Fee_Line__c();
        feeLine.Id = wrapper.Id;
        feeLine.Shipment_Sell_Price__c = Decimal.valueOf(wrapper.ShipmentSellPrice);
        feeLine.Shipment_Buy_Price__c = Decimal.valueOf(wrapper.ShipmentBuyPrice);
        System.debug('Lista para actualizar el Service Line: '+feeLine);
        return feeLine;
    }
    public static Fee__c updateFee(shipmentFeeLineWrapper fee){
        Fee__c updatefee = new Fee__c();
        updatefee.Id = fee.ServiceRateId;
        updatefee.SAP_Service_Type_Buy__c = fee.SapServiceTypeBuyId;
        updatefee.SAP_Service_Type__c = fee.SapServiceTypeId;
        //updatefee.Account_for__c = fee.AccountId;
        updatefee.Carrier_Account__c = fee.CarrierId;
        System.debug('Devuelve un registro rste: '+ updatefee);
        return updatefee;
    }
    public static List<shipmentFeeLineWrapper> rateRepetido(List<shipmentFeeLineWrapper> listaWrapperRate){
        List<shipmentFeeLineWrapper> buscarlistaRate = new List<shipmentFeeLineWrapper>();
        for (shipmentFeeLineWrapper fee : listaWrapperRate){
            for (Integer i=0; i<listaWrapperRate.size(); i++){
                if ((fee.Id != listaWrapperRate[i].Id) && (fee.ServiceRateId == listaWrapperRate[i].ServiceRateId)) {
                    buscarlistaRate.add(fee);
                }
            }
        }
        List<shipmentFeeLineWrapper> listaRate = buscarlistaRate;
        List<shipmentFeeLineWrapper> listaRateModificada = buscarlistaRate;
        System.debug('lista rate reperidos: '+buscarlistaRate);
        for(Integer i=0; i<buscarlistaRate.size(); i++) {
            if(listaRate[0].Id == buscarlistaRate[i].Id){
                listaRateModificada.remove(i);
                listaRate = actualizarlistaRepetidos(listaRate);
                System.debug('lista rate: '+listaRate);
            }
        }
        System.debug('lista rate Modificada: '+listaRateModificada);
        if(listaRateModificada.size() == 0){
            listaRateModificada = null;
        }
        return listaRateModificada;
    }
    public static List<shipmentFeeLineWrapper> actualizarlistaRepetidos(List<shipmentFeeLineWrapper> listaRate){
        List<shipmentFeeLineWrapper> newfee = new List<shipmentFeeLineWrapper>();
        for(Integer i=1; i<listaRate.size();i++){
            if(listaRate[0].ServiceRateId != listaRate[i].ServiceRateId){
                newfee.add(listaRate[i]);
            }
        }
        if(newfee.size() == 0){
            newfee = null;
        }
        return newfee;
    }
    public static List<Fee__c> listaUpdateRate(List<shipmentFeeLineWrapper> listaWrapperRate, List<shipmentFeeLineWrapper> rateRepetido){
        List<shipmentFeeLineWrapper> listUpdateRate = listaWrapperRate;
        List<Fee__c> listaRate = new List<Fee__c>();
        if(rateRepetido != null){
            for (Integer i=0; i<listaWrapperRate.size(); i++){
                for (shipmentFeeLineWrapper feeReperido : rateRepetido){
                    if ((listaWrapperRate[i].Id == feeReperido.Id)) {
                        listUpdateRate.remove(i);
                    }
                }
            }
            for(shipmentFeeLineWrapper lisUpdateRate : listUpdateRate){
                Fee__c updatefee = updateFee(lisUpdateRate);
                listaRate.add(updatefee);
            }
        }else{
            for (shipmentFeeLineWrapper fee : listaWrapperRate){
                Fee__c updatefee = updateFee(fee);
                listaRate.add(updatefee);
            }
        }
        if(listaRate.size() == 0){
            listaRate = null;
        }
        return listaRate;
    }
    public static void CrearNuevoServiceRate(List<shipmentFeeLineWrapper> rateRepetido){
        List<String> idLine = new List<String>();
        List<Fee__c> creaFee = new List<Fee__c>();
        List<Shipment_Fee_Line__c> updateFeeLine = new List<Shipment_Fee_Line__c>();
        if(rateRepetido != null){
            for(shipmentFeeLineWrapper Fee: rateRepetido){
                Fee__c newRate = CreateServiceRate(Fee);
                creaFee.add(newRate);
                idLine.add(Fee.Id);
            }
            insert creaFee;
            System.debug('Rate creadas: '+rateRepetido.size() +' '+creaFee);
            for(shipmentFeeLineWrapper newFee: rateRepetido){
                for(integer i=0; i<idLine.size();i++){
                    if(newFee.Id == idline[i]){
                        Shipment_Fee_Line__c feeLine = new Shipment_Fee_Line__c();
                        feeLine.Id = newFee.Id;
                        feeLine.Service_Rate_Name__c = creaFee[i].Id;
                        updateFeeLine.add(feeLine);
                    }
                }
            }
            update updateFeeLine;
        }
    }
    public static Fee__c CreateServiceRate(shipmentFeeLineWrapper wrapper){
        String recordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        String category = wrapper.FeeCategory + '%';
        String grou = 'SP-'+ wrapper.Grou +'%';
        Fee__c campos;
         if(!Test.isRunningTest()){campos =[SELECT Fee_Category__c, Group__c FROM fee__c WHERE Fee_Category__c LIKE: Category and Group__c LIKE:grou LIMIT 1];}
        Fee__c serviceRate = new Fee__c();
        try{
            serviceRate.RecordTypeId = recordTypeId;
            serviceRate.Name = wrapper.ServiceRateName;
            serviceRate.Route__c = wrapper.ShipmentRouteId; 
            serviceRate.CurrencyIsoCode = wrapper.moneda;
            serviceRate.SAP_Service_Type__c = wrapper.SapServiceTypeId;
            serviceRate.Container_Type__c = wrapper.ContainerTypeId;
            serviceRate.TT_Days__c = '1';
            serviceRate.Rate_Type__c = 'Fixed';
            serviceRate.Account_for__c = wrapper.AccountId;
            serviceRate.Active__c=true;
            serviceRate.Fee_Category__c = campos.Fee_Category__c; 
            serviceRate.Group__c = campos.Group__c;
            if(wrapper.SapServiceTypeBuyId != null){serviceRate.SAP_Service_Type_Buy__c = wrapper.SapServiceTypeBuyId;}
            if(wrapper.SellRate != null){serviceRate.Fee_Rate__c = Decimal.valueOf(wrapper.SellRate);}
            if(wrapper.BuyRate != null){serviceRate.Buy_Rate__c = Decimal.valueOf(wrapper.BuyRate);}
            if(wrapper.Activo != null){serviceRate.P2G_SapDevolucion__c = wrapper.Activo;}
            if(wrapper.ShipmentBuyPrice != null){serviceRate.Comments__c = wrapper.ShipmentBuyPrice;}
            if(wrapper.CarrierId != null){serviceRate.Carrier_Account__c = wrapper.CarrierId;}
            //serviceRate.Carrier_Account__c = carrier;
        }catch(Exception e){
            System.debug('Error rellenar CreateServiceRate: '+e.getMessage());
        }
        return serviceRate; 
    }
    /*public static Shipment__c listaShipment(shipmentFeeLineWrapper fee){
Shipment__c updateship = new Shipment__c();
if((fee.SapServiceType == 'SERVICIOS LOGISTICOS NACIONALES FN (IC) (FN)')||(fee.SapServiceType == 'SERVICIOS LOGISTICOS FN (IC) (FN)')||(fee.SapServiceType == 'FLETE NACIONAL (IC) (FN)')){
updateship.Id = fee.ShipmentId;
updateship.Account_for__c = fee.AccountId;
}
return updateship;
}
public static List<Shipment__c> updateShipment(set<Shipment__c> listaShipSet){
List<Shipment__c> listaShip = new List<Shipment__c>();
for (Shipment__c ship : listaShipSet){
listaShip.add(ship);
}
return listaShip;
}*/
}