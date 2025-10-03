global class P2G_Scheduled_UPD_Currency implements Database.Batchable<SObject>, Database.Stateful, Schedulable  {

    global Set<Id> processedSPLIds = new Set<Id>();
    global Integer totalRecordsProcessed=0;
    global Integer totalRecordsUpdated=0;
    global Decimal tasaCambio=0;
    public static Boolean isUAT=false;
    
    
    global static Boolean isUAT() {
        isUAT=[SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        return isUAT;
    }

    
    global void execute(SchedulableContext sc) {        
        Database.executeBatch(new P2G_Scheduled_UPD_Currency(), 15);
    }
    

    // Map para la tasa de cambio vieja y nueva
    global Map<Id, Map<String, Decimal>> conversionChanges = new Map<Id, Map<String, Decimal>>();

    global Database.QueryLocator start(Database.BatchableContext bc) {  
        String query='';
		isUAT();
        if(!isUAT){
        	query ='SELECT Id, CurrencyIsoCode, Shipment__c, Conversion_Rate_to_Currency_Header__c ' +
            'FROM Shipment_Fee_Line__c ' +
            'WHERE Shipment__c NOT IN (SELECT Shipment__c FROM Response__c ' +
                                        'WHERE Shipment__c != null ' +
                                        'AND Message__c LIKE \'Solicitud de Compra creada%\' ' +
                                        'AND Type__c = \'CONFIRM\') ' +
            'AND Shipment__r.CreatedDate >= LAST_N_MONTHS:6 ' +
            'AND Shipment__r.Shipment_Status_Plann__c NOT IN (\'Closed\', \'Cancel\') ' +
            'AND Shipment__r.CurrencyIsoCode=\'MXN\''+
            'AND CurrencyIsoCode = \'USD\'';
            
        }else{
            query='SELECT Id, CurrencyIsoCode, Shipment__c, Conversion_Rate_to_Currency_Header__c ' +
            'FROM Shipment_Fee_Line__c ' +
            'WHERE Shipment__c NOT IN (SELECT Shipment__c FROM Response__c ' +
                                        'WHERE Shipment__c != null ' +
                                        'AND Message__c LIKE \'Solicitud de Compra creada%\' ' +
                                        'AND Type__c = \'CONFIRM\') ' +
            //'AND Shipment__r.CreatedDate >= LAST_N_MONTHS:6 ' +
            'AND Shipment__r.Shipment_Status_Plann__c NOT IN (\'Closed\', \'Cancel\') ' +
            'AND Shipment__r.CurrencyIsoCode=\'MXN\''+
            'AND CurrencyIsoCode = \'USD\'';
        }        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Shipment_Fee_Line__c> scope) {
        List<Shipment_Fee_Line__c> listUpdateSPL = new List<Shipment_Fee_Line__c>();

        NEU_CurrencyUtils currencyUtils = new NEU_CurrencyUtils();    
        
        String corporateCurrency = 'MXN'; // Por defecto es MXN
        Date today = Date.today();

        Decimal rate = currencyUtils.getConversionRate('USD', corporateCurrency, today);
        
        tasaCambio=rate.setScale(4);     

        for (Shipment_Fee_Line__c line : scope) {
            totalRecordsProcessed++;

            if (line.Shipment__c != null) {
                processedSPLIds.add(line.Id);
            }
            
            if (line.Conversion_Rate_to_Currency_Header__c != rate) {
                // valores antiguo y nuevo en el mapa
                conversionChanges.put(line.Id, new Map<String, Decimal>{
                    'oldValue' => line.Conversion_Rate_to_Currency_Header__c,
                    'newValue' => tasaCambio
                });

                line.Conversion_Rate_to_Currency_Header__c = tasaCambio;
                listUpdateSPL.add(line);
                totalRecordsUpdated++;
            }
        }

        if (!listUpdateSPL.isEmpty()) { 
            NEU_StaticVariableHelper.setBoolean1(true);           
            update listUpdateSPL;     
            NEU_StaticVariableHelper.setBoolean1(false);       
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Batch terminado: actualización de Currency en líneas de Shipment');
        System.debug('tasa de cambio al día de hoy ' + tasaCambio);
        System.debug('Total de líneas procesadas: ' + totalRecordsProcessed);
        System.debug('Total de líneas actualizadas: ' + totalRecordsUpdated);
        System.debug('Total de Shipments únicos procesados: ' + processedSPLIds.size());
        System.debug('Ids de Shipments: ' + processedSPLIds);

        
        for (Id lineId : conversionChanges.keySet()) {
            Map<String, Decimal> values = conversionChanges.get(lineId);
            System.debug('SPL ' + lineId + ' | oldValue=' + values.get('oldValue') + ' | newValue=' + values.get('newValue'));
        }
    }
}