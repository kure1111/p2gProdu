@isTest
public class NEU_Update_Buy_Rate_Test {
    
    public static Boolean isUAT=false; 
    
    @IsTest(SeeAllData=true)
    public static void NEU_insert_Buy_Rate()
    {     
        isUAT();
        Account acc= new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();        	
        acc.Account_Executive_User__c=UserInfo.getUserId();
        acc.Account_External_Follower_User__c=UserInfo.getUserId();
        insert acc;                
        
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = acc.Id,
                                Cost_Concept_1__c =10);
        insert fee;
        RecursiveCheck.triggerMonitor.remove('NEU_Update_Buy_Rate');
        fee.Buy_Rate__c = 12;
        update fee;
        Log_Aprobacion__c log = new Log_Aprobacion__c();
        log.Status__c= 'Cambio Precio';        
        if(!isUAT){
        	log.Shipment__c = 'a0JRQ0000001YfZ2AU';    
            insert log;
        	P2G_updateLog.cambiaStatus('a0JRQ0000001YfZ2AU');
        }else{
            log.Shipment__c = 'a0J0R000001qJG4UAM';    
            insert log;
        	P2G_updateLog.cambiaStatus('a0J0R000001qJG4UAM');
        }
        
        
    }
    
    public static Boolean isUAT() {
    	isUAT=[SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        return isUAT;
	}
    
}