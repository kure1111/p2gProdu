@isTest
public class NEU_NotesQuotationPDF_Test {
       
    @testSetup static void createdObjects(){
		
		 //user        
         User userT = new User();
         userT.FirstName = 'leo';
         userT.LastName = 'test';
         userT.Email = 'leoTest@test.com';
         userT.Username = 'leoTest@test.com.leoTest';
         userT.Alias = 'TestL';
         userT.TimeZoneSidKey = 'America/Mexico_City';
         userT.LocaleSidKey = 'es_MX';
         userT.EmailEncodingKey = 'UTF-8';
         userT.ProfileId = [Select Id from Profile where Name = 'System Administrator'].Id;
         userT.LanguageLocaleKey = 'es_MX';
         insert userT;
 
         //Account         
         Account accountT = new Account();
         accountT.name = 'account test';
         accountT.Customer_Id__c = '58SQL1256';
         accountT.OwnerId = userT.Id;
         accountT.Venta_Sap__c = 'Contado';        
         insert accountT;       
        
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen('Director Comercial');
        
         Customer_Quote__c folio = new Customer_Quote__c();
         folio.Account_for__c = accountT.Id;
         folio.Freight_Mode__c = 'Sea';
         folio.Service_Mode__c = 'Export';
         folio.Service_Type__c = 'LCL';
         folio.Move_Type__c = 'Door to Door';
         folio.Origin_Address__c = 'Address Test';
         folio.Destination_Address__c = 'Address Test';
         folio.Pricing_Executive__c=userinfo.getUserId();
         insert folio;
        
    }
    
    public static testMethod void updateFolioM(){
                        
        Id user =[Select Id from Account where Name = 'account test'].Id;
        List<Customer_Quote__c> folioF = [Select id from Customer_Quote__c where  Account_for__c =: user];
        Customer_Quote__c folioM = folioF.get(0);
        folioM.Freight_Mode__c = 'Sea';
        folioM.Service_Mode__c = 'Import';
        folioM.Service_Type__c = 'LCL';
        
        test.startTest();
	        update folioM;
        test.stopTest();
    }
    
    
    
    
}