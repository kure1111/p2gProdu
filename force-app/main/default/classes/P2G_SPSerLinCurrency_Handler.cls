public class P2G_SPSerLinCurrency_Handler {    
    //Actualizamos el campo CurrencyIsoCode del objeto Service Rate
    public static void updateCurrencyIsoCodeShipmentSerLin(List<Shipment_Fee_Line__c> newRecords, Map<Id, Shipment_Fee_Line__c> oldMap){
        List<Fee__c> serviceRateList = new List<Fee__c>();
        for(Shipment_Fee_Line__c spSerLin: newRecords){
            Shipment_Fee_Line__c oldRecord=oldMap.get(spSerLin.Id);
            if(oldRecord!=null && spSerLin.CurrencyIsoCode!=oldRecord.CurrencyIsoCode){
            	if (spSerLin.Service_Rate_Name__c != null && spSerLin.Service_Rate_Name__r.CustomRate__c==false) {
                    serviceRateList.add(new Fee__c(
                            Id = spSerLin.Service_Rate_Name__c,
                            CurrencyIsoCode = spSerLin.CurrencyIsoCode
                    ));
                }
            }
        	
            if(!serviceRateList.isEmpty()){
            	updateCurrencyIsoCodeByServiceRateSP(serviceRateList);
            	update serviceRateList;
        	}
        }
    }

    
    //Actualizamos el campo CurrencyIsoCode del objeto Shipment Service Line
   	public static void updateCurrencyIsoCodeByServiceRateSP(List<Fee__c> serviceRateList){
    	Map<Id,String> mapServiceRate= new Map<Id,String>();
        SET<String> servRateIds = new SET<String>();
        for(Fee__c servRate: serviceRateList){
            mapServiceRate.put(servRate.Id,servRate.CurrencyIsoCode);
            servRateIds.add(servRate.Id);
        }
        
        List<Import_Export_Fee_Line__c> spSLList=
            [SELECT Id, CurrencyIsoCode, Service_Rate_Name__c FROM Import_Export_Fee_Line__c
            WHERE Service_Rate_Name__c in : servRateIds];
        
        for(Import_Export_Fee_Line__c sp: spSLList){
            if(sp.CurrencyIsoCode!=mapServiceRate.get(sp.Service_Rate_Name__c)){
				sp.CurrencyIsoCode=mapServiceRate.get(sp.Service_Rate_Name__c);
            }
        }
        
        if(!spSLList.isEmpty()){
            update spSLList;
        }
    }


}