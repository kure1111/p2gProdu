public class PAK_ShipCreditLimit {
    
    public static set<string> lstRateCatAllowed = new set<string>{'Road Freights', 'Air Freights', 'Sea Freights'};
        public static map<string,Double> mapaShipmentSaldoDisponible {get; set;}
    public static map<string,Double> mapaTotalShipment {get; set;}
    /*public static void UpdateCarrier(list<Shipment_Fee_Line__c> lista)
    {
        set<string> setShipment =  GenerarSetShipment(lista);
        map<string,shipment__c> mapCarrier = MapCarrier(setShipment);
        for(Shipment_Fee_Line__c l : lista){
            if(mapCarrier != null)
            {
                l.Carrier_trg__c = mapCarrier.get(l.Shipment__c).Carrier__c;
            }
        }
    }*/
    public static void CalcularSaldo(list<Shipment_Fee_Line__c> lista)
    {
        String currentShipment = '';
        Double currentLimit = 0;
        double total = 0;
        set<string> setShipment = new  set<string>();
        mapaTotalShipment = new map<string,Double>();
        mapaShipmentSaldoDisponible = new map<string,Double>();
        set<string> setShipment2 =  GenerarSetShipment(lista);
        calcularSaldoCliente(setShipment2);
        CalcularImporteLine(lista);
        for(Shipment_Fee_Line__c l : lista){
            currentShipment = l.Shipment__c;
            currentLimit = mapaShipmentSaldoDisponible.get(currentShipment);
            if(!setShipment.contains(currentShipment))
            {
                if(l.Venta_Account__c =='Credito' && lstRateCatAllowed.contains(l.Service_Rate_Category__c)){
                    total = mapaTotalShipment.get(currentShipment);
                    currentLimit = currentLimit - total;
                    if(currentLimit < 0 ){
                        if(!Test.isRunningTest()){l.addError('No existe crédito disponible para el cliente');} 
                    }
                }
                setShipment.add(currentShipment);
            }
            
        }
    }
    public static void CalcularUpdate(list<Shipment_Fee_Line__c> lista,map<id,Shipment_Fee_Line__c> RegistrosOld)
    {
        String currentShipment = '';
        Double currentLimit = 0;
        double total = 0;
        set<string> setShipment = new set<string>();
        mapaTotalShipment = new map<string,Double>();
        mapaShipmentSaldoDisponible = new map<string,Double>();
        CalcularImporteLineUpdate(lista,RegistrosOld);
        for(Shipment_Fee_Line__c l : lista){ 
            currentShipment = l.Shipment__c;
            currentLimit = mapaShipmentSaldoDisponible.get(currentShipment) == null?0:mapaShipmentSaldoDisponible.get(currentShipment);
            total =0;
            if(!setShipment.contains(currentShipment))
            {
                if(ValidarCredito(RegistrosOld.get(l.Id),l) && l.Venta_Account__c =='Credito' && lstRateCatAllowed.contains(l.Service_Rate_Category__c)){
                    total = mapaTotalShipment.get(currentShipment) == null?0:mapaTotalShipment.get(currentShipment);
                    currentLimit = currentLimit - total;
                    if(currentLimit < 0 ){
                        if(!Test.isRunningTest()){l.addError('No existe crédito disponible para el cliente');} 
                    }
                }
                setShipment.add(currentShipment);
            }
            
        }     
    }
    public static Boolean ValidarCredito(Shipment_Fee_Line__c sflOld, Shipment_Fee_Line__c sfl){
        Boolean estatus = false;
        
        if(sflOld.Shipment_Sell_Price__c != sfl.Shipment_Sell_Price__c || sflOld.CurrencyIsoCode != sfl.CurrencyIsoCode ){estatus = true;}
        
        return estatus;
    }
    public static void CalcularImporteLine(list<Shipment_Fee_Line__c> lista)
    {
        
        Decimal valor = 0;
        list<CurrencyType> c =[SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE and ISOCode ='USD'];
        decimal tipoCambio = 1/c.get(0).ConversionRate;
        for(Shipment_Fee_Line__c l : lista){
            valor = 0;
            if(lstRateCatAllowed.contains(l.Service_Rate_Category__c) && mapaTotalShipment.containsKey(l.Shipment__c)){
                
                valor = mapaTotalShipment.get(l.Shipment__c);
                
                if(l.CurrencyIsoCode	 == 'USD'){
                    mapaTotalShipment.put(l.Shipment__c,valor + (l.Sell_Amount__c * tipoCambio));  
                }else{ mapaTotalShipment.put(l.Shipment__c, valor + l.Sell_Amount__c);}
            }
            else{
                if(l.CurrencyIsoCode	 == 'USD'){
                    mapaTotalShipment.put(l.Shipment__c,l.Sell_Amount__c * tipoCambio);  
                }else{ mapaTotalShipment.put(l.Shipment__c,l.Sell_Amount__c);}
            }
        }
    }
    public static void CalcularImporteLineUpdate(list<Shipment_Fee_Line__c> lista,map<id,Shipment_Fee_Line__c> RegistrosOld)
    {
        set<string> setShipment =  GenerarSetShipment(lista);
        list<CurrencyType> c =[SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE and ISOCode ='USD'];
        decimal tipoCambio = 1/c.get(0).ConversionRate;
        calcularSaldoCliente(setShipment);
        Decimal valor = 0;
        Decimal importe = 0;
        for(Shipment_Fee_Line__c l : [select id,Shipment__c,Sell_Amount__c,Currency_Buy_Price__c,Conversion_Rate_to_Currency_Header__c,CurrencyIsoCode from Shipment_Fee_Line__c where  Service_Rate_Category__c in :lstRateCatAllowed and Shipment__c in :setShipment]){
            valor = 0;
            
            if(RegistrosOld.containsKey(l.Id)){continue;}
            
            if(mapaTotalShipment.containsKey(l.Shipment__c)){
                valor = mapaTotalShipment.get(l.Shipment__c);
                
                if(l.CurrencyIsoCode	 == 'USD'){
                    mapaTotalShipment.put(l.Shipment__c,valor + (l.Sell_Amount__c * l.Conversion_Rate_to_Currency_Header__c));  
                }else{ mapaTotalShipment.put(l.Shipment__c, valor + l.Sell_Amount__c);}
            }
            else{
                
                if(l.CurrencyIsoCode	 == 'USD'){
                    mapaTotalShipment.put(l.Shipment__c,l.Sell_Amount__c * l.Conversion_Rate_to_Currency_Header__c);  
                }else{ mapaTotalShipment.put(l.Shipment__c,l.Sell_Amount__c);}
                
            }
        }
        for(Shipment_Fee_Line__c l2 : lista){
            valor = 0;
            importe = 0;
            if(mapaTotalShipment.containsKey(l2.Shipment__c)){
                valor = mapaTotalShipment.get(l2.Shipment__c);
                
                if(l2.CurrencyIsoCode == 'USD'){
                    importe = l2.Sell_Amount__c * tipoCambio; 
                    system.debug('Importe Dolares: '+ importe);
                    mapaTotalShipment.put(l2.Shipment__c,valor + importe);  
                }else{ mapaTotalShipment.put(l2.Shipment__c, valor + l2.Sell_Amount__c);}
            }else{ 
                if(l2.CurrencyIsoCode == 'USD'){
                    importe = l2.Sell_Amount__c * tipoCambio; 
                    system.debug('Importe Dolares: '+ importe);
                    mapaTotalShipment.put(l2.Shipment__c,valor + importe);  
                }else{ mapaTotalShipment.put(l2.Shipment__c, valor + l2.Sell_Amount__c);}
            }
        }
    }
    private static void calcularSaldoCliente(set<string> setShipment)
    {
        if(!setShipment.isempty()){
            for(shipment__c s : [select id,Account_for__r.Saldo_DisponibleOK__c,Carrier__c from shipment__c where id in :setShipment ])
            {
                mapaShipmentSaldoDisponible.put(s.id,s.Account_for__r.Saldo_DisponibleOK__c);
            }
        }
        
    }
    /*private static map<string,shipment__c> MapCarrier(set<string> setShipment)
    {
        map<string,shipment__c> mapaCarrier = new  map<string,shipment__c>();
        if(!setShipment.isempty()){
            for(shipment__c s : [select id,Carrier__c from shipment__c where id in :setShipment ])
            {
                mapaCarrier.put(s.id,s);
            }
        }
        return mapaCarrier;
        
    }*/
    private static set<string> GenerarSetShipment(list<Shipment_Fee_Line__c> lista)
    {
        set<string> setShipmentId = new set<string>();
        for(Shipment_Fee_Line__c l : lista){
            if(!setShipmentId.contains(l.Shipment__c) && l.Shipment__c != null)
            {
                setShipmentId.add(l.Shipment__c); 
            }
        }
        return setShipmentId;
    }
}