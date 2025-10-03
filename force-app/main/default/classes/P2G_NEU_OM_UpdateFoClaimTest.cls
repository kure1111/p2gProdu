@isTest
public class P2G_NEU_OM_UpdateFoClaimTest {
    
    @isTest
    static void NEU_OM_UpdateFoClaim(){
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account cuenta = list_accounts[0];
        insert cuenta;
        Contact contacto = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto;
        Contact contacto2 = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto2;
        Claim__c claim = new Claim__c(Customer__c = cuenta.Id);                
        insert claim;
    }
}