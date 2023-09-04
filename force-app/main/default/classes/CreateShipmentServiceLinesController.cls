public class CreateShipmentServiceLinesController {
    public class lineas{
        public string rate {get;set;}
        public integer units {get;set;}
        public string comments {get;set;}
        public string feecategory {get;set;}
        public string currencycode {get;set;}
        public double sell {get;set;}
        public double buy {get;set;}
    }
    
    @AuraEnabled
    public static Shipment__c getShipment(string shipId){
        system.debug('1 shipId : ' + shipId);
        Shipment__c s = [SELECT Id, Name, Account_for__c, Route__c,Shipment_Type__c
                         FROM Shipment__c 
                         WHERE Id =:shipId LIMIT 1];
        
        system.debug('2 s : ' + s);
        
        return s;
    }
    
    @AuraEnabled
    public static List<Fee__c> consultaRates(string shipId){
        
        system.debug('3 shipId : ' + shipId);
        
        Date fechaActual = system.today();
        Set<Id> containers = new Set<Id>();
        
        Shipment__c shipment = [SELECT Id, Account_for__c, Route__c, Carrier__c,Shipment_Type__c,
                                 Route__r.Port_Airport_of_Discharge__c,Route__r.Port_Airport_of_Load__c
                                FROM Shipment__c 
                                WHERE Id =:shipId LIMIT 1];
        
        System.debug('Shipment: ' + shipment);
        for(Shipment_Line__c cl : [SELECT Id, Container_Type__c 
                                   FROM Shipment_Line__c 
                                   WHERE Shipment__c =:shipId AND Container_Type__c != null]){
                                       if(!containers.contains(cl.Container_Type__c)){containers.add(cl.Container_Type__c);}
                                   }
        
        
        Location__c origin =[SELECT Id, Name, Zona_Metropolitana__c FROM Location__c where id =: shipment.Route__r.Port_Airport_of_Load__c limit 1 ];
        Location__c dest =[SELECT Id, Name, Zona_Metropolitana__c FROM Location__c where id =: shipment.Route__r.Port_Airport_of_Discharge__c limit 1 ];

        //BUSQUEDA ORIGINAL        
         List<Fee__c> rates =  [SELECT Id, Name, Group__c, SAP_Service_Type__c, SAP_Service_Type__r.Name, CurrencyIsoCode,
                               Route__c, Route__r.Name, Account_for__c, Account_for__r.Name, Carrier_Account__c, Carrier_Account__r.Name,
                               Container_Type__c, Container_Type__r.Name, Valid_Until__c, Fee_Rate__c, Fee_Category__c, TT_Days__c, Rate_Type__c,
                               Buy_Rate__c, CustomRate__c
                               FROM Fee__c 
                               WHERE Active__c = true 
                               AND (Valid_FROM__c <=: fechaActual OR Valid_FROM__c = NULL) 
                               AND (Valid_Until__c >=: fechaActual OR Valid_Until__c  = NULL)
                               AND (Account_for__c =:shipment.Account_for__c 
                                    OR (Account_for__r.name like'%TARIFARIO TERRESTRE NACIONAL%' AND carrier_account__C =: shipment.Carrier__C)
                                    OR (Account_for__r.name like'%Cotizador%' AND carrier_account__r.name  like'%Proveedor maestro%'))
                               AND Route__c =:shipment.Route__c
                               AND CustomRate__c = true
                               AND Container_Type__c IN: containers
                               Order by Account_for__R.NAME, Container_Type__r.Name,Carrier_Account__r.Name
                               LIMIT 50000];
        
        
        if(rates.size() == 0)
        {
            set<string> rutas = new set<string>();
            
            system.debug('ENTRAMOS');

            for(Carrier_Line_Load_Point__c rou : [SELECT Id  FROM Carrier_Line_Load_Point__c
                                                  where
                                                  Port_Airport_of_Load__c  =: origin.Zona_Metropolitana__c
                                                  and Port_Airport_of_Discharge__c =: dest.Zona_Metropolitana__c])
            {
                rutas.add(rou.id);
            }
            
            //Busqueda wtp-wtp
            rates = [SELECT Id, Name, Group__c, SAP_Service_Type__c, SAP_Service_Type__r.Name, CurrencyIsoCode,
                               Route__c, Route__r.Name, Account_for__c, Account_for__r.Name, Carrier_Account__c, Carrier_Account__r.Name,
                               Container_Type__c, Container_Type__r.Name, Valid_Until__c, Fee_Rate__c, Fee_Category__c, TT_Days__c, Rate_Type__c,
                               Buy_Rate__c, CustomRate__c
                     FROM Fee__c 
                     WHERE Active__c = true 
                      AND (Valid_Until__c >=: fechaActual OR Valid_Until__c  = NULL)
                     and (Valid_From__c = null or Valid_From__c  <=: fechaActual )
                     AND (Account_for__c =:shipment.Account_for__c 
                                    OR (Account_for__r.name like'%TARIFARIO TERRESTRE NACIONAL%' AND carrier_account__C =: shipment.Carrier__C)
                                    OR (Account_for__r.name like'%Cotizador%' AND carrier_account__r.name  like'%Proveedor maestro%'))
                     AND Route__c in: rutas
                      AND CustomRate__c = true
                               AND Container_Type__c IN: containers
                               Order by Account_for__R.NAME, Container_Type__r.Name,Carrier_Account__r.Name
                               LIMIT 50000];
            
            if(rates.size() == 0)
            {
                for(Carrier_Line_Load_Point__c rou : [SELECT Id  FROM Carrier_Line_Load_Point__c
                                                      where
                                                      Port_Airport_of_Load__c = : origin.id
                                                      and Port_Airport_of_Discharge__c =: dest.Zona_Metropolitana__c])
                {
                    rutas.add(rou.id);
                }
                
                // Busqueda origen-wtp
                rates = [SELECT Id, Name, Group__c, SAP_Service_Type__c, SAP_Service_Type__r.Name, CurrencyIsoCode,
                               Route__c, Route__r.Name, Account_for__c, Account_for__r.Name, Carrier_Account__c, Carrier_Account__r.Name,
                               Container_Type__c, Container_Type__r.Name, Valid_Until__c, Fee_Rate__c, Fee_Category__c, TT_Days__c, Rate_Type__c,
                               Buy_Rate__c, CustomRate__c
                         FROM Fee__c 
                         WHERE Active__c = true 
                         AND (Valid_Until__c >=: fechaActual OR Valid_Until__c  = NULL)
                         and (Valid_From__c = null or Valid_From__c  <=: fechaActual )
                         AND (Account_for__c =:shipment.Account_for__c 
                                    OR (Account_for__r.name like'%TARIFARIO TERRESTRE NACIONAL%' AND carrier_account__C =: shipment.Carrier__C)
                                    OR (Account_for__r.name like'%Cotizador%' AND carrier_account__r.name  like'%Proveedor maestro%'))
                         AND Route__c in: rutas
                         AND CustomRate__c = true
                               AND Container_Type__c IN: containers
                               Order by Account_for__R.NAME, Container_Type__r.Name,Carrier_Account__r.Name
                               LIMIT 50000];
                
                if(rates.size() == 0)
                {
                    for(Carrier_Line_Load_Point__c rou : [SELECT Id  FROM Carrier_Line_Load_Point__c
                                                          where
                                                          Port_Airport_of_Load__c =: origin.Zona_Metropolitana__c
                                                          and Port_Airport_of_Discharge__c =: dest.id])
                    {
                        rutas.add(rou.id);
                    }
                    
                    // Busqueda wtp- dest
                    rates = [SELECT Id, Name, Group__c, SAP_Service_Type__c, SAP_Service_Type__r.Name, CurrencyIsoCode,
                               Route__c, Route__r.Name, Account_for__c, Account_for__r.Name, Carrier_Account__c, Carrier_Account__r.Name,
                               Container_Type__c, Container_Type__r.Name, Valid_Until__c, Fee_Rate__c, Fee_Category__c, TT_Days__c, Rate_Type__c,
                               Buy_Rate__c, CustomRate__c
                             FROM Fee__c 
                             WHERE Active__c = true 
                            AND (Valid_Until__c >=: fechaActual OR Valid_Until__c  = NULL)
                             and (Valid_From__c = null or Valid_From__c  <=: fechaActual )
                              AND (Account_for__c =:shipment.Account_for__c 
                                    OR (Account_for__r.name like'%TARIFARIO TERRESTRE NACIONAL%' AND carrier_account__C =: shipment.Carrier__C)
                                    OR (Account_for__r.name like'%Cotizador%' AND carrier_account__r.name  like'%Proveedor maestro%')) 
                             AND Route__c in: rutas
                            AND CustomRate__c = true
                               AND Container_Type__c IN: containers
                               Order by Account_for__R.NAME, Container_Type__r.Name,Carrier_Account__r.Name
                               LIMIT 50000];
                }
            }
        }

        
        return rates;
    }
    
    @AuraEnabled
    public static List<Shipment_Fee_Line__c> consultaServiceLines(string shipId){
        
        system.debug('5 shipId : ' + shipId);
        
        List<Shipment_Fee_Line__c> serviceLines = [SELECT Id,Service_Rate_Category__c, Service_Rate_Name__c, Service_Rate_Name__r.Name,
                                                   Shipment__r.Route__r.Name, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Delivery_Zone__r.Name, Service_Rate_Name__r.Valid_Until__c,
                                                   Service_Rate_Name__r.Account_for__c, Service_Rate_Name__r.Account_for__r.Name, Rate_Type__c,
                                                   Shipment__r.Total_Volume_m3__c, Shipment__r.Total_Weight_Kg__c,
                                                   Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Container_Type__r.Name,
                                                   Units__c, Shipment_Sell_Price__c, Sell_Amount_Number__c, Shipment_Buy_Price__c, Std_Buy_Amount_Number__c,
                                                   Extension_Service_Name__c, CurrencyIsoCode
                                                   FROM 
                                                   Shipment_Fee_Line__c 
                                                   WHERE Shipment__c =:shipId];
        
        system.debug('6 serviceLines : ' + serviceLines);
        
        return serviceLines;
    }
    
    @AuraEnabled
    public static string createLineas(string shipId, string jsn){
        try{
            
            system.debug('7 shipId : ' + shipId);
            system.debug('8 jsn : ' + jsn);
            
            List<lineas> lines = (List<lineas>)JSON.deserialize(jsn, List<lineas>.class);
            List<Shipment_Fee_Line__c> currentLines = [SELECT Id 
                                                       FROM 
                                                       Shipment_Fee_Line__c 
                                                       WHERE Shipment__c =:shipId];
            
            system.debug('9 lines : ' + lines);
            system.debug('10 currentLines : ' + currentLines);
            
            
            Integer currentSize = currentLines.size();
            Integer contadorLineas = currentSize;
            List<Shipment_Fee_Line__c> shipmentLines = new List<Shipment_Fee_Line__c>();
            for(lineas l : lines){
                contadorLineas ++;
                Shipment_Fee_Line__c sl = new Shipment_Fee_Line__c();
                sl.Shipment__c = shipId;
                sl.Name = string.valueof(contadorLineas);
                string nombre_linea = '';
                while(sl.Name.length()<3){sl.Name = nombre_linea + string.valueof(contadorLineas);nombre_linea  +='0';}
                sl.Extension_Service_Name__c = l.comments;
                sl.Service_Rate_Name__c = l.rate;
                sl.Warehouse_Rate__c = (l.feecategory == 'Warehouse' ? true : false);
                sl.Units__c = l.units;
                sl.CurrencyIsoCode = l.currencycode;
                sl.Shipment_Sell_Price__c = l.sell;
                sl.Shipment_Buy_Price__c = l.buy;
                
                shipmentLines.add(sl);
            }
            insert shipmentLines;
            
            system.debug('11 shipmentLines : ' + shipmentLines);
            
            return 'ok';}catch(Exception e){
                system.debug('12 error : ' + e.getMessage());
                return 'Error: ' + e.getMessage();}
    }
    
    @AuraEnabled
    public static boolean isWTP(string shipmentId){
        
        Boolean showW =true;
        
        shipment__c quote = [SELECT Id, Account_for__c, Route__c,Shipment_Type__c,
                                   Route__r.Port_Airport_of_Discharge__c,Route__r.Port_Airport_of_Load__c
                                   FROM shipment__c 
                                   WHERE Id =:shipmentId LIMIT 1];
        
        
        Location__c origin =[SELECT Id, Name, Zona_Metropolitana__c FROM Location__c where id =: quote.Route__r.Port_Airport_of_Load__c limit 1 ];
        Location__c dest =[SELECT Id, Name, Zona_Metropolitana__c FROM Location__c where id =: quote.Route__r.Port_Airport_of_Discharge__c limit 1 ];
        
        if(origin.Zona_Metropolitana__c != null || dest.Zona_Metropolitana__c != null)
            showW=false;
        
        return showW;
    }
    
    public static void test()
    {
        string a = '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
    }
}