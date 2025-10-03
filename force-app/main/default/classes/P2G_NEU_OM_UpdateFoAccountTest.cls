@isTest
public class P2G_NEU_OM_UpdateFoAccountTest {

    @isTest
    static void NEU_OM_UpdateFoAccount(){//ok
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Customer,');
        List<Account> lista_de_cuentas = new List<Account>();
        List<User> lista_usuarios = [select Id, AccountId from User limit 1];
        Account cuenta = list_accounts[0];
        cuenta.Account_Executive_User__c=UserInfo.getUserId();
        cuenta.Account_External_Follower_User__c=UserInfo.getUserId();
        insert cuenta;
         
        Account cuenta2 = list_accounts[1];
        
        Contact contacto2 = new Contact(AccountId = cuenta.Id, LastName='test contact');
        insert contacto2;
        
          insert cuenta2;
       
        
     } 
}