public class P2G_ImpExpSerLinCurrency_Handler {    
    //Actualizamos el campo CurrencyIsoCode del objetoa Service Rate
    public static void updateCurrencyIsoCodeImpExpSerLin(List<Import_Export_Fee_Line__c> newRecords, Map<Id, Import_Export_Fee_Line__c> oldMap){
        List<Fee__c> serviceRateList = new List<Fee__c>();
        for (Import_Export_Fee_Line__c impExpServiceLine : newRecords) {
        	Import_Export_Fee_Line__c oldRecord = oldMap.get(impExpServiceLine.Id);            
            if(oldRecord!=null && impExpServiceLine.CurrencyIsoCode!=oldRecord.CurrencyIsoCode){
            	if (impExpServiceLine.Service_Rate_Name__c != null && impExpServiceLine.Service_Rate_Name__r.CustomRate__c==false) {
                    serviceRateList.add(new Fee__c(
                            Id = impExpServiceLine.Service_Rate_Name__c,
                            CurrencyIsoCode = impExpServiceLine.CurrencyIsoCode
                    ));
                }
            }
        }
		
        if(!serviceRateList.isEmpty()){
            updateCurrencyIsoCodeByServiceRate(serviceRateList);
            update serviceRateList;
        }
        
    }
    
    //Actualizamos el campo CurrencyIsoCode del objeto Shipment Service Line
    public static void updateCurrencyIsoCodeByServiceRate(List<Fee__c> serviceRateList){
        Map<Id,String> mapServiceRate= new Map<Id,String>();
        SET<String> servRateIds = new SET<String>();
        for(Fee__c servRate: serviceRateList){
            mapServiceRate.put(servRate.Id,servRate.CurrencyIsoCode);
            servRateIds.add(servRate.Id);
        }
        
        List<Shipment_Fee_Line__c> spSLList=
            [SELECT Id, CurrencyIsoCode, Service_Rate_Name__c FROM Shipment_Fee_Line__c
            WHERE Service_Rate_Name__c in : servRateIds];
        
        for(Shipment_Fee_Line__c sp: spSLList){
            if(sp.CurrencyIsoCode!=mapServiceRate.get(sp.Service_Rate_Name__c)){
				sp.CurrencyIsoCode=mapServiceRate.get(sp.Service_Rate_Name__c);
            }
        }
        
        if(!spSLList.isEmpty()){
            update spSLList;
        }
    }
}