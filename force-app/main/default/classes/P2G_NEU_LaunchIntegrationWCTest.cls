@isTest
public class P2G_NEU_LaunchIntegrationWCTest {
    
    @isTest
    static void NEU_LaunchIntegrationWC(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a = list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(Name ='test route', Last_Receipt_Information_from_WCN__c = system.Today());
        insert route;
        route.Last_Receipt_Information_from_WCN__c = system.Today().adddays(1);
        update route;
        
    }
}