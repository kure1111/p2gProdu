@isTest
public class NEU_Create_Invoice_Service_ItemTest {
	@isTest(SeeAllData=true)
    static void NEU_Create_Invoice_Service_Item2()
    {
        NEU_StaticVariableHelper.setBoolean1(true);

        //List<Account> list_accounts = NEU_Data_Generator.getAccounts('Customer,Supplier');
        //insert list_accounts;
        //Account account =  list_accounts[0];
        //Account sup = list_accounts[1];

        Account account = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, Owner.Id,
        RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Customer'
        AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1];        
		
        Account sup = [SELECT Id, Owner.isActive,Owner.SalesEmployer__c, 
        RecordType.DeveloperName FROM Account WHERE RecordType.DeveloperName='Transporter'
        AND Owner.isActive=true AND Owner.SalesEmployer__c!=null LIMIT 1]; 

        //Customer Quote
        Customer_Quote__c importexportquote 	= new Customer_Quote__c();
        importexportquote.Account_for__c 		= account.Id;
        importexportquote.Freight_Mode__c 		='Air';
        importexportquote.Service_Mode__c 		='Import';
        importexportquote.Service_Type__c	 	='LCL Cargo';
        importexportquote.Move_Type__c 			= 'Door to Door';
        importexportquote.Origin_Address__c 	= 'tst adrress';
        importexportquote.Destination_Address__c = 'test address';
        importexportquote.Pricing_Executive__c	= account.Owner.Id;
        insert importexportquote;

        //Fee
        Fee__c fee 			= new Fee__c();
        fee.Name 			= 'test fees';
        fee.Fee_Category__c = 'Disbursement';
        fee.Rate_Type__c	= 'Fixed';
        fee.Account_for__c	= account.Id;
        insert fee;

        //Shipment
        Shipment__c shipment_test 		= new Shipment__c();
        shipment_test.Account_for__c 	= account.Id;
        shipment_test.Freight_Mode__c 	= 'Sea';
        shipment_test.Service_Mode__c 	= 'Import';
        shipment_test.Status_Acuse_SAP__c = 'Acuse Ok Facturacion Pte';
        shipment_test.Only_Warehouse_Service__c = true;
        shipment_test.Name = 'SP-TS-00006';
        insert shipment_test;
        
        //Invoice
        Invoice__c invoice 						= new Invoice__c();
        invoice.Import_Export_Quote_Order__c 	= importexportquote.Id;
        invoice.Shipment__c						= shipment_test.Id;
        invoice.Account__c 						= account.Id;
        insert invoice;

        Invoice__c invoice2						= new Invoice__c();
        invoice2.Import_Export_Quote_Order__c 	= importexportquote.Id;
        invoice2.Shipment__c						= shipment_test.Id;
        invoice2.Account__c						= account.Id;
        insert invoice2;

        //Invoice Line
        Invoice_Line__c invoiceLine = new Invoice_Line__c();
        invoiceLine.Invoice__c = invoice.Id;
        insert invoiceLine;

        //Shipment Line
        Shipment_Line__c shipline 		= new Shipment_Line__c();
        shipline.Shipment__c 			= shipment_test.Id;
        shipline.Import_Export_Quote__c = invoice.Import_Export_Quote_Order__c;
        shipline.Name					= 'test ship line';
        insert shipline;

        //Invoice_Item_Line
        Invoice_Item_Line__c invoiceItemLine 	= new Invoice_Item_Line__c();
        invoiceItemLine.Invoice__c 				= invoice.Id;
        invoiceItemLine.Shipment_Item_Line__c	= shipline.Id;
        insert invoiceItemLine;

        shipline 				= new Shipment_Line__c();
        shipline.Import_Export_Quote__c = invoice.Import_Export_Quote_Order__c;
        shipline.Shipment__c 	= shipment_test.Id;
        shipline.Name			= 'test ship line';
        insert shipline;


        //Shipment Fee Line
        Shipment_Fee_Line__c shipfeeline 		= new Shipment_Fee_Line__c();
        shipfeeline.Name 						= 'test shipment fee line';
        shipfeeline.Discount_Charge__c 			= 8;
        shipfeeline.Extension_Service_Name__c	='test extension';
        shipfeeline.Service_Rate_Name__c 		= fee.Id;
        shipfeeline.Shipment__c 				= shipment_test.Id;
        shipfeeline.Shipment_Sell_Price__c 		= 10;
        shipfeeline.Units__c 					= 10;
        shipfeeline.Import_Export_Quote__c		= invoice.Import_Export_Quote_Order__c;
        shipfeeline.Shipment_Buy_Price__c 		= 10;
        insert shipfeeline;

        shipfeeline 							= new Shipment_Fee_Line__c();
        shipfeeline.Name						= 'test shipment fee line';
        shipfeeline.Discount_Charge__c 			= 8;
        shipfeeline.Extension_Service_Name__c 	= 'test extension';
        shipfeeline.Service_Rate_Name__c 		= fee.Id;
        shipfeeline.Shipment__c 				= shipment_test.Id;
        shipfeeline.Shipment_Sell_Price__c 		= 10;
        shipfeeline.Import_Export_Quote__c		= invoice.Import_Export_Quote_Order__c;
        shipfeeline.Units__c	 				= 10;
        shipfeeline.Shipment_Buy_Price__c 		= 10;
        insert shipfeeline;

        //Invoice_Service_Line
        Invoice_Service_Line__c invoiceServiceLine  = new Invoice_Service_Line__c();
        invoiceServiceLine.Invoice__c = invoice.Id;
        invoiceServiceLine.Shipment_Service_Line__c = shipfeeline.Id;
        insert invoiceServiceLine;

        //Family
        List<Product_Family__c> listFamily = NEU_Data_Generator.getFamilies(1);
        insert listFamily;

        //complete test data generator
        NEU_Data_Generator.getImportExport(account, 'Road', 1);
        NEU_Data_Generator.getImportExport(account, 'Air', 1);
        NEU_Data_Generator.getImportExport(account, 'Sea', 1);
        NEU_Data_Generator.getPriceList(account, listFamily[0]);
        NEU_Data_Generator.getShipment(account, 'Road');
        NEU_Data_Generator.getShipment(account, 'Sea');
        NEU_Data_Generator.getShipmentConsolidation(shipment_test, importexportquote);
        NEU_Data_Generator.getAssociatedDocument(account, importexportquote);
        NEU_Data_Generator.getShopping(account);
        NEU_Data_Generator.getClaim(account);
        NEU_Data_Generator.getTransport(shipment_test);
        NEU_Data_Generator.getShipmentDisbursement(account);


    //Subfamily
        List<Subfamily__c> listSubFamily = NEU_Data_Generator.getSubFamilies(listFamily.get(0));
        insert listSubFamily;

        //Item
        List<Sourcing_Item__c> listItem = NEU_Data_Generator.getSourcingItems(account, listFamily.get(0), listSubFamily.get(0));
        insert listItem;

        //Supply_Project
        List<Supply_Project__c> listSupplyProject = NEU_Data_Generator.getSupplyProject(account);
        insert listSupplyProject;

        //Supplier_Request_RF
        List<Supplier_Request_RFP__c> listSupplierRequestRFP = NEU_Data_Generator.getSupplierRequestRFP(sup, listSupplyProject.get(0));
        insert listSupplierRequestRFP;

        //Supplier_Quote
        List<Supplier_Quote__c> listSupplierQuote = NEU_Data_Generator.getSupplierQuote(sup, listSupplyProject.get(0),
                listSupplierRequestRFP.get(0));
        insert listSupplierQuote;

        //Supplier Quote Line
        List<Supplier_Quote_Line__c> listSupplierQuoteLine = NEU_Data_Generator.getSupplierQuoteLine(listSupplierQuote.get(0), listItem.get(0),
                listSupplierRequestRFP.get(0));
        Supplier_Quote_Line__c supplierQuoteLine = listSupplierQuoteLine.get(0);
        insert supplierQuoteLine;

        //Quote_Item_Line
        List<Quote_Item_Line__c> listQuoteItemLine 	= NEU_Data_Generator.getQuoteItemLine(importexportquote, 2);
        Quote_Item_Line__c quoteItemLine 			= listQuoteItemLine.get(0);
        quoteItemLine.Import_Export_Quote__c 		= importexportquote.Id;
        insert quoteItemLine;

        Quote_Item_Line__c quoteItemLine2 			= listQuoteItemLine.get(1);
        quoteItemLine2.Import_Export_Quote__c 		= importexportquote.Id;
        insert quoteItemLine2;

        //Fee
        List<Fee__c> ListFee = NEU_Data_Generator.getFee(sup, 2);
        insert ListFee;

        //Import_Export_Fee_Line
        List<Import_Export_Fee_Line__c> listIeFeeLine 	= NEU_Data_Generator.getImportExportFeeLine(ListFee.get(0), importexportquote);
        List<Import_Export_Fee_Line__c> listIeFeeLine2 	= NEU_Data_Generator.getImportExportFeeLine(ListFee.get(1), importexportquote);
        insert listIeFeeLine;
        insert listIeFeeLine2;

        //Import_Export_Service_Line_Invoice
        Import_Export_Service_Line_Invoice__c ieServiceLineInvoice 	= new Import_Export_Service_Line_Invoice__c();
        ieServiceLineInvoice.Import_Export_Service_Line__c 			= listIeFeeLine.get(0).Id;
        ieServiceLineInvoice.Invoice__c 							= invoice.Id;
        insert ieServiceLineInvoice;

        ieServiceLineInvoice 	= new Import_Export_Service_Line_Invoice__c();
        ieServiceLineInvoice.Invoice__c 							= invoice2.Id;
        ieServiceLineInvoice.Import_Export_Service_Line__c 			= listIeFeeLine2.get(0).Id;
        insert ieServiceLineInvoice;

        //Import_Export_Item_Line_Invoice
        List<Import_Export_Item_Line_Invoice__c> listIeItemLine = new List<Import_Export_Item_Line_Invoice__c>();
        Import_Export_Item_Line_Invoice__c ieItemLineInvoice = new Import_Export_Item_Line_Invoice__c();
        ieItemLineInvoice.Import_Export_Item_Line__c =	quoteItemLine.Id;
        ieItemLineInvoice.Invoice__c = invoice.Id;
        listIeItemLine.add(ieItemLineInvoice);

        insert listIeItemLine;

        NEU_Create_Invoice_Service_Item page = new NEU_Create_Invoice_Service_Item(new ApexPages.StandardController(invoice));
        //page.id_linea = importexportquote.Id;
        page.id_linea =  quoteItemLine.Id;
        String sqs;
        Decimal dqs;

        for(NEU_Create_Invoice_Service_Item.Line_s lista : page.Lines)
        {
            lista.selected = true;
            sqs = lista.Quote_Sell_Net_Price_String;
            sqs = lista.Sell_Net_Amount_String;
            sqs = lista.Invoice_Outstanding_Balance_String;
            dqs = lista.Invoice_Outstanding_Base;
            break;
        }
        for(NEU_Create_Invoice_Service_Item.LineS_s lista : page.LinesS)
        {
            lista.selected = true;
            sqs =  lista.Quote_Sell_Net_Price_String;
            sqs = lista.Sell_Net_Amount_String;
            sqs = lista.Invoice_Outstanding_Balance_String;
            dqs = lista.Invoice_Outstanding_Base;
            break;
        }
        page.sorting(0,'selected',1);
        page.sorting(1,'selected',1);
        page.sortList(4);
        page.generate();
        page.new_invoice_line();
        page.quit_line_select();
        page.id_line 		= page.id_line;
        page.new_line_invoiceline_empty();
        page.delete_line_select();
        page.cancel();
        page.updateLines();
        page.decimalSep 	= page.decimalSep;
        page.thousandSep 	= page.thousandSep;


    }//fin test
}