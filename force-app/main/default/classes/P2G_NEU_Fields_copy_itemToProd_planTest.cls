@isTest
public class P2G_NEU_Fields_copy_itemToProd_planTest {
    
    @isTest
    static void NEU_Fields_copy_item_to_production_plan()
    {
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        Account a =list_accounts[0];
        insert a;
        Account sup = list_accounts[1];
        insert sup;
        Price_List__c b = new Price_List__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/, Items_Account_Owner__c = a.Id);
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount' /*, Business_Area__c = 'Auto-Parts'*/);
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        g.Forecasting_Unit__c = 'Packaging/Container Unit';
        update g;
        
    }
    
}