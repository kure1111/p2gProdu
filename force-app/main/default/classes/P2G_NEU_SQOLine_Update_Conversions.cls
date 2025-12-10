@isTest
public class P2G_NEU_SQOLine_Update_Conversions {

    static void NEU(){
        Test.startTest();
        NEU_StaticVariableHelper.setBoolean1(true);
        Test.stopTest();
    }
    @isTest
    static void NEU_SQOLine_Update_Conversions(){
        Test.startTest();        
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id ,  HS_Code_Text__c='56489');
        insert g;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supplier__c=a.Id);
        insert supquote;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= g.Id, Quantity__c=5);
        insert sup_quote_lines;
        
        sup_quote_lines.Name='Test002';
        update sup_quote_lines;
        Test.stopTest();
    }
}