public with sharing class p2g_CreateServiceLineQuote {
    public class quoteFeeLineWrapper {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String RateCategory { get; set; }
        @AuraEnabled public String RateName { get; set; } 
        @AuraEnabled public String Route { get; set; }  
        @AuraEnabled public Date ValidUntil {get;set;}
        @AuraEnabled public String Accountfor {get;set;}
        @AuraEnabled public Decimal TotalVolume {get;set;}
        @AuraEnabled public Decimal TotalWeight { get; set; }
        @AuraEnabled public String ContainerType { get; set; }
        @AuraEnabled public Decimal Units { get; set; }
        @AuraEnabled public String SellPrice { get; set; }
        @AuraEnabled public String StdBuyPrice { get; set; }
        @AuraEnabled public String CommentsServiceLine { get; set; }
        @AuraEnabled public String Carrier { get; set; }
        @AuraEnabled public String SSTS { get; set; }
        @AuraEnabled public String Moneda { get; set; }
    }
    @AuraEnabled
    public static list<SAP_Service_Type__c> getSapServiceTypeQuote(string SapService,String IdQuote){
        Customer_Quote__c quote =[SELECT FolioResume__c, Account_for__r.Tipo_de_Servicio_TNA__c FROM Customer_Quote__c WHERE Id =: IdQuote LIMIT 1];
        string grou = 'SP-' + quote.FolioResume__c + '%';
        string searchKeyword = '%' + SapService + '%';
        string nosearch1 = '';
        string nosearch2 = '';
        System.debug('el Tipo de Servicio TNA es: '+quote.Account_for__r.Tipo_de_Servicio_TNA__c);
        if(quote.Account_for__r != null){
            if(quote.Account_for__r.Tipo_de_Servicio_TNA__c == 'a1n4T000001XXYCQA4'){
                nosearch1 = 'SERVICIOS LOGISTICOS NACIONALES FN (IC) (FN)';
                nosearch2 = 'SERVICIOS LOGISTICOS LOCALES FN (IC) (FN)';
            }
            if(quote.Account_for__r.Tipo_de_Servicio_TNA__c == 'a1n4T000002JWphQAG' || quote.Account_for__r.Tipo_de_Servicio_TNA__c == null){
                nosearch1 = 'FLETE NACIONAL (IC) (FN)';
                nosearch2 = 'FLETE LOCAL (IC) (FN)';
            }          
        }
        
        List<String> nosearchValues = new List<String>{nosearch1, nosearch2};
            list<SAP_Service_Type__c> SapServiceListRecord = new list<SAP_Service_Type__c>();
        for(SAP_Service_Type__c sapServiceSearch : [SELECT Id, Name, Code__c FROM SAP_Service_Type__c 
                                                    WHERE Activo__c =: TRUE AND Name LIKE : searchKeyword AND Group__c LIKE : grou AND Name NOT IN :nosearchValues]){
                                                        SapServiceListRecord.add(sapServiceSearch);
                                                    }
        if(SapServiceListRecord.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
        }
        return SapServiceListRecord;
    } 
    //Seccion 1 inicia
    @AuraEnabled
    public static List<quoteFeeLineWrapper> getLineQuote(String Id) {
        List<quoteFeeLineWrapper> quoteFeeLines = new List<quoteFeeLineWrapper>();        
        List<Import_Export_Fee_Line__c> quoteFeeLineRecords = [
            SELECT Id, Name, Service_Rate_Category__c, Units__c,Quote_Sell_Price__c,Sell_Amount_Number__c,Quote_Buy_Price__c,
            Std_Buy_Amount_Number__c, Extension_Service_Name__c, Service_Rate_Name__c, Service_Rate_Name__r.Name,
            Service_Rate_Name__r.Route__r.Name, Service_Rate_Name__r.SAP_Service_Type__r.Name,
            Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.Account_for__r.Name,CurrencyIsoCode,
            Service_Rate_Name__r.Carrier_Account__r.Name, Service_Rate_Name__r.Container_Type__r.Name,
            Import_Export_Quote__r.Total_Volume_m3_2__c, Import_Export_Quote__r.Total_Weight_Kg2__c
            FROM Import_Export_Fee_Line__c WHERE Import_Export_Quote__c =:Id];
        for (Import_Export_Fee_Line__c feeLine : quoteFeeLineRecords) {
            quoteFeeLineWrapper wrapper = new quoteFeeLineWrapper();
            wrapper.Id = feeLine.Id;
            wrapper.Name = feeLine.Name;
            wrapper.RateCategory = feeLine.Service_Rate_Category__c;
            wrapper.RateName = feeLine.Service_Rate_Name__r.Name;
            wrapper.Route = feeLine.Service_Rate_Name__r.Route__r.Name;
            wrapper.ValidUntil = feeLine.Service_Rate_Name__r.Valid_Until__c;
            wrapper.Accountfor = feeLine.Service_Rate_Name__r.Account_for__r.Name;
            wrapper.TotalVolume = feeLine.Import_Export_Quote__r.Total_Volume_m3_2__c;
            wrapper.TotalWeight = feeLine.Import_Export_Quote__r.Total_Weight_Kg2__c;
            wrapper.ContainerType = feeLine.Service_Rate_Name__r.Container_Type__r.Name;
            wrapper.Units = feeLine.Units__c;
            wrapper.SellPrice = String.valueOf(feeLine.Quote_Sell_Price__c);
            wrapper.StdBuyPrice = String.valueOf(feeLine.Quote_Buy_Price__c);
            wrapper.CommentsServiceLine = feeLine.Extension_Service_Name__c;
            wrapper.SSTS = feeLine.Service_Rate_Name__r.SAP_Service_Type__r.Name;
            wrapper.Carrier = feeLine.Service_Rate_Name__r.Carrier_Account__r.Name;
            wrapper.Moneda = feeLine.CurrencyIsoCode;
            quoteFeeLines.add(wrapper);
        }       
        return quoteFeeLines;
    }
    //Seccion 1 termina
    //Seccion 2 Inicia
    @AuraEnabled(cacheable=true)
    public static List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> getRateTarifario(String Id) {
        Customer_Quote__c quote = [SELECT Id, Account_for__c, Route__c, FolioResume__c,Total_Volume_m3_2__c,Total_Weight_Kg2__c
                                   FROM Customer_Quote__c WHERE Id =: Id];
        Date fechaHoy = Date.today();
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> feeWrapper = new List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper>();        
        List<Fee__c> feeList = [SELECT Id, Name, Route__r.Name, CustomRate__c, Container_Type__r.Name,CurrencyIsoCode,Fee_Category__c,Group__c,
                                Account_for__r.Name, SAP_Service_Type__r.Name, Fee_Rate__c, Carrier_Account__r.Name,
                                SAP_Service_Type_Buy__r.Name, Buy_Rate__c, Valid_Until__c, Active__c FROM Fee__c 
                                WHERE (Account_for__c =: quote.Account_for__c OR Account_for__r.Name =: 'Cotizador') 
                                AND Route__c =: quote.Route__c AND CustomRate__c = True AND Active__c = True 
                                AND Valid_Until__c>=:fechaHoy];
        for (Fee__c fee : feeList) {
            P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper = llenadoTarifario(fee, quote);
            if(fee.Account_for__r.Name != 'Cotizador'){
                feeWrapper.add(wrapper);
            }else{
                feeWrapper.add(wrapper);
            }
        }
        return feeWrapper;
    }
    
    public static P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper llenadoTarifario(Fee__c fee,Customer_Quote__c quote ){
        P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper = new P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper();
        wrapper.Id = fee.Id;
        wrapper.ServiceRateName = fee.Name;
        wrapper.ShipmentRouteId = fee.Route__c;
        wrapper.ShipmentRouteName = fee.Route__r.Name;
        wrapper.Tarifario = fee.CustomRate__c;
        wrapper.ContainerTypeId = fee.Container_Type__c;
        wrapper.ContainerType = fee.Container_Type__r.Name;
        wrapper.AccountId = fee.Account_for__c;
        wrapper.Account = fee.Account_for__r.Name;
        wrapper.SapServiceTypeId = fee.SAP_Service_Type__c;
        wrapper.SapServiceType = fee.SAP_Service_Type__r.Name;
        wrapper.SellRate = String.valueOf(fee.Fee_Rate__c);
        wrapper.CarrierId = fee.Carrier_Account__c;
        wrapper.CarrierName = fee.Carrier_Account__r.Name;
        wrapper.SapServiceTypeBuyId = fee.SAP_Service_Type_Buy__c;
        wrapper.SapServiceTypeBuy = fee.SAP_Service_Type_Buy__r.Name;
        wrapper.BuyRate = String.valueOf(fee.Buy_Rate__c);
        wrapper.ValidUntil = fee.Valid_Until__c;
        wrapper.Activo = fee.Active__c;
        wrapper.seModifica = false;
        wrapper.idQuote = quote.Id;
        wrapper.Moneda = fee.CurrencyIsoCode;
        wrapper.FeeCategory = fee.Fee_Category__c;
        wrapper.Grou = fee.Group__c;
        wrapper.TotalVolume = String.valueOf(quote.Total_Volume_m3_2__c);
        wrapper.TotalWeight = String.valueOf(quote.Total_Weight_Kg2__c);
        return wrapper;
    }
    
    @AuraEnabled
    public static List<quoteFeeLineWrapper> CrearLineTarifario(String line, Integer numLinea){
        System.debug('Json que llego: '+ line);
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> listWrapper = P2G_UpdateShipmentServiceLine.CrearListaWrapper(line,numLinea);
        System.debug('La line wrapper: '+ listWrapper);
        //calcular nombre de linea
        Integer NameLine = CalculoNombreLine(listWrapper[0].idQuote);
        List<Import_Export_Fee_Line__c> listaFeeLine = new List<Import_Export_Fee_Line__c>();
        List<Fee__c> creaFee = new List<Fee__c>();
        String message;
        quoteFeeLineWrapper nuevalinea = new quoteFeeLineWrapper();
        List<quoteFeeLineWrapper> listaRespuesta = new List<quoteFeeLineWrapper>();
        try{
            System.debug('Entra al try');
            String IdQuote = listWrapper[0].IdQuote;
            for(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper fee: listWrapper){
                //Crear copia del service rate
                Fee__c newRate = CreateServiceRate(fee);
                creaFee.add(newRate);
            }
            Insert creaFee;
            for(Fee__c fee: creaFee){
                //Crear Lista Service linea
                Import_Export_Fee_Line__c feeLine = CreateServiceLine(NameLine,IdQuote,fee);
                listaFeeLine.add(feeLine); //Guardar en lista
                NameLine++;
            }
            //Crear service Line
            System.debug('la lista a modificar de Service Line es: '+listaFeeLine);
            insert listaFeeLine;
            integer posicion = 0;
            for(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper: listWrapper){
                P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper complementoWrapperLine = completeFieldsShowLine(wrapper,listaFeeLine[posicion],creaFee[posicion]);
                nuevalinea = rellenaSeccion(complementoWrapperLine);
                listaRespuesta.add(nuevalinea);
                posicion++;
            }
            message='Se realizo la inserción exitosamente';
        }catch(Exception e){
            System.debug('Entra al catch');
            nuevalinea = null;
            message='Error al realizar la inserción: '+e.getMessage()+e.getLineNumber();
            System.debug('Error al realizar la modificacion: '+e.getMessage()+e.getLineNumber());
        }
        System.debug('lo que devuelve es: '+nuevalinea);
        return listaRespuesta;
    }
    //Seccion 2 Termina
    //Seccion 3 Inicia
    @AuraEnabled(cacheable=true)
    public static List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> getCreaLine(String Id) {
        Integer NameLine = CalculoNombreLine(Id);
        List<Customer_Quote__c> listQuote = [SELECT Name, Account_for__c, Account_for__r.Name, Route__c, Route__r.Name,FolioResume__c,Freight_Mode__c,
                                             Total_Volume_m3_2__c, Total_Weight_Kg2__c, CurrencyIsoCode FROM Customer_Quote__c WHERE Id =: Id];
        Quote_Item_Line__c cargo = [SELECT Container_Type__c, Container_Type__r.Name FROM Quote_Item_Line__c 
                                    WHERE Import_Export_Quote__c=:Id LIMIT 1];
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> listaLine = new List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper>();
        for(Customer_Quote__c quote : listQuote){
            P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper = new P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper();
            wrapper.Name = '00'+String.valueOf(NameLine);
            wrapper.ShipmentRouteId = quote.Route__c;
            wrapper.ShipmentRouteName = quote.Route__r.Name;
            wrapper.ContainerTypeId = cargo.Container_Type__c;
            wrapper.ContainerType = cargo.Container_Type__r.Name;
            wrapper.AccountId = quote.Account_for__c;
            wrapper.Account = quote.Account_for__r.Name;
            wrapper.seModifica = false;
            wrapper.Grou = quote.FolioResume__c;
            wrapper.FeeCategory = quote.Freight_Mode__c;
            wrapper.TotalVolume=String.valueOf(quote.Total_Volume_m3_2__c);
            wrapper.TotalWeight=String.valueOf(quote.Total_Weight_Kg2__c);
            wrapper.Moneda = quote.CurrencyIsoCode;
            wrapper.idQuote = Id;
            wrapper.idQuoteName = quote.Name;//listSsts
            
            listaLine.add(wrapper);
        }
        return listaLine;
    }
    @AuraEnabled
    public static quoteFeeLineWrapper Create(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper data){
        Integer NameLine = CalculoNombreLine(data.IdQuote);
        Fee__c ServiceRate = P2G_UpdateShipmentServiceLine.CreateServiceRate(data);
        insert ServiceRate;
        Import_Export_Fee_Line__c serviceLine = CreateServiceLine(NameLine,data.IdQuote,ServiceRate);
        insert serviceLine;
        
        data.ValidUntil = Date.today();
        P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper complementoWrapperLine = completeFieldsShowLine(data,serviceLine,ServiceRate);
        quoteFeeLineWrapper nuevaLinea = rellenaSeccion(complementoWrapperLine);
        return nuevaLinea;    
    }
    //Seccion 3 Termina
    public static Integer CalculoNombreLine(String idQuote){
        List<AggregateResult> quote = [SELECT COUNT(Id) FROM Import_Export_Fee_Line__c WHERE Import_Export_Quote__c =:idQuote];
        Integer contador = 0;
        for(AggregateResult ar: quote){
            contador += integer.valueOf(ar.get('expr0'));
        }
        contador = contador+1;
        System.debug('el resultado agregado: '+contador);
        return contador;
    }
    
    public static Import_Export_Fee_Line__c CreateServiceLine(Integer name,String idQuote,Fee__c fee){
        Import_Export_Fee_Line__c serviceLine = new Import_Export_Fee_Line__c();
        serviceLine.Import_Export_Quote__c = idQuote;
        serviceLine.Name = '00'+String.valueOf(name);
        serviceLine.Conversion_Rate_to_Currency_Header__c= integer.valueOf('1');
        serviceLine.Tarifario_ServRate__c = integer.valueOf('1');
        serviceLine.Units__c = 1;
        serviceLine.CurrencyIsoCode	= fee.CurrencyIsoCode;
        serviceLine.Service_Rate_Name__c = fee.Id;
        serviceLine.Quote_Sell_Price__c = fee.Fee_Rate__c;
        serviceLine.Quote_Buy_Price__c = fee.Buy_Rate__c;
        return serviceLine;
    }
    
    public static P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper completeFieldsShowLine(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper,Import_Export_Fee_Line__c line,Fee__c fee){
        Wrapper.Id = line.Id;
        Wrapper.Name = line.Name;
        Wrapper.FeeCategory = fee.Fee_Category__c;
        Wrapper.ShipmentSellPrice = String.valueOf(line.Units__c);
        Wrapper.ShipmentBuyPrice = line.Extension_Service_Name__c;
        return wrapper;
    }
    
    public static quoteFeeLineWrapper rellenaSeccion(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper line){
        quoteFeeLineWrapper nuevaLinea = new quoteFeeLineWrapper();
        nuevaLinea.Id = line.Id;
        nuevaLinea.Name = line.Name;
        nuevaLinea.RateCategory = line.FeeCategory;
        nuevaLinea.RateName = line.ServiceRateName;
        nuevaLinea.Route = line.ShipmentRouteName;
        nuevaLinea.ValidUntil = line.ValidUntil;
        nuevaLinea.Accountfor = line.Account;
        nuevaLinea.TotalVolume = Decimal.valueOf(line.TotalVolume);
        nuevaLinea.TotalWeight = Decimal.valueOf(line.TotalWeight);
        nuevaLinea.ContainerType = line.ContainerType;
        nuevaLinea.Units = Decimal.valueOf(line.ShipmentSellPrice);
        nuevaLinea.SellPrice = line.SellRate;
        nuevaLinea.StdBuyPrice = line.BuyRate;
        nuevaLinea.CommentsServiceLine = line.ShipmentBuyPrice;
        nuevaLinea.Carrier = line.CarrierName;
        nuevaLinea.SSTS = line.SapServiceType;
        nuevaLinea.Moneda = line.Moneda;
        System.debug('El wrapper final '+nuevaLinea);
        return nuevaLinea;
    }
    
    public static Fee__c CreateServiceRate(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper data){
        String recordTypeId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        Fee__c serviceRate = new Fee__c();
        try{         
            serviceRate.RecordTypeId = recordTypeId;
            serviceRate.Name = data.ServiceRateName; 
            serviceRate.Route__c = data.ShipmentRouteId; 
            serviceRate.CurrencyIsoCode = data.Moneda; 
            serviceRate.Fee_Category__c = data.FeeCategory; 
            serviceRate.Group__c = data.Grou;
            serviceRate.SAP_Service_Type__c = data.SapServiceTypeId;
            serviceRate.Container_Type__c = data.ContainerTypeId;
            serviceRate.TT_Days__c = '1';
            serviceRate.Rate_Type__c = 'Fixed';
            serviceRate.Account_for__c = data.AccountId;
            serviceRate.Active__c=true;
            if(data.SapServiceTypeBuyId != null){serviceRate.SAP_Service_Type_Buy__c = data.SapServiceTypeBuyId;}
            if(data.SellRate != null){serviceRate.Fee_Rate__c = Decimal.valueOf(data.SellRate);}else{serviceRate.Fee_Rate__c =0;}
            if(data.BuyRate != null){serviceRate.Buy_Rate__c = Decimal.valueOf(data.BuyRate);}else{serviceRate.Buy_Rate__c =0;}
            if(data.Activo != null){serviceRate.P2G_SapDevolucion__c = data.Activo;}
            if(data.ShipmentBuyPrice != null){serviceRate.Comments__c = data.ShipmentBuyPrice;}
            if(data.CarrierId != null){serviceRate.Carrier_Account__c = data.CarrierId;}
        }catch(Exception e){
            System.debug('Error rellenar CreateServiceRate: '+e.getMessage());
        }   
        return serviceRate; 
    }
}