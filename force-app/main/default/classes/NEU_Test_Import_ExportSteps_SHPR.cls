@isTest
public class NEU_Test_Import_ExportSteps_SHPR {
	@isTest(SeeAllData=true)
       static void test_NEU_Import_ExportSteps_SHPR() {
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //   a.Owner.SalesEmployer__c='002';
        //insert a;
        Account a = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
            RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Customer'
            AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];
        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
       // Currency__c currency2 = new Currency__c(Name='test currency',Currency_Code__c ='VAA', Currency_Symbol__c=':)' );
       // insert currency2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        NEU_Import_ExportSteps_SHPR ie = new NEU_Import_ExportSteps_SHPR(new ApexPages.StandardController( importexportquote ));
        system.debug( 'Prueba realizada' );
    }
    @isTest(SeeAllData=true)
      static void test_NEU_Import_ExportSteps_SHPR2() {
      	
      	NEU_StaticVariableHelper.setBoolean1(true);
      	
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //  a.Owner.SalesEmployer__c='002';
        //insert a;
        Account a = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
            RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Customer'
            AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];

        Contact contacto = new Contact(AccountId = a.Id, LastName='test contact');
        insert contacto;
        Product_Family__c c = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c;
        Product_Family__c c2 = new Product_Family__c(Name = 'Test acount', Business_Area__c = 'Auto-Parts');
        insert c2;
        Price_List__c b = new Price_List__c(Name = 'Test lista', Business_Area__c = 'Auto-Parts', Family__c=c.Id, Items_Account_Owner__c = a.Id);
        insert b;
        //Currency__c currency2 = new Currency__c(Name='test currency',Currency_Code__c ='VAA', Currency_Symbol__c=':)' );
        //insert currency2;
        Country__c Country = new Country__c(Name='test country',  ISO_Code__c='EUR');
        insert Country;
        Location__c localizacion = new Location__c(Name='test localizacion', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert localizacion;
        Customer_Quote__c importexportquote = new Customer_Quote__c( Catalog_Price_List__c = b.id, Pricing_Executive__c=userInfo.getUserId(), Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote;
        Customer_Quote__c importexportquote2 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Pricing_Executive__c=userInfo.getUserId(), Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote2;
        Customer_Quote__c importexportquote4 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Pricing_Executive__c=userInfo.getUserId(), Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote4;
        Customer_Quote__c importexportquote5 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Pricing_Executive__c=userInfo.getUserId(), Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote5;
        Task nueva_tarea = new Task(WhatId = importexportquote4.Id);
        insert nueva_tarea;
        Associated_Document__c documento_asociado = new Associated_Document__c ( Name = importexportquote2.Name +'%', Import_Export_Quote__c = importexportquote2.Id, Account__c = a.Id);
        insert documento_asociado;
        
        Customer_Quote__c importexportquote3 = new Customer_Quote__c( Catalog_Price_List__c = b.id, Pricing_Executive__c=userInfo.getUserId(), Account_for__c = a.Id, Contact__c = contacto.Id, Freight_Mode__c='Air',Service_Mode__c='Import', Service_Type__c='LCL Cargo',Move_Type__c='Door to Door',Origin_Address__c='tst adrress', Country_ofLoad__c= Country.Id, Site_of_Load__c=localizacion.Id,Country_ofDischarge__c= Country.Id,Site_of_Discharge__c= localizacion.Id, Destination_Address__c='test address');//Quote_Agent__c= ,Quote_Export_Company__c=, 
        insert importexportquote3;
        
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement',  Active__c = true, RecordTypeId = Schema.SobjectType.Fee__c.getRecordTypeInfosByName().get('Other Service Charges').getRecordTypeId(), Rate_Type__c='Per Container', Account_for__c = a.Id);
        insert fee;
        Import_Export_Fee_Line__c quote2 = new Import_Export_Fee_Line__c(Import_Export_Quote__c = importexportquote3.id,Name = 'lineas items', Service_Rate_Name__c= fee.Id);
        insert quote2;
        Subfamily__c d = new Subfamily__c(Product_Family__c = c.Id, Name = 'test subfamily');
        insert d;
        Sourcing_Item__c g = new Sourcing_Item__c(Name = 'Test item',Subfamily__c = d.Id, Sourcing_Family__c =c.id, Account_Owner__c= a.Id );
        insert g;
        
        Quote_Item_Line__c quote = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Delivery_Number__c = 1);
        insert quote;
        Quote_Item_Line__c quote5 = new Quote_Item_Line__c(Import_Export_Quote__c = importexportquote5.id,Name = 'lineas items', Item_Name__c= g.Id, Customs_Value__c=1000, Delivery_Number__c = 1);
        insert quote5;
         Shipment__c ship = new Shipment__c(Name = 'SP-'+importexportquote5.Name, Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Import_Export_Quote__c =importexportquote.Id);
        insert shipline;
        
        NEU_Import_ExportSteps_SHPR ie = new NEU_Import_ExportSteps_SHPR(new ApexPages.StandardController( importexportquote ));
        NEU_Import_ExportSteps_SHPR ie2 = new NEU_Import_ExportSteps_SHPR(new ApexPages.StandardController( importexportquote2 ));
        NEU_Import_ExportSteps_SHPR ie3 = new NEU_Import_ExportSteps_SHPR(new ApexPages.StandardController( importexportquote3 ));
        system.debug( 'Prueba realizada' );
    }
}