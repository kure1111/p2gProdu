@isTest
public class P2G_ServiceRateCurrency_HandlerTest {   
    @isTest(SeeAllData=true)
    public static void test2CurrencyServiceRate(){

        //Service Rate Id UAT a0KRL00000Azz5d2AB y PROD a0KRQ00000GHN752AH
        List<Fee__c> serviceRateList = [SELECT Id, Account_for__c,CurrencyIsoCode,CreatedDate,LastModifiedBy.Profile.Name,LastModifiedById
                                       FROM Fee__c where Id='a0KRQ00000GHN752AH'];
        System.debug('currency '+serviceRateList[0].CurrencyIsoCode);
        System.debug('listado original'+serviceRateList);
        
        Map<Id, Fee__c> oldMap= new Map<Id, Fee__c>(); 
        
        for(Fee__c serviceRate: serviceRateList){
			oldMap.put(serviceRate.Id,serviceRate.clone());
			serviceRate.CurrencyIsoCode='EUR';
        }
        
        System.debug('listado despues de modificar el campo currency'+serviceRateList);
        System.debug('oldRecord'+oldMap);
        
        NEU_StaticVariableHelper.setBoolean1(true);
        P2G_ServiceRateCurrency_Handler.serviceRateCurrencyIsoCode(serviceRateList,oldMap);	
        
        
    }
}