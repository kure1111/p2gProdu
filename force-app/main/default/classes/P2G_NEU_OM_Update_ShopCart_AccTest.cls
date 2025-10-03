@isTest
public class P2G_NEU_OM_Update_ShopCart_AccTest {
    
    @isTest
    static void NEU_OM_Update_ShoppingCart_Account_Status() 
    {
        Test.startTest();
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account buyer = list_accounts[0];
        insert buyer;
        Contact contacto = new Contact(AccountId = buyer.Id, LastName='test contact');
        insert contacto;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = buyer.Id);
        insert supplyproject;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount' /*,Business_Area__c = 'Sales'*/);
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= buyer.Id , E_Commerce__c = true);
        insert item;
        Shopping_Cart__c shop = new Shopping_Cart__c(Customer__c=buyer.Id);
        insert shop;
        Shopping_Cart_line__c shoplines = new Shopping_Cart_line__c(Shopping_Cart__c = shop.Id, Name = 'test shopline', Item_Name__c = item.Id, Units__c=10, Offer_Price__c=10, List_Price__c=10);
        insert shoplines;
        shop.Status__c ='Open';
        update shop;
        Test.stopTest();
    }
}