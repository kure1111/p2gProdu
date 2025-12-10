@isTest
private class NEU_test_Supplier_QuoteOrder {

       
        static testMethod void test_NEU_OM_Start_Clearance_SupplierQuote() {
      NEU_StaticVariableHelper.setBoolean1(true);
        ApexPages.currentPage().getParameters().put('test', 'test');
        List<Account> list_accounts = NEU_Utils.getAccounts('Supplier,Customer,');
        Account a = list_accounts[0];
        insert a;
        Account b = list_accounts[1];
        insert b;
        Supply_Project__c supplyproject = new Supply_Project__c(Name='project test', Customer__c = b.Id);
        insert supplyproject;
        Supplier_Quote__c supquote = new Supplier_Quote__c(Supply_Project__c= supplyproject.Id,Supplier__c=a.Id);
        insert supquote;
        Product_Family__c family = new Product_Family__c(Name = 'Test acount',Business_Area__c = 'Auto-Parts');
        insert family;
        Subfamily__c subfamily = new Subfamily__c(Product_Family__c = family.Id, Name = 'test subfamily');
        insert subfamily;
        Sourcing_Item__c item = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = subfamily.Id, Sourcing_Family__c =family.id, Account_Owner__c= a.Id, Weight_Kgs__c=10 );
        insert item;
        Supplier_Quote_Line__c sup_quote_lines = new Supplier_Quote_Line__c(Supplier_Quote__c=supquote.Id, Name=' test quote line', Item__c= item.Id, Quantity__c=1000);
        insert sup_quote_lines;
        
        NEU_OM_Start_Clearance_SupplierQuote uda = new NEU_OM_Start_Clearance_SupplierQuote(new ApexPages.StandardController( supquote ));
        uda.idlineaitem = sup_quote_lines.Id;
        uda.getlist_category();
        uda.getlista_subcategorias();
        uda.getlista_items();
        uda.getDutyCalculatorInfo();
        uda.getshipmentItemLines();
        uda.getshipmentItemLines2();
        uda.applyLines();
        uda.calculate_taxes ();
        uda.calcular_hs_codes();
    }
}