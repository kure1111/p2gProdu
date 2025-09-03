@isTest
public class P2G_ImpExpSerLinCurrency_HandlerTest {
	@isTest(SeeAllData=true)
    public static void testUpdateCurrencyIsoCodeImpExpSerLin() {      
      Test.startTest();
      //Account UAT 001RL000007lQj9YAE, PROD 0014T00000EJFY7QAP
      List<Fee__c> serviceRateList= [SELECT Id, Account_for__c,CurrencyIsoCode,CreatedDate 
                                       FROM Fee__c where Account_for__c='0014T00000EJFY7QAP' 
                                       ORDER BY CreatedDate DESC LIMIT 1];
        
        System.debug('Service Rate list test '+serviceRateList);
        
        Map<Id,String> mapServiceRate= new Map<Id,String>();
        //Se verifica que no venga vacío nuestro listado
           for(Fee__c rate: serviceRateList){
               //Agregamos el valor
            	mapServiceRate.put(rate.Id,rate.CurrencyIsoCode);
        	} 
        //Se obtiene los registros relacionados a los serviceRate Obtenidos
        List<Shipment_Fee_Line__c> spServiceLineList= [SELECT Id, CurrencyIsoCode, Service_Rate_Name__c 
                                                       FROM Shipment_Fee_Line__c 
                                                       WHERE Service_Rate_Name__c in : mapServiceRate.keySet()];
        List<Import_Export_Fee_Line__c> ieqoServiceLineList= [SELECT Id, CurrencyIsoCode, Service_Rate_Name__c, Service_Rate_Name__r.CustomRate__c 
                                                              FROM Import_Export_Fee_Line__c
                                                              WHERE Service_Rate_Name__c in : mapServiceRate.keySet()];
        if(spServiceLineList!=null && ieqoServiceLineList!=null){
            
			Map<Id, Import_Export_Fee_Line__c> oldMapIEQO= new Map<Id,Import_Export_Fee_Line__c>();
            
            for (Import_Export_Fee_Line__c impExpServiceLine : ieqoServiceLineList) {
                
                oldMapIEQO.put(impExpServiceLine.Id,impExpServiceLine.clone());
                Import_Export_Fee_Line__c oldRecord= oldMapIEQO.get(impExpServiceLine.Id);
                oldRecord.CurrencyIsoCode='EUR'; 
				
                System.debug('Antes de mi primer condicional oldRecord '+oldRecord+' impExpServiceLine.CurrencyIsoCode '+impExpServiceLine.CurrencyIsoCode+' oldRecord.CurrencyIsoCode '+oldRecord.CurrencyIsoCode);
            	
                if(oldRecord!=null && impExpServiceLine.CurrencyIsoCode!=oldRecord.CurrencyIsoCode){
                
                    System.debug('Antes de la condicional\nvalor de impExpServiceLine.Service_Rate_Name__c '+impExpServiceLine.Service_Rate_Name__c+'\nimpExpServiceLine.Service_Rate_Name__r.CustomRate__c '+impExpServiceLine.Service_Rate_Name__r.CustomRate__c);
            		
            	}
        	}
        SET<String> servRateIds = new SET<String>();
        for(Fee__c servRate: serviceRateList){
            mapServiceRate.put(servRate.Id,servRate.CurrencyIsoCode);
            servRateIds.add(servRate.Id);
        }
        List<Shipment_Fee_Line__c> spSLList=
            [SELECT Id, CurrencyIsoCode, Service_Rate_Name__c FROM Shipment_Fee_Line__c
            WHERE Service_Rate_Name__c in : servRateIds];
        
        for(Shipment_Fee_Line__c sp: spSLList){
            String currencyServiceRate=mapServiceRate.get(sp.Service_Rate_Name__c);
            if(sp.CurrencyIsoCode!=currencyServiceRate){
				sp.CurrencyIsoCode=currencyServiceRate;
            }
        }
		if(!serviceRateList.isEmpty()){
            P2G_ImpExpSerLinCurrency_Handler.updateCurrencyIsoCodeByServiceRate(serviceRateList);
            update serviceRateList;
		}
        if(!spSLList.isEmpty()){
           update spSLList; 
        }
                            System.debug('Aqui esta mi debug');
            	P2G_ImpExpSerLinCurrency_Handler.updateCurrencyIsoCodeImpExpSerLin(ieqoServiceLineList,oldMapIEQO);
            	P2G_ImpExpSerLinCurrency_Handler.updateCurrencyIsoCodeByServiceRate(serviceRateList);
        }
            Test.stopTest();

    }
}