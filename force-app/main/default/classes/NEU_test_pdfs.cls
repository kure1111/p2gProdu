@isTest
private class NEU_test_pdfs {

    static testMethod void NEU_NotesQuotationPDF()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;

User userT = [SELECT Id, ManagerId, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.UserRole.Name); // Director Comercial, Director Regional

Customer_Quote__c importexportquote = new Customer_Quote__c();
String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
importexportquote.RecordTypeId = recordTypeId;
importexportquote.Name = '.';
importexportquote.Account_for__c = account_test.Id;
importexportquote.Team__c = 'P2G';
importexportquote.Quotation_Status__c = 'Quote being prepared';
importexportquote.Customer_Reference__c = 'hola soy una prueba';
importexportquote.Valid_From__c = System.today();
importexportquote.Valid_Until__c = System.today();
importexportquote.Comercio_Exterior__c = 'No';
importexportquote.Freight_Mode__c = 'Road';
importexportquote.Service_Mode__c = 'NATIONAL';
importexportquote.Service_Type__c = 'FTL';
importexportquote.CurrencyIsoCode = 'MXN';
importexportquote.ETD__c = Date.today();
importexportquote.ETA__c = Date.today();
importexportquote.Community_Status__c = 'CUSTOMER CREATED';
importexportquote.Pricing_Executive__c = userT.Id;
importexportquote.Operations_Exec__c = userT.Id;
insert importexportquote;

        importexportquote.Service_Mode__c = 'Export';
        update importexportquote;
    }

    static testMethod void test_NEU_Air_Waybills_PDF_Master()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        Account a = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(), Business_Area__c = 'Sales');
        insert a;
        Waybill_Master__c wm = new Waybill_Master__c();
        insert wm;
        Shipment__c ship = new Shipment__c(Name='das',Account_for__c = a.Id, Freight_Mode__c = 'Air', Service_Mode__c = 'Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c sl = new Shipment_Line__c(Shipment__c = ship.id, Name = 'lineas items');
        insert sl;
        Air_Waybill__c aw = new Air_Waybill__c();
        aw.Waybill_Master__c = wm.Id;
        aw.Prepaid_Collect_WT_VAL__c = 'Prepaid';
		aw.Prepaid_Collect_Other__c = 'Prepaid';
        insert aw;
        List<Air_Waybill_Line__c> lineas = new List<Air_Waybill_Line__c>();

        Air_Waybill_Line__c line = new Air_Waybill_Line__c();
        line.Air_Waybill__c = aw.Id;
        line.Shipment__c = ship.Id;
        line.Shipment_Cargo_Line__c = sl.Id;
        line.Gross_Weight__c = 15;
        line.RCP__c = 'AEF';
        line.Kg_Lb__c = 'K';
        line.Rate_Class__c = 'M — minimum charge ';
        //line.Commodity_Item_No__c = '582';
        line.No_of_Pieces__c = 45;
        line.Chargeable_Weight__c = 12;
        line.Description__c = '';
        line.Rate_Charge__c = 1;
        //line.Total_Service_Charge__c = 250;
        line.Nature_and_Quantity_of_Goods__c = '';

        lineas.add(line);
        insert lineas;

        // Master AWB
        PageReference pageRef = Page.NEU_Air_Waybills_PDF;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(aw);
        ApexPages.currentPage().getParameters().put('type', 'master');
        NEU_Air_Waybills_PDF awbpdf = new NEU_Air_Waybills_PDF(sc);
        awbpdf.byPass();
        awbpdf.byPass2();
        String string_pdf = awbpdf.string_awb;
    }
}