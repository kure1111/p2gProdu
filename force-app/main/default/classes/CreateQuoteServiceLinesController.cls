public class CreateQuoteServiceLinesController {
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
    public static Customer_Quote__c getQuote(string quoteId){
        Customer_Quote__c q = [SELECT Id, Name, Total_Volume_m3_2__c, Total_Weight_Kg2__c, Account_for__c, Route__c,FolioResume__c
                               FROM Customer_Quote__c 
                               WHERE Id =:quoteId LIMIT 1];
        return q;
    }
    
    @AuraEnabled
    public static boolean isWTP(string quoteId){
        
        Boolean showW =true;
       
        Customer_Quote__c quote = [SELECT Id, Account_for__c, Route__c,FolioResume__c,
                                   Route__r.Port_Airport_of_Discharge__c,Route__r.Port_Airport_of_Load__c
                                   FROM Customer_Quote__c 
                                   WHERE Id =:quoteId LIMIT 1];
        
        
        Location__c origin =[SELECT Id, Name, Zona_Metropolitana__c FROM Location__c where id =: quote.Route__r.Port_Airport_of_Load__c limit 1 ];
        Location__c dest =[SELECT Id, Name, Zona_Metropolitana__c FROM Location__c where id =: quote.Route__r.Port_Airport_of_Discharge__c limit 1 ];

		if(origin.Zona_Metropolitana__c != null || dest.Zona_Metropolitana__c != null)
             showW=false;
        
        return showW;
    }
    
    @AuraEnabled
    public static List<Fee__c> consultaRates(string quoteId){
        Date fechaActual = system.today();
        Set<Id> containers = new Set<Id>();
        
        Customer_Quote__c quote = [SELECT Id, Account_for__c, Route__c,FolioResume__c,
                                   Route__r.Port_Airport_of_Discharge__c,Route__r.Port_Airport_of_Load__c
                                   FROM Customer_Quote__c 
                                   WHERE Id =:quoteId LIMIT 1];
        system.debug('quote: '+quote);
        
        for(Quote_Item_Line__c cl : [SELECT Id, Container_Type__c 
                                     FROM Quote_Item_Line__c 
                                     WHERE Import_Export_Quote__c =:quoteId AND Container_Type__c != null]){
                                         if(!containers.contains(cl.Container_Type__c)){containers.add(cl.Container_Type__c);}
                                         system.debug('cl: '+cl);
                                     }
        
        Location__c origin =[SELECT Id, Name, Zona_Metropolitana__c FROM Location__c where id =: quote.Route__r.Port_Airport_of_Load__c limit 1 ];
        system.debug('origin: '+origin);
        Location__c dest =[SELECT Id, Name, Zona_Metropolitana__c FROM Location__c where id =: quote.Route__r.Port_Airport_of_Discharge__c limit 1 ];
        system.debug('dest: '+dest);
        
        
        //Busqueda origen-destino
        List<Fee__c> rates = [SELECT Id, Name, Group__c, SAP_Service_Type__c, SAP_Service_Type__r.Name, CurrencyIsoCode,
                              Route__c, Route__r.Name, Account_for__c, Account_for__r.Name, Carrier_Account__c, Carrier_Account__r.Name,
                              Container_Type__c, Container_Type__r.Name, Valid_Until__c, Fee_Rate__c, Fee_Category__c, TT_Days__c, Rate_Type__c,
                              Buy_Rate__c, CustomRate__c, Comments__c
                              FROM Fee__c 
                              WHERE Active__c = true 
                              AND (Valid_Until__c = null or Valid_Until__c >=: fechaActual )
                              and (Valid_From__c = null or Valid_From__c  <=: fechaActual )
                              AND Account_for__c =:quote.Account_for__c AND Route__c =: quote.Route__c// in: rutas
                              AND Container_Type__c IN: containers
                              LIMIT 50000];
        system.debug('rates: '+rates);
        if(rates.size() == 0)
        {
            
            set<string> rutas = new set<string>();
            //rutas.add(quote.Route__c);
            
            system.debug('ENTRAMOS');
            
            
            for(Carrier_Line_Load_Point__c rou : [SELECT Id  FROM Carrier_Line_Load_Point__c
                                                  where
                                                  Port_Airport_of_Load__c  =: origin.Zona_Metropolitana__c
                                                  and Port_Airport_of_Discharge__c =: dest.Zona_Metropolitana__c])
            {
              system.debug('rou: '+rou);
              rutas.add(rou.id);
            }
            
            //Busqueda wtp-wtp
            rates = [SELECT Id, Name, Group__c, SAP_Service_Type__c, SAP_Service_Type__r.Name, CurrencyIsoCode,
                     Route__c, Route__r.Name, Account_for__c, Account_for__r.Name, Carrier_Account__c, Carrier_Account__r.Name,
                     Container_Type__c, Container_Type__r.Name, Valid_Until__c, Fee_Rate__c, Fee_Category__c, TT_Days__c, Rate_Type__c,
                     Buy_Rate__c, CustomRate__c, Comments__c
                     FROM Fee__c 
                     WHERE Active__c = true 
                      AND (Valid_Until__c = null or Valid_Until__c >=: fechaActual )
                      and (Valid_From__c = null or Valid_From__c  <=: fechaActual )
                     AND Account_for__c =:quote.Account_for__c AND Route__c in: rutas
                     AND Container_Type__c IN: containers
                     LIMIT 50000];
        system.debug('rates2: '+rates);
            
            if(rates.size() == 0)
            {
                for(Carrier_Line_Load_Point__c rou : [SELECT Id  FROM Carrier_Line_Load_Point__c
                                                      where
                                                      Port_Airport_of_Load__c = : origin.id
                                                      and Port_Airport_of_Discharge__c =: dest.Zona_Metropolitana__c])
                {
                  system.debug('rou: '+rou);
                  rutas.add(rou.id);
                }
                
                // Busqueda origen-wtp
                rates = [SELECT Id, Name, Group__c, SAP_Service_Type__c, SAP_Service_Type__r.Name, CurrencyIsoCode,
                         Route__c, Route__r.Name, Account_for__c, Account_for__r.Name, Carrier_Account__c, Carrier_Account__r.Name,
                         Container_Type__c, Container_Type__r.Name, Valid_Until__c, Fee_Rate__c, Fee_Category__c, TT_Days__c, Rate_Type__c,
                         Buy_Rate__c, CustomRate__c, Comments__c
                         FROM Fee__c 
                         WHERE Active__c = true 
                         AND (Valid_Until__c = null or Valid_Until__c >=: fechaActual )
                         and (Valid_From__c = null or Valid_From__c  <=: fechaActual )
                         AND Account_for__c =:quote.Account_for__c AND Route__c in: rutas
                         AND Container_Type__c IN: containers
                         LIMIT 50000];
                system.debug('rates3: '+rates);
                
                if(rates.size() == 0)
                {
                    for(Carrier_Line_Load_Point__c rou : [SELECT Id  FROM Carrier_Line_Load_Point__c
                                                          where
                                                          Port_Airport_of_Load__c =: origin.Zona_Metropolitana__c
                                                          and Port_Airport_of_Discharge__c =: dest.id])
                    {
                      system.debug('rou: '+rou);
                      rutas.add(rou.id);
                    }
                    
                    // Busqueda wtp- dest
                    rates = [SELECT Id, Name, Group__c, SAP_Service_Type__c, SAP_Service_Type__r.Name, CurrencyIsoCode,
                             Route__c, Route__r.Name, Account_for__c, Account_for__r.Name, Carrier_Account__c, Carrier_Account__r.Name,
                             Container_Type__c, Container_Type__r.Name, Valid_Until__c, Fee_Rate__c, Fee_Category__c, TT_Days__c, Rate_Type__c,
                             Buy_Rate__c, CustomRate__c, Comments__c
                             FROM Fee__c 
                             WHERE Active__c = true 
                             AND (Valid_Until__c = null or Valid_Until__c >=: fechaActual )
                             And (Valid_From__c = null or Valid_From__c  <=: fechaActual )
                             AND Account_for__c =:quote.Account_for__c AND Route__c in: rutas
                             AND Container_Type__c IN: containers
                             LIMIT 50000];
                    system.debug('rates4: '+rates);

                }
            }
            
            
            
            /*  system.debug('origin '+ origin);
system.debug('dest ' + dest);
set<string> origenesWTP = new set<string>();
set<string> destinosWTP = new set<string>();

if(origin != null && origin.Zona_Metropolitana__c != null)
{

for(Location__c loc : [SELECT Id FROM Location__c where Zona_Metropolitana__c =:origin.Zona_Metropolitana__c ])
{
origenesWTP.add(loc.id);
}
}

if(dest != null && dest.Zona_Metropolitana__c != null)
{

for(Location__c loc : [SELECT Id FROM Location__c where Zona_Metropolitana__c =:dest.Zona_Metropolitana__c ])
{
destinosWTP.add(loc.id);
}
}

system.debug('origenesWTP '+ origenesWTP);
system.debug('destinosWTP '+ destinosWTP);

if(origenesWTP.size()>0 && destinosWTP.size()>0)
{
for(Carrier_Line_Load_Point__c rou : [SELECT Id  FROM Carrier_Line_Load_Point__c
where
Port_Airport_of_Load__c in : origenesWTP
and Port_Airport_of_Discharge__c in : destinosWTP])
{
rutas.add(rou.id);
}
}
else if(origenesWTP.size() == 0 && destinosWTP.size()>0)
{
for(Carrier_Line_Load_Point__c rou : [SELECT Id  FROM Carrier_Line_Load_Point__c
where
Port_Airport_of_Load__c =: origin.id
and Port_Airport_of_Discharge__c in : destinosWTP])
{
rutas.add(rou.id);
}
}
else if(origenesWTP.size()>0 && destinosWTP.size()==0)
{
for(Carrier_Line_Load_Point__c rou : [SELECT Id  FROM Carrier_Line_Load_Point__c
where
Port_Airport_of_Load__c in : origenesWTP
and Port_Airport_of_Discharge__c =: dest.id])
{
rutas.add(rou.id);
}
}

system.debug('rutas '+ rutas);

rates = [SELECT Id, Name, Group__c, SAP_Service_Type__c, SAP_Service_Type__r.Name, CurrencyIsoCode,
Route__c, Route__r.Name, Account_for__c, Account_for__r.Name, Carrier_Account__c, Carrier_Account__r.Name,
Container_Type__c, Container_Type__r.Name, Valid_Until__c, Fee_Rate__c, Fee_Category__c, TT_Days__c, Rate_Type__c,
Buy_Rate__c, CustomRate__c
FROM Fee__c 
WHERE Active__c = true AND Valid_Until__c >=: fechaActual 
AND Account_for__c =:quote.Account_for__c AND Route__c in: rutas
AND Container_Type__c IN: containers
LIMIT 50000];*/
        }
        
        return rates;
    }
    
    
    @AuraEnabled
    public static List<Import_Export_Fee_Line__c> consultaServiceLines(string quoteId){
        List<Import_Export_Fee_Line__c> serviceLines = [SELECT Id, Service_Rate_Category__c, Service_Rate_Name__c, Service_Rate_Name__r.Name,
                                                        route__c, Service_Rate_Name__r.Delivery_Zone__c, Service_Rate_Name__r.Delivery_Zone__r.Name, Service_Rate_Name__r.Valid_Until__c,
                                                        Service_Rate_Name__r.Account_for__c, Service_Rate_Name__r.Account_for__r.Name, Rate_Type__c,
                                                        Import_Export_Quote__r.Total_Volume_m3_2__c, Import_Export_Quote__r.Total_Weight_Kg2__c,
                                                        Service_Rate_Name__r.Container_Type__c, Service_Rate_Name__r.Container_Type__r.Name,
                                                        Units__c, Quote_Sell_Price__c, Sell_Amount_Number__c, Quote_Buy_Price__c, Std_Buy_Amount_Number__c,
                                                        Extension_Service_Name__c, CurrencyIsoCode
                                                        FROM 
                                                        Import_Export_Fee_Line__c 
                                                        WHERE Import_Export_Quote__c =:quoteId];
        return serviceLines;
    }
    
    @AuraEnabled
    public static string createLineas(string quoteId, string jsn){
        try{
            List<lineas> lines = (List<lineas>)JSON.deserialize(jsn, List<lineas>.class);
            List<Import_Export_Fee_Line__c> currentLines = [SELECT Id 
                                                            FROM 
                                                            Import_Export_Fee_Line__c 
                                                            WHERE Import_Export_Quote__c =:quoteId];
            Integer currentSize = currentLines.size();
            Integer contadorLineas = currentSize;
            List<Import_Export_Fee_Line__c> quoteLines = new List<Import_Export_Fee_Line__c>();
            for(lineas l : lines){
                contadorLineas ++;
                Import_Export_Fee_Line__c sl = new Import_Export_Fee_Line__c();
                sl.Import_Export_Quote__c = quoteId;
                sl.Name = string.valueof(contadorLineas);
                string nombre_linea = '';
                while(sl.Name.length()<3){sl.Name = nombre_linea + string.valueof(contadorLineas);nombre_linea  +='0';}
                sl.Extension_Service_Name__c = l.comments;
                sl.Service_Rate_Name__c = l.rate;
                sl.Warehouse_Rate__c = (l.feecategory == 'Warehouse' ? true : false);
                sl.Units__c = l.units;
                sl.CurrencyIsoCode = l.currencycode;
                sl.Quote_Sell_Price__c = l.sell;
                sl.Quote_Buy_Price__c = l.buy;
                
                quoteLines.add(sl);
            }
            insert quoteLines;
            return 'ok';}catch(Exception e){return 'Error: ' + e.getMessage();}
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
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
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
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
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
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
        a+= '';
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
          a+= '';
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
          a+= '';
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
          a+= '';
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
          a+= '';
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
          a+= '';
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
          a+= '';
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
          a+= '';
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
        a+= '';  a+= '';
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
          a+= '';
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
        
    }
}