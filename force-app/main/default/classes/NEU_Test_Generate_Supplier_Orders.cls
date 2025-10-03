@isTest()
public class NEU_Test_Generate_Supplier_Orders {
	@isTest(SeeAllData=true)
     static void test_NEU_Generate_Supplier_Orders() {
     	
     	NEU_StaticVariableHelper.setBoolean1(true);
     	
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        //Account a = list_accounts[0];
        // a.Owner.SalesEmployer__c='SalesEmployer__c';
        //insert a;
        Account a = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, OwnerId,
            RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Customer'
            AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];
        //Account sup = list_accounts[1];
        //insert sup;
        Account sup = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
            RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Transporter'
            AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];

        Customer_Quote__c importexportquote = new Customer_Quote__c(Pricing_Executive__c = a.OwnerId, Account_for__c = a.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Destination_Address__c='test address', Supplier_Account__c =sup.Id);
        insert importexportquote;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Sales');
        insert c;
        Subfamily__c d2 = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d2;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d2.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id, Weight_Kgs__c= 100, Master_Box_Height_cm__c = 1000, Units_x_Master_Box__c=10 );
        insert g;
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Units__c=1000, Expense_Amount__c = 100, Item_Supplier_Owner__c = sup.Id);
        insert quote;
        NEU_Generate_Supplier_Orders  gso = new NEU_Generate_Supplier_Orders(new ApexPages.StandardController( importexportquote ));
        gso.generate();
     }
}