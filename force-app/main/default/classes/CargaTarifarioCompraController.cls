public with sharing class CargaTarifarioCompraController {
    public class csv{
        public string Id {get;set;}
        public string carrier {get;set;}
        public string compra {get;set;}
    }    
    
    @AuraEnabled
    public static string cargarTarifario(string jsn){
        try{
            System.debug('JSON from CSV: ' + jsn);
            List<csv> lines = (List<csv>)JSON.deserialize(jsn, List<csv>.class);
            Integer linesCount = lines.size();
            System.debug('No. Lines: ' + linesCount);
            if(linesCount > 0){
                Set<string> carriers = new Set<string>();  
                Map<string, Id> mapCarriers = new Map<string, Id>();
                
                for(csv l : lines){if(l.Id == null || l.Id == ''){return 'Todas las líneas deben tener el campo Id';}}
                for(csv l : lines){if(l.carrier == null || l.carrier == ''){return 'Todas las líneas deben tener un carrier';}else{if(!carriers.contains(l.carrier)){carriers.add(l.carrier);}}}
                
                
                for(Account a : [SELECT Id, Name FROM Account WHERE Name IN:carriers]){
                    if(!mapCarriers.containsKey(a.Name)){mapCarriers.put(a.Name, a.Id);}
                }
                
                List<Fee__c> serviceRates = new List<Fee__c>();
                for(csv l : lines){
                    if(!mapCarriers.containsKey(l.carrier)){return 'El carrier ' + l.carrier + ' no se encuentra en la base de datos';}
                    Fee__c rate = new Fee__c();
                    rate.Id = l.Id;
                    rate.Carrier_Account__c = mapCarriers.get(l.carrier);
                    rate.Buy_Rate__c = double.valueOf(l.compra);
                    rate.Tarifario_Compras__c = true;
                    
                    serviceRates.add(rate);
                }
                
                update serviceRates;
                return 'ok';}else{return 'No se encontraron líneas en el documento';}}catch(Exception e){System.debug('EX: ' +  e.getMessage() + ' - ' + e.getCause() + ' - ' + e.getLineNumber() + ' - ' + e.getStackTraceString()); return e.getMessage() + ' - ' + e.getCause() + ' - ' + e.getLineNumber() + ' - ' + e.getStackTraceString();}
    }
}