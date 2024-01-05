public with sharing class p2g_CreateServiceLineShipment {
    @AuraEnabled(cacheable=true)
    public static List<p2g_CreateServiceLineQuote.quoteFeeLineWrapper> getLineShip(String Id) {
        List<p2g_CreateServiceLineQuote.quoteFeeLineWrapper> quoteFeeLines = new List<p2g_CreateServiceLineQuote.quoteFeeLineWrapper>();        
        List<Shipment_Fee_Line__c> quoteFeeLineRecords = [
            SELECT Id, Name, Service_Rate_Category__c, Units__c,Sell_Amount_Number__c,
            Std_Buy_Amount_Number__c, CommentsServRate__c, Service_Rate_Name__c, Service_Rate_Name__r.Name,
            Service_Rate_Name__r.Route__r.Name,	Service_Rate_Name__r.Valid_Until__c, Service_Rate_Name__r.Account_for__r.Name,
            Service_Rate_Name__r.Carrier_Account__r.Name, Service_Rate_Name__r.Container_Type__r.Name,Service_Rate_Name__r.SAP_Service_Type__r.Name,
            Shipment__r.Total_Volume_m3__c, Shipment__r.Total_Weight_Kg__c,Shipment_Sell_Price__c,Shipment_Buy_Price__c
            FROM Shipment_Fee_Line__c WHERE Shipment__c =:Id];
        for (Shipment_Fee_Line__c feeLine : quoteFeeLineRecords) {
            p2g_CreateServiceLineQuote.quoteFeeLineWrapper wrapper = new p2g_CreateServiceLineQuote.quoteFeeLineWrapper();
            wrapper.Id = feeLine.Id;
            wrapper.Name = feeLine.Name;
            wrapper.RateCategory = feeLine.Service_Rate_Category__c;
            wrapper.RateName = feeLine.Service_Rate_Name__r.Name;
            wrapper.Route = feeLine.Service_Rate_Name__r.Route__r.Name;
            wrapper.ValidUntil = feeLine.Service_Rate_Name__r.Valid_Until__c;
            wrapper.Accountfor = feeLine.Service_Rate_Name__r.Account_for__r.Name;
            wrapper.TotalVolume = feeLine.Shipment__r.Total_Volume_m3__c;
            wrapper.TotalWeight = feeLine.Shipment__r.Total_Weight_Kg__c;
            wrapper.ContainerType = feeLine.Service_Rate_Name__r.Container_Type__r.Name;
            wrapper.Units = feeLine.Units__c;
            wrapper.SellPrice = String.valueOf(feeLine.Shipment_Sell_Price__c);
            wrapper.StdBuyPrice = String.valueOf(feeLine.Shipment_Buy_Price__c);
            wrapper.CommentsServiceLine = feeLine.CommentsServRate__c;
            wrapper.SSTS = feeLine.Service_Rate_Name__r.SAP_Service_Type__r.Name;
            wrapper.Carrier = feeLine.Service_Rate_Name__r.Carrier_Account__r.Name;
            quoteFeeLines.add(wrapper);
        }  
        //lista 1 quoteFeeLines, lista 2 feeWrapper
        return quoteFeeLines;
    }
    //Seccion 2 inicia
    @AuraEnabled(cacheable=true)
    public static List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> getLineQuote(String Id) {
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> feeWrapper = new List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper>();        
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> sinRepetidos = new List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper>();        
        List<Shipment_Fee_Line__c> shipLine = [SELECT Service_Rate_Name__c FROM Shipment_Fee_Line__c WHERE Shipment__c =:Id];
        set<String> shipRateId = new set<String>();
        For(Shipment_Fee_Line__c ship : shipLine){
            shipRateId.add(ship.Service_Rate_Name__c);
        }
        List<Import_Export_Fee_Line__c> listLine = [SELECT Id, Name, Service_Rate_Name__c,Quote_Sell_Price__c,Quote_Buy_Price__c,Extension_Service_Name__c,Import_Export_Quote__r.Total_Volume_m3_2__c,Import_Export_Quote__r.Total_Weight_Kg2__c,
                                                    Service_Rate_Name__r.Name,Service_Rate_Name__r.Account_for__c,Service_Rate_Name__r.Account_for__r.Name,Service_Rate_Name__r.Fee_Category__c,Service_Rate_Name__r.Route__r.Name,Units__c,
                                                    Service_Rate_Name__r.SAP_Service_Type__c,Service_Rate_Name__r.SAP_Service_Type__r.Name,Service_Rate_Name__r.Carrier_Account__c,Service_Rate_Name__r.Carrier_Account__r.Name,
                                                    Service_Rate_Name__r.SAP_Service_Type_Buy__c,Service_Rate_Name__r.SAP_Service_Type_Buy__r.Name,Service_Rate_Name__r.Valid_Until__c,Service_Rate_Name__r.Container_Type__r.Name,
                                                    Service_Rate_Name__r.P2G_SapDevolucion__c,Service_Rate_Name__r.CurrencyIsoCode, Import_Export_Quote__c
                                                    FROM Import_Export_Fee_Line__c WHERE Import_Export_Quote__r.Last_Shipment__c =: Id];
        for (Import_Export_Fee_Line__c line : listLine) {
            P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper = rellena2(line, Id);
            if(!shipRateId.contains(line.Service_Rate_Name__c)){
                feeWrapper.add(wrapper);
            }
        }
        System.debug('lista wrapper '+ feeWrapper);
        return feeWrapper;
    }
    
    public static P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper rellena2(Import_Export_Fee_Line__c line, String Id){
        P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper = new P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper();
            wrapper.Id = line.Id;
            wrapper.Name = line.Name;
            wrapper.FeeCategory = line.Service_Rate_Name__r.Fee_Category__c;
            wrapper.ServiceRateId = line.Service_Rate_Name__c;
            wrapper.ServiceRateName = line.Service_Rate_Name__r.Name;
            wrapper.AccountId = line.Service_Rate_Name__r.Account_for__c;
            wrapper.Account = line.Service_Rate_Name__r.Account_for__r.Name;
            wrapper.SapServiceTypeId = line.Service_Rate_Name__r.SAP_Service_Type__c;
            wrapper.SapServiceType = line.Service_Rate_Name__r.SAP_Service_Type__r.Name;
            wrapper.SellRate = String.valueOf(line.Quote_Sell_Price__c);
            wrapper.CarrierId = line.Service_Rate_Name__r.Carrier_Account__c;
            wrapper.CarrierName = line.Service_Rate_Name__r.Carrier_Account__r.Name;
            wrapper.SapServiceTypeBuyId = line.Service_Rate_Name__r.SAP_Service_Type_Buy__c;
            wrapper.SapServiceTypeBuy = line.Service_Rate_Name__r.SAP_Service_Type_Buy__r.Name;
            wrapper.BuyRate = String.valueOf(line.Quote_Buy_Price__c);
            wrapper.ValidUntil = line.Service_Rate_Name__r.Valid_Until__c;
            wrapper.Moneda = line.Service_Rate_Name__r.CurrencyIsoCode;
            wrapper.Activo = line.Service_Rate_Name__r.P2G_SapDevolucion__c;
            wrapper.ShipmentBuyPrice = line.Extension_Service_Name__c;
            wrapper.TotalVolume = String.valueOf(line.Import_Export_Quote__r.Total_Volume_m3_2__c);
            wrapper.TotalWeight = String.valueOf(line.Import_Export_Quote__r.Total_Weight_Kg2__c);
            wrapper.ShipmentRouteName = line.Service_Rate_Name__r.Route__r.Name;
            wrapper.ContainerType = line.Service_Rate_Name__r.Container_Type__r.Name;
            wrapper.ShipmentSellPrice = String.valueOf(line.Units__c);
            wrapper.seModifica = false;
            wrapper.ShipmentId = Id;
            wrapper.idQuote = line.Import_Export_Quote__c;
        return wrapper;
    }
    //Seccion 2 termina
    //Seccion 3 Inicia
    @AuraEnabled(cacheable=true)
    public static List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> getRateTarifario(String Id) {
        Customer_Quote__c ship = [SELECT Id, Account_for__c, Route__c, Last_Shipment__r.Shipment_Type__c,Last_Shipment__r.Total_Volume_m3__c, 
                                  Last_Shipment__r.Total_Weight_Kg__c FROM Customer_Quote__c WHERE Last_Shipment__c =: Id LIMIT 1];
        Date fechaHoy = Date.today();
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> feeWrapper = new List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper>();        
        List<Fee__c> feeList = [SELECT Id, Name, Route__r.Name, CustomRate__c, Container_Type__r.Name, Fee_Category__c,CurrencyIsoCode,
                                Account_for__r.Name, SAP_Service_Type__r.Name, Fee_Rate__c, Carrier_Account__r.Name,Group__c,
                                SAP_Service_Type_Buy__r.Name, Buy_Rate__c, Valid_Until__c, Active__c FROM Fee__c 
                                WHERE (Account_for__c =: ship.Account_for__c OR Account_for__r.Name =: 'Cotizador') 
                                AND Route__c =: ship.Route__c AND CustomRate__c = True AND Active__c = True 
                                AND Valid_Until__c>=:fechaHoy];
        for (Fee__c fee : feeList) {
            P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper = new P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper();
            wrapper=rellenaFee(fee, ship);
            if(fee.Account_for__r.Name != 'Cotizador'){
                feeWrapper.add(wrapper);
            }else{
                feeWrapper.add(wrapper);
            }
        }
        return feeWrapper;
    }
    public static P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper rellenaFee(Fee__c fee,Customer_Quote__c ship){
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
        wrapper.idQuote = ship.Id;
        wrapper.Moneda = fee.CurrencyIsoCode;
        wrapper.FeeCategory = fee.Fee_Category__c;
        wrapper.Grou = fee.Group__c;
        wrapper.TotalVolume = String.valueOf(ship.Last_Shipment__r.Total_Volume_m3__c);
        wrapper.TotalWeight = String.valueOf(ship.Last_Shipment__r.Total_Weight_Kg__c);
        wrapper.ShipmentId = ship.Last_Shipment__c;
        return wrapper; 
    }
    @AuraEnabled
    public static List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> CrearLineTarifario(String line, Integer numLinea){
        System.debug('Json que llego: '+ line);
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> listWrapper = P2G_UpdateShipmentServiceLine.CrearListaWrapper(line,numLinea);
        //calcular nombre de linea
        Integer NameLine = CalculoNombreLine(listWrapper[0].ShipmentId);
        List<Shipment_Fee_Line__c> listaFeeLine = new List<Shipment_Fee_Line__c>();
        List<Fee__c> creaFee = new List<Fee__c>();
        try{
            System.debug('Entra al try');
            for(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper fee: listWrapper){
                //Crear copia del service rate
                Fee__c newRate = p2g_CreateServiceLineQuote.CreateServiceRate(fee);
                creaFee.add(newRate);
            }
            Insert creaFee;
            Integer posicion = 0;
            for(Fee__c fee: creaFee){
                listWrapper[posicion].ServiceRateId = fee.Id;
                //Crear Lista Service linea
                Shipment_Fee_Line__c feeLine = CreateServiceLine(NameLine,listWrapper[posicion]);
                listaFeeLine.add(feeLine); //Guardar en lista
                posicion++;
                NameLine++;
            }
            //Crear service Line
            insert listaFeeLine;
            for(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper: listWrapper){
                wrapper.seModifica = false;
                wrapper.Tarifario = false;
                wrapper.ShipmentSellPrice = wrapper.SellRate;
	            wrapper.ShipmentBuyPrice = wrapper.BuyRate;
            }
        }catch(Exception e){
            System.debug('Entra al catch');
            System.debug('Error al realizar la modificacion: '+e.getMessage()+e.getLineNumber());
        }
        System.debug('lo que devuelve: '+listWrapper);
        return listWrapper;
    }
    //Seccion 3 Termina
    //Seccion 4 Inicia Shipment_Fee_Line__c
    @AuraEnabled(cacheable=true)
    public static List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> getCreaLine(String Id) {
        Integer NameLine = CalculoNombreLine(Id);
        Shipment_Line__c cargo = [SELECT Container_Type__c, Container_Type__r.Name, Shipment__r.Name, Shipment__r.Account_for__c, Shipment__r.Account_for__r.Name,
                                  Shipment__r.Route__c, Shipment__r.Route__r.Name,Shipment__r.CurrencyIsoCode, Shipment__r.Freight_Mode__c,Shipment__r.Shipment_Type__c,
        						  Shipment__r.Total_Volume_m3__c, Shipment__r.Total_Weight_Kg__c,Import_Export_Quote__c FROM Shipment_Line__c WHERE Shipment__c =:Id LIMIT 1];
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> listaLine = new List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper>();
    	P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper = rellena4(cargo,NameLine,Id);
        listaLine.add(wrapper);
        return listaLine;
    }
    public static P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper rellena4(Shipment_Line__c cargo,Integer NameLine,String Id){
        P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper = new P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper();
        wrapper.Name = '00'+String.valueOf(NameLine);
        wrapper.ShipmentRouteId = cargo.Shipment__r.Route__c;
        wrapper.ShipmentRouteName = cargo.Shipment__r.Route__r.Name;
        wrapper.ContainerTypeId = cargo.Container_Type__c;
        wrapper.ContainerType = cargo.Container_Type__r.Name;
        wrapper.AccountId = cargo.Shipment__r.Account_for__c;
        wrapper.Account = cargo.Shipment__r.Account_for__r.Name;
        wrapper.idQuote = cargo.Import_Export_Quote__c;
        wrapper.ShipmentName = cargo.Shipment__r.Name;
        wrapper.ShipmentId = Id;
        wrapper.Moneda = cargo.Shipment__r.CurrencyIsoCode;
        wrapper.FeeCategory = cargo.Shipment__r.Freight_Mode__c;
        wrapper.Grou = cargo.Shipment__r.Shipment_Type__c;
        wrapper.TotalVolume=String.valueOf(cargo.Shipment__r.Total_Volume_m3__c);
        wrapper.TotalWeight=String.valueOf(cargo.Shipment__r.Total_Weight_Kg__c);
        return wrapper;   
    }
    @AuraEnabled
    public static P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper Create(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper data){
        System.debug('Wrapper que llega: '+data);
        Integer NameLine = CalculoNombreLine(data.ShipmentId);
        Fee__c ServiceRate = P2G_UpdateShipmentServiceLine.CreateServiceRate(data);
        insert ServiceRate;
        data.ServiceRateId = ServiceRate.Id;
        Shipment_Fee_Line__c serviceLine = CreateServiceLine(NameLine,data);
        insert serviceLine;
        List<P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper> listaRetun = P2G_UpdateShipmentServiceLine.getLineSp(data.ShipmentId);
        return listaRetun[listaRetun.size()-1];
    }
    //Seccion 4 Termina
    public static Integer CalculoNombreLine(String ShipmentId){
        List<AggregateResult> ship = [SELECT COUNT(Id) FROM Shipment_Fee_Line__c WHERE Shipment__c =:ShipmentId];
        Integer contador = 0;
        for(AggregateResult ar: ship){
            contador += integer.valueOf(ar.get('expr0'));
        }
        contador = contador+1;
        System.debug('el resultado agregado: '+contador);
        return contador;
    }
    
    public static Shipment_Fee_Line__c CreateServiceLine(Integer name,P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper line){
        Shipment_Fee_Line__c serviceLine = new Shipment_Fee_Line__c();
        serviceLine.Import_Export_Quote__c = line.IdQuote;
        serviceLine.Shipment__c = line.ShipmentId;
        serviceLine.Name = '00'+String.valueOf(name);
        serviceLine.Units__c = 1;
        serviceLine.CurrencyIsoCode	= line.Moneda;
        serviceLine.Service_Rate_Name__c = line.ServiceRateId;
        if(line.SellRate != null){serviceLine.Shipment_Sell_Price__c = Decimal.valueOf(line.SellRate);}else{serviceLine.Shipment_Sell_Price__c = 0;}
        if(line.BuyRate != null){serviceLine.Shipment_Buy_Price__c = Decimal.valueOf(line.BuyRate);}else{serviceLine.Shipment_Buy_Price__c = 0;}
        return serviceLine;
    }
    
    public static P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper completeFieldsShowLine(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper,Shipment_Fee_Line__c line,Fee__c fee){
        Wrapper.Id = line.Id;
        Wrapper.Name = line.Name;
        Wrapper.FeeCategory = fee.Fee_Category__c;
        Wrapper.ShipmentSellPrice = String.valueOf(line.Shipment_Sell_Price__c);
        Wrapper.ShipmentBuyPrice = String.valueOf(line.Shipment_Buy_Price__c);
        wrapper.SapServiceTypeBuy = wrapper.SapServiceTypeBuy;
        wrapper.SapServiceTypeBuyId = line.Sap_Service_Type_Buy__c;
        return wrapper;
    }
    
    public static Fee__c updateRate(P2G_UpdateShipmentServiceLine.shipmentFeeLineWrapper wrapper){
        Fee__c updateFee = new Fee__c();
        updateFee.Id = wrapper.ServiceRateId;
        updateFee.P2G_SapDevolucion__c = wrapper.Activo;
        updateFee.Comments__c = wrapper.ShipmentBuyPrice;
        return updateFee;
    }
}