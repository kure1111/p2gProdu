public with sharing class CargaTarifarioVentaController {
    public class csv{
        public string Route {get;set;}
        public string RateName {get;set;}
        public string ValidFrom {get;set;}
        public string ValidUntil {get;set;}
        public string AccountFor {get;set;}
        public string CustomerID {get;set;}
        public string TTDays {get;set;}
        public string SellRate {get;set;}
        public string ContainerType {get;set;}
        public string Grupo {get;set;}
        public string SAPST {get;set;}
        public string Comments {get;set;}
        public string Moneda {get;set;}
    }   
    
    private class accountBase
    {
        public string customerId {get;set;}
        public string accountName {get;set;}
    }
    
    @AuraEnabled
    public static string cargarTarifario(string jsn){
        string ratetype = 'Fixed';
        string moneda = 'MXN';
        boolean tarif = true;
        string negociacion = 'Si';
        string rtId = Schema.SObjectType.Fee__c.getRecordTypeInfosByName().get('Sea/Ground Freight').getRecordTypeId();
        string ratecategory = 'Road Freights';
        boolean activo = true;
        // Requeridos: Ruta, rate name, rate category, account for, tt days, rate type, container type, sell rate
        try{
            System.debug('JSON from CSV: ' + jsn);
            List<csv> lines = (List<csv>)JSON.deserialize(jsn, List<csv>.class);
            Integer linesCount = lines.size();
            System.debug('No. Lines: ' + linesCount);
            if(linesCount > 0){
                Set<string> rutas = new Set<string>();
                Set<string> cuentas = new set<string>();//Set<accountBase>();
                Set<string> contenedores = new Set<string>();
                Set<string> sst = new Set<string>();                
                Map<string, Id> mapRutas = new Map<string, Id>();
                Map<string, Id> mapCuentas = new Map<string, Id>();
                Map<string, Id> mapContenedores = new Map<string, Id>();
                Map<string, Id> mapSst = new Map<string, Id>();
                
               
                for(csv l : lines)
                {
                    system.debug('linea l ' + l);
                    //CUENTAS
                    if(l.AccountFor == null || l.AccountFor == '')
                    {
                        return 'Todas las líneas deben tener un cliente';
                    }
                    if(l.CustomerID == null || l.CustomerID == '')
                    {
                        return 'Todas las líneas deben tener un customer ID';
                    }
                    if( l.AccountFor != null && l.AccountFor != '' && l.CustomerID != null && l.CustomerID != '')
                    {
                       // accountBase account = new accountBase();
                        //account.customerId = l.CustomerID;
                        //account.accountName = l.AccountFor;
                        cuentas.add( l.CustomerID );
                    }
                    
                    //RUTAS
                    if(l.Route == null || l.Route == ''){return 'Todas las líneas deben tener una ruta';}
                    else{if(!rutas.contains(l.Route)){rutas.add(l.Route.toLowercase());}}
                   
                    //CONTENEDORES
                    if(l.ContainerType == null || l.ContainerType == ''){return 'Todas las líneas deben tener un contenedor';}
                    else{if(!contenedores.contains(l.ContainerType)){contenedores.add(l.ContainerType);}}
                    
                    //SAP
                    if(l.SAPST == null || l.SAPST == ''){return 'Todas las líneas deben tener SAPST';}
                    else{if(!sst.contains(l.SAPST)){sst.add(l.SAPST);}}
                    
                    //
                    if(l.RateName == null || l.RateName == '')
                    {return 'Todas las líneas deben tener un nombre para la tarifa';}
                    else if(l.TTDays == null || l.TTDays == ''){return 'Todas las líneas deben tener TTDays';}
                    else if(l.SellRate == null || l.SellRate == ''){return 'Todas las líneas deben tener precio de venta';}
                    else if(l.Grupo == null || l.Grupo == ''){return 'Todas las líneas deben tener grupo';}
                }

                for(Carrier_Line_Load_Point__c ruta : [SELECT Id, Name FROM Carrier_Line_Load_Point__c WHERE Name IN:rutas]){
                    if(!mapRutas.containsKey(ruta.Name.toLowercase())){mapRutas.put(ruta.Name.toLowercase(), ruta.Id);}
                }
                
                system.debug('cuentas ' +  cuentas);
                
               // for (accountBase account : cuentas){
               	 for(Account a : [SELECT Id, Name,Customer_Id__c FROM Account WHERE  Customer_Id__c in: cuentas]){
                    if(!mapCuentas.containsKey(a.Customer_Id__c)){mapCuentas.put(a.Customer_Id__c, a.Id);}
               	 //}
                }
                for(Container_Type__c ct : [SELECT Id, Name FROM Container_Type__c WHERE Name IN:contenedores]){
                    if(!mapContenedores.containsKey(ct.Name)){mapContenedores.put(ct.Name, ct.Id);} 
                }
                for(SAP_Service_Type__c sapst : [SELECT Id, Name FROM SAP_Service_Type__c WHERE Name IN:sst]){
                    if(!mapSst.containsKey(sapst.Name)){mapSst.put(sapst.Name, sapst.Id);} 
                }
                
                system.debug('mapCuentas ' + mapCuentas);
                
                List<Fee__c> serviceRates = new List<Fee__c>();
                for(csv l : lines){
                    if(!mapRutas.containsKey(l.Route.toLowercase())){return 'La ruta ' + l.Route + ' no se encuentra en la base de datos';}
                    if(!mapCuentas.containsKey(l.customerID)){return 'El cliente ' + l.AccountFor + ' no se encuentra en la base de datos';}
                    if(!mapContenedores.containsKey(l.ContainerType)){return 'El contenedor ' + l.ContainerType + ' no se encuentra en la base de datos';}
                    if(!mapSst.containsKey(l.SAPST)){return 'El SAPST ' + l.SAPST + ' no se encuentra en la base de datos';}
                    Fee__c rate = new Fee__c();
                    rate.Route__c = mapRutas.get(l.Route.toLowercase());
                    rate.Name = l.RateName;
                    if(l.ValidFrom != null && l.ValidFrom != ''){rate.Valid_From__c = date.parse(l.ValidFrom);}
                    if(l.ValidUntil != null && l.ValidUntil != ''){rate.Valid_Until__c = date.parse(l.ValidUntil);}
                    rate.Account_for__c = mapCuentas.get(l.customerID);
                    rate.TT_Days__c = l.TTDays;
                    rate.Container_Type__c = mapContenedores.get(l.ContainerType);
                    rate.Fee_Rate__c = double.valueOf(l.SellRate);
                    rate.Group__c = l.Grupo;
                    rate.CurrencyIsoCode = l.Moneda;
                    rate.SAP_Service_Type__c = mapSst.get(l.SAPST);
                    if(l.Comments != null && l.Comments != ''){rate.Comments__c = l.Comments;}
                    // Valores del custom setting
                    rate.Rate_Type__c = ratetype;
                    // rate.CurrencyIsoCode = moneda;
                    rate.CustomRate__c = tarif;
                    rate.Negociacion__c = negociacion;
                    // rate.Moneda__c = moneda;
                    rate.RecordTypeId = rtId;
                    rate.Fee_Category__c = ratecategory;
                    rate.Active__c = activo;
                    
                    serviceRates.add(rate);
                }
                
                insert serviceRates;
                return 'ok';}else{return 'No se encontraron líneas en el documento';}}catch(Exception e){System.debug('EX: ' +  e.getMessage() + ' - ' + e.getCause() + ' - ' + e.getLineNumber() + ' - ' + e.getStackTraceString()); return e.getMessage() + ' - ' + e.getCause() + ' - ' + e.getLineNumber() + ' - ' + e.getStackTraceString();}
    }
}