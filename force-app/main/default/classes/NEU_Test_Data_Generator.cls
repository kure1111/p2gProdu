@isTest(SeeAllData=true)
public class NEU_Test_Data_Generator {
    @isTest
    static void testGetAccounts() {
        RecordType rt = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Account' AND IsActive = true LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Record_Type_Name__c  = 'Customer' LIMIT 1];
        Shipment__c ship = [SELECT Id FROM Shipment__c LIMIT 1];
        Customer_Quote__c quote = [SELECT Id, Name FROM Customer_Quote__c LIMIT 1];
        Account sup = [SELECT Id FROM Account WHERE Record_Type_Name__c  = 'Supply Chain Partner' LIMIT 1];
        Fee__c fee = [SELECT Id FROM Fee__c LIMIT 1];
        Sourcing_Item__c item = [SELECT Id FROM Sourcing_Item__c LIMIT 1];
        
        Test.startTest();
        Supplier_Quote__c suppQuote = New Supplier_Quote__c();
        suppQuote.Customer__c = acc.Id;
        suppQuote.Supplier__c = sup.Id;
        insert suppQuote;
        Product_Family__c family = new Product_Family__c();
        family.Name = 'test family';
        insert family;
        Supply_Project__c project = New Supply_Project__c();
        project.Name = 'test project';
        project.Customer__c = acc.Id;
        insert project;
        Supplier_Request_RFP__c request = New Supplier_Request_RFP__c();
        request.Subject__c = 'test request';
        request.Supplier__c = sup.Id;
        insert request;
        Subfamily__c subfamily = New Subfamily__c();
        subfamily.Name = 'test subfamily';
        subfamily.Product_Family__c = family.Id;
        insert subfamily;
        List<Account> accounts = NEU_Data_Generator.getAccounts(rt.DeveloperName);
        List<Customer_Quote__c> quotesAir = NEU_Data_Generator.getImportExport(acc, 'Air', 1);
        List<Customer_Quote__c> quotesSea = NEU_Data_Generator.getImportExport(acc, 'Sea', 1);
        List<Price_List__c> priceLists = NEU_Data_Generator.getPriceList(acc, family);
        List<Shipment__c> shipments = NEU_Data_Generator.getShipment(acc, 'Sea');
        List<Shipment_Consolidation_Data__c> consolidations = NEU_Data_Generator.getShipmentConsolidation(ship, quote);
        List<Supply_Project__c> projects = NEU_Data_Generator.getSupplyProject(acc);
        List<Supplier_Quote__c> quotes = NEU_Data_Generator.getSupplierQuote(sup, project, request);
        List<Supplier_Request_RFP__c> requests = NEU_Data_Generator.getSupplierRequestRFP(sup, project);
        List<Associated_Document__c> docs = NEU_Data_Generator.getAssociatedDocument(acc, quote);
        List<Shopping_Cart__c> carts = NEU_Data_Generator.getShopping(acc);
        List<Claim__c> claims = NEU_Data_Generator.getClaim(acc);
        List<Transport_Packaging_Data__c> transports = NEU_Data_Generator.getTransport(ship);
        List<Shipment_Disbursement__c> disbursements = NEU_Data_Generator.getShipmentDisbursement(acc);
        List<Product_Family__c> families = NEU_Data_Generator.getFamilies(1);
        List<Subfamily__c> subfamilies = NEU_Data_Generator.getSubFamilies(family);
        List<Sourcing_Item__c> items = NEU_Data_Generator.getSourcingItems(acc, family, subfamily);
        List<Supplier_Quote_Line__c> lines3 = NEU_Data_Generator.getSupplierQuoteLine(suppQuote, item, request);
        List<Quote_Item_Line__c> lines2 = NEU_Data_Generator.getQuoteItemLine(quote, 2);
        List<Fee__c> fees = NEU_Data_Generator.getFee(acc, 1);
        List<Import_Export_Fee_Line__c> lines = NEU_Data_Generator.getImportExportFeeLine(fee, quote);
        Test.stopTest();
    }
}