@isTest
public class P2G_SPSerLinCurrency_HandlerTest {
   	@isTest(SeeAllData=true)
    public static void updateCurrencyIsoCodeShipmentSerLin(){       
        Test.startTest();
        //Account UAT 001RL000007lQj9YAE, PROD 0014T00000EJFY7QAP
      List<Fee__c> serviceRateList= [SELECT Id, Account_for__c,CurrencyIsoCode,CreatedDate 
                                       FROM Fee__c where Id='a0KRQ00000GHN752AH' 
                                       ORDER BY CreatedDate DESC LIMIT 1];
        System.debug('Service Rate list test '+serviceRateList);
        
        Map<Id,String> mapServiceRate= new Map<Id,String>();
        //Se verifica que no venga vacío nuestro listado
           for(Fee__c rate: serviceRateList){
               //Agregamos el valor
            	mapServiceRate.put(rate.Id,rate.CurrencyIsoCode);
        	} 
        //Se obtiene los registros relacionados a los serviceRate Obtenidos
         List<Shipment_Fee_Line__c> spServiceLineList= [SELECT Id, CurrencyIsoCode, Service_Rate_Name__c,Service_Rate_Name__r.CustomRate__c 
                                                       FROM Shipment_Fee_Line__c 
                                                       WHERE Service_Rate_Name__c in : mapServiceRate.keySet()];
        List<Import_Export_Fee_Line__c> ieqoServiceLineList= [SELECT Id, CurrencyIsoCode, Service_Rate_Name__c, Service_Rate_Name__r.CustomRate__c 
                                                              FROM Import_Export_Fee_Line__c
                                                              WHERE Service_Rate_Name__c in : mapServiceRate.keySet()];
        if(spServiceLineList!=null && ieqoServiceLineList!=null){
            
			Map<Id, Shipment_Fee_Line__c> oldMapSPSL= new Map<Id,Shipment_Fee_Line__c>();
            
            for (Shipment_Fee_Line__c spSerLine : spServiceLineList) {
                
                oldMapSPSL.put(spSerLine.Id,spSerLine.clone());
                Shipment_Fee_Line__c oldRecord= oldMapSPSL.get(spSerLine.Id);
                oldRecord.CurrencyIsoCode='EUR'; 
				
                System.debug('Antes de mi primer condicional oldRecord '+oldRecord+' impExpServiceLine.CurrencyIsoCode '+spSerLine.CurrencyIsoCode+' oldRecord.CurrencyIsoCode '+oldRecord.CurrencyIsoCode);
            	
  
                
                if(oldRecord!=null && spSerLine.CurrencyIsoCode!=oldRecord.CurrencyIsoCode){
                
                    System.debug('Antes de la condicional\nvalor de impExpServiceLine.Service_Rate_Name__c '+spSerLine.Service_Rate_Name__c+'\nimpExpServiceLine.Service_Rate_Name__r.CustomRate__c '+spSerLine.Service_Rate_Name__r.CustomRate__c);
            		
            	}
        	}
        SET<String> servRateIds = new SET<String>();
        for(Fee__c servRate: serviceRateList){
            mapServiceRate.put(servRate.Id,servRate.CurrencyIsoCode);
            servRateIds.add(servRate.Id);
        }
        List<Shipment_Fee_Line__c> spSLList=
            [SELECT Id, CurrencyIsoCode, Service_Rate_Name__c,Service_Rate_Name__r.CustomRate__c FROM Shipment_Fee_Line__c
            WHERE Service_Rate_Name__c in : servRateIds];
        
        for(Shipment_Fee_Line__c sp: spSLList){
            String currencyServiceRate=mapServiceRate.get(sp.Service_Rate_Name__c);
            if(sp.CurrencyIsoCode!=currencyServiceRate){
				sp.CurrencyIsoCode=currencyServiceRate;
            }
        }
		if(!serviceRateList.isEmpty()){
            P2G_SPSerLinCurrency_Handler.updateCurrencyIsoCodeByServiceRateSP(serviceRateList);
            update serviceRateList;
		}
        if(!spSLList.isEmpty()){
           update spSLList; 
        }
        System.debug('Aqui esta mi debug');
            	P2G_SPSerLinCurrency_Handler.updateCurrencyIsoCodeShipmentSerLin(spServiceLineList,oldMapSPSL);
            	P2G_SPSerLinCurrency_Handler.updateCurrencyIsoCodeByServiceRateSP(serviceRateList);
        
        Test.stopTest();
    }
    }
}