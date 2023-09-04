@isTest
public class Cifid_Test {
    private static testMethod void updateQuote(){
        new Cifid_updateQuote.LogInfo();
        new Cifid_updateQuote.DebuggingInfo_element();
        new Cifid_updateQuote.address();
        new Cifid_updateQuote.SessionHeader_element();
        new Cifid_updateQuote.estatus();
        new Cifid_updateQuote.updateQuote_element();
        new Cifid_updateQuote.CallOptions_element();
        new Cifid_updateQuote.updateQuoteResponse_element();
        new Cifid_updateQuote.DebuggingHeader_element();
        new Cifid_updateQuote.location();
        new Cifid_updateQuote.AllowFieldTruncationHeader_element();
        new Cifid_updateQuote.CustomerQuote();
        new Cifid_updateQuote.Cifid_UpdateQuoteFromPak();
    }
    
    private static testMethod void shipmentUpdate(){
        new Cifid_updateQuoteShipment.LogInfo();
        new Cifid_updateQuoteShipment.DebuggingInfo_element();
        new Cifid_updateQuoteShipment.address();
        new Cifid_updateQuoteShipment.SessionHeader_element();
        new Cifid_updateQuoteShipment.estatus();
        new Cifid_updateQuoteShipment.updateQuote_element();
        new Cifid_updateQuoteShipment.CallOptions_element();
        new Cifid_updateQuoteShipment.updateQuoteResponse_element();
        new Cifid_updateQuoteShipment.DebuggingHeader_element();
        new Cifid_updateQuoteShipment.location();
        new Cifid_updateQuoteShipment.AllowFieldTruncationHeader_element();
        new Cifid_updateQuoteShipment.Shipment();
        new Cifid_updateQuoteShipment.Cifid_ShipmentFromPak();
    }
    
    private static testMethod void quoteLines(){
        new CifidQuoteLines.LogInfo();
        new CifidQuoteLines.DebuggingInfo_element();
        new CifidQuoteLines.address();
        new CifidQuoteLines.SessionHeader_element();
        new CifidQuoteLines.estatus();
        new CifidQuoteLines.quoteLinesResponse_element();
        new CifidQuoteLines.CallOptions_element();
        new CifidQuoteLines.DebuggingHeader_element();
        new CifidQuoteLines.location();
        new CifidQuoteLines.AllowFieldTruncationHeader_element();
        new CifidQuoteLines.Quote();
        new CifidQuoteLines.QuoteLine();
        new CifidQuoteLines.quoteLines_element();
        new CifidQuoteLines.Cifid_QuoteLines();
    }
    
    private static testMethod void shipmentLines(){
        new CifidShipmentLines.LogInfo();
        new CifidShipmentLines.DebuggingInfo_element();
        new CifidShipmentLines.address();
        new CifidShipmentLines.SessionHeader_element();
        new CifidShipmentLines.estatus();
        new CifidShipmentLines.shipmentLinesResponse_element();
        new CifidShipmentLines.CallOptions_element();
        new CifidShipmentLines.DebuggingHeader_element();
        new CifidShipmentLines.location();
        new CifidShipmentLines.AllowFieldTruncationHeader_element();
        new CifidShipmentLines.Shipment();
        new CifidShipmentLines.ShipLine();
        new CifidShipmentLines.shipmentLines_element();
        new CifidShipmentLines.Cifid_ShipmentLines();
    }
    
    private static testMethod void pakQuoteCifid(){
        new PakQuoteToCifid.LogInfo();
        new PakQuoteToCifid.DebuggingInfo_element();
        new PakQuoteToCifid.address();
        new PakQuoteToCifid.SessionHeader_element();
        new PakQuoteToCifid.estatus();
        new PakQuoteToCifid.CallOptions_element();
        new PakQuoteToCifid.DebuggingHeader_element();
        new PakQuoteToCifid.location();
        new PakQuoteToCifid.AllowFieldTruncationHeader_element();
        new PakQuoteToCifid.Pak_Quote();
        new PakQuoteToCifid.Quote();
        new PakQuoteToCifid.quoteFromPakResponse_element();
        new PakQuoteToCifid.quoteFromPak_element();
    }
    
    private static testMethod void updateQuoteTrgr(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Customer_Quote__c quote_test = new Customer_Quote__c();
        quote_test.Account_for__c = account_test.Id;
        quote_test.Freight_Mode__c = 'Air';
        quote_test.Service_Mode__c = 'Import'; 
        quote_test.Service_Type__c = 'LCL Cargo';
        quote_test.Move_Type__c = 'Door to Door';
        quote_test.Origin_Address__c = 'Address Test'; 
        quote_test.Destination_Address__c = 'Address Test';
        quote_test.ByPass__c = true;
        quote_test.Impak_Request__c = true;
        insert quote_test;
        
        quote_test.Date_Pricing_responded__c = System.today();
        update quote_test;
        
        Cifid_SendUpdateIeq.Test();
    }
    
    private static testMethod void updateQuoteShipment(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Shipment__c ship = new Shipment__c(Account_for__c = account_test.Id, Freight_Mode__c='Air', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        Customer_Quote__c quote_test = new Customer_Quote__c();
        quote_test.Account_for__c = account_test.Id;
        quote_test.Freight_Mode__c = 'Air';
        quote_test.Service_Mode__c = 'Import'; 
        quote_test.Service_Type__c = 'LCL Cargo';
        quote_test.Move_Type__c = 'Door to Door';
        quote_test.Origin_Address__c = 'Address Test'; 
        quote_test.Destination_Address__c = 'Address Test';
        quote_test.ByPass__c = true;
        quote_test.Impak_Request__c = true;
        insert quote_test;
        
        quote_test.Last_Shipment__c = ship.Id;
        update quote_test;
        
        ship.HBL_Number__c = '1';
        update ship;

		Cifid_SendUpdateShipment.Test();        
    }
    
    private static testMethod void servLinesTrgr(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Customer_Quote__c quote_test = new Customer_Quote__c();
        quote_test.Account_for__c = account_test.Id;
        quote_test.Freight_Mode__c = 'Air';
        quote_test.Service_Mode__c = 'Import'; 
        quote_test.Service_Type__c = 'LCL Cargo';
        quote_test.Move_Type__c = 'Door to Door';
        quote_test.Origin_Address__c = 'Address Test'; 
        quote_test.Destination_Address__c = 'Address Test';
        quote_test.Impak_Request__c = true;
        insert quote_test;
        System.debug('Quote ' + quote_test.Id + ' - ' + quote_test.Impak_Request__c);
        Customer_Quote__c quote_test2 = new Customer_Quote__c();
        quote_test2.Account_for__c = account_test.Id;
        quote_test2.Freight_Mode__c = 'Air';
        quote_test2.Service_Mode__c = 'Import'; 
        quote_test2.Service_Type__c = 'LCL Cargo';
        quote_test2.Move_Type__c = 'Door to Door';
        quote_test2.Origin_Address__c = 'Address Test'; 
        quote_test2.Destination_Address__c = 'Address Test';
        quote_test2.Impak_Request__c = true;
        insert quote_test2;
        System.debug('Quote ' + quote_test2.Id + ' - ' + quote_test2.Impak_Request__c);
        
        List<Import_Export_Fee_Line__c> lstLines = new List<Import_Export_Fee_Line__c>();
                
        Import_Export_Fee_Line__c sl = new Import_Export_Fee_Line__c();
        sl.Import_Export_Quote__c = quote_test.Id;
        sl.Name = 'Test';
        lstLines.add(sl);
        
        Import_Export_Fee_Line__c sl1 = new Import_Export_Fee_Line__c();
        sl1.Import_Export_Quote__c = quote_test.Id;
        sl1.Name = 'Test 1';
        lstLines.add(sl1);
        
        Import_Export_Fee_Line__c sl2 = new Import_Export_Fee_Line__c();
        sl2.Import_Export_Quote__c = quote_test2.Id;
        sl2.Name = 'Test2';
        lstLines.add(sl2);
        
        Import_Export_Fee_Line__c sl3 = new Import_Export_Fee_Line__c();
        sl3.Import_Export_Quote__c = quote_test2.Id;
        sl3.Name = 'Test 3';
        lstLines.add(sl3);
        
        insert lstLines;
        
        lstLines[0].Quote_Buy_Price__c = 12;
        update lstLines[0];
        
        delete lstLines[2];
        
        Cifid_SendQuoteLines.Test();
    }
    
    private static testMethod void shipServLinesTrgr(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Customer_Quote__c quote_test = new Customer_Quote__c();
        quote_test.Account_for__c = account_test.Id;
        quote_test.Freight_Mode__c = 'Air';
        quote_test.Service_Mode__c = 'Import'; 
        quote_test.Service_Type__c = 'LCL Cargo';
        quote_test.Move_Type__c = 'Door to Door';
        quote_test.Origin_Address__c = 'Address Test'; 
        quote_test.Destination_Address__c = 'Address Test';
        quote_test.Impak_Request__c = true;
        insert quote_test;
        System.debug('Quote ' + quote_test.Id + ' - ' + quote_test.Impak_Request__c);
        Customer_Quote__c quote_test2 = new Customer_Quote__c();
        quote_test2.Account_for__c = account_test.Id;
        quote_test2.Freight_Mode__c = 'Air';
        quote_test2.Service_Mode__c = 'Import'; 
        quote_test2.Service_Type__c = 'LCL Cargo';
        quote_test2.Move_Type__c = 'Door to Door';
        quote_test2.Origin_Address__c = 'Address Test'; 
        quote_test2.Destination_Address__c = 'Address Test';
        quote_test2.Impak_Request__c = true;
        insert quote_test2;
        System.debug('Quote ' + quote_test2.Id + ' - ' + quote_test2.Impak_Request__c);
        
        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;
        
        quote_test.Last_Shipment__c = shipment_test.Id;
        update quote_test;
        
        Shipment__c shipment_test2 = new Shipment__c();
        shipment_test2.Account_for__c = account_test.Id;
        shipment_test2.Freight_Mode__c = 'Sea';
        shipment_test2.Service_Mode__c = 'Import';
        shipment_test2.Only_Warehouse_Service__c = true;
        insert shipment_test2;
        
        quote_test2.Last_Shipment__c = shipment_test.Id;
        update quote_test2;
        
        List<Shipment_Fee_Line__c> lstUpd = new List<Shipment_Fee_Line__c>();
        
        Shipment_Fee_Line__c sfl = new Shipment_Fee_Line__c();
        sfl.Shipment__c = shipment_test.Id;
        sfl.Name = '001';
        lstUpd.add(sfl);
        
        Shipment_Fee_Line__c sfl2 = new Shipment_Fee_Line__c();
        sfl2.Shipment__c = shipment_test2.Id;
        sfl2.Name = '001';
        lstUpd.add(sfl2);
        Shipment_Fee_Line__c sfl3 = new Shipment_Fee_Line__c();
        sfl3.Shipment__c = shipment_test2.Id;
        sfl3.Name = '002';
        lstUpd.add(sfl3);
        
        insert lstUpd;
        
        /*delete sfl3;
        
        sfl2.Name = '004';
        update sfl2;*/
        
        Cifid_SendShipLines.Test();
    }
    
    private static testMethod void updateQuotePak(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Customer_Quote__c quote_test = new Customer_Quote__c();
        quote_test.Account_for__c = account_test.Id;
        quote_test.Freight_Mode__c = 'Air';
        quote_test.Service_Mode__c = 'Import'; 
        quote_test.Service_Type__c = 'LCL Cargo';
        quote_test.Move_Type__c = 'Door to Door';
        quote_test.Origin_Address__c = 'Address Test'; 
        quote_test.Destination_Address__c = 'Address Test';
        quote_test.Impak_Request__c = true;
        insert quote_test;
        
        PAK_ImpkQuote.Quote q = new PAK_ImpkQuote.Quote();
        q.quoteName = quote_test.Name;
        q.pricing = 'Pricing tst';
        q.datePricingResponse = System.today();
        
        PAK_ImpkQuote.updateQuote(q);
        
        Customer_Quote__c quote = [SELECT Name FROM Customer_Quote__c WHERE Id =:quote_test.Id LIMIT 1];
        
        q.quoteName = quote.Name;
        PAK_ImpkQuote.updateQuote(q);        
    }
    
    private static testMethod void sendUpdateCifidQuote(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Customer_Quote__c quote_test = new Customer_Quote__c();
        quote_test.Account_for__c = account_test.Id;
        quote_test.Freight_Mode__c = 'Air';
        quote_test.Service_Mode__c = 'Import'; 
        quote_test.Service_Type__c = 'LCL Cargo';
        quote_test.Move_Type__c = 'Door to Door';
        quote_test.Origin_Address__c = 'Address Test'; 
        quote_test.Destination_Address__c = 'Address Test';
        quote_test.IMPAK__c = 'Si';
        insert quote_test;
        
        quote_test.Origin_Address__c = 'Address Test upd'; 
        quote_test.ETD__c = system.today();
        update quote_test;
        
        PAK_SendQuoteCifid.Test();
    }
    
    private static testMethod void sendCargoLines(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
        
        Customer_Quote__c quote_test = new Customer_Quote__c();
        quote_test.Account_for__c = account_test.Id;
        quote_test.Freight_Mode__c = 'Air';
        quote_test.Service_Mode__c = 'Import'; 
        quote_test.Service_Type__c = 'LCL Cargo';
        quote_test.Move_Type__c = 'Door to Door';
        quote_test.Origin_Address__c = 'Address Test'; 
        quote_test.Destination_Address__c = 'Address Test';
        quote_test.IMPAK__c = 'Si';
        insert quote_test;
        
        Sourcing_Item__c item =  new Sourcing_Item__c();
        item.Name = 'item tst';
        item.Account_Owner__c = account_test.Id;
        insert item;
        
        Quote_Item_Line__c ql = new Quote_Item_Line__c();
        ql.Name = 'tst1';
        ql.Item_Name__c = item.Id;
        ql.Units__c = 1;
        ql.Total_Shipping_Weight_Kgs__c = 20;
        ql.Total_Shipping_Volume_m3__c = 10;
        ql.Margin_at_Destination__c = 2;
        ql.Import_Export_Quote__c = quote_test.Id;
        insert ql;
        System.debug('QuoteLineId: ' + ql.Id);
        
        ql.Units__c = 21;
        update ql;
        
        delete ql;
        
        PAK_SendCargoLines.Test();
    }
    
    private static testMethod void serviceLinesCifid(){
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account acct = list_accounts[0];
        insert acct;
        
        Customer_Quote__c quote = new Customer_Quote__c();
        quote.Account_for__c = acct.Id;
        quote.Freight_Mode__c = 'Air';
        quote.Service_Mode__c = 'Import'; 
        quote.Service_Type__c = 'LCL Cargo';
        quote.Move_Type__c = 'Door to Door';
        quote.Origin_Address__c = 'Address Test'; 
        quote.Destination_Address__c = 'Address Test';
        insert quote;
        
        Customer_Quote__c quoteQ = [SELECT Id, Name FROM Customer_Quote__c WHERE Id =:quote.Id];
        
        List<Cifid_ServiceLines.ServiceLine> servLines = new List<Cifid_ServiceLines.ServiceLine>();
        
        Cifid_ServiceLines.ServiceLine l1 = new Cifid_ServiceLines.ServiceLine();
        l1.name = '001';
        l1.rateName = 'Rate Name Test';
        l1.units = 1;
        l1.quoteSellPrice = 20;
        l1.buyPrice = 10;
        l1.idLine = 'idLine001';
        servLines.add(l1);
        
        Cifid_ServiceLines.Quote q = new Cifid_ServiceLines.Quote();
        q.quoteName = quoteQ.Name;
        q.operation = 1;
        q.lines = servLines;
        
        System.debug('Insert: ' + Cifid_ServiceLines.serviceLines(q));
        
        servLines[0].units = 2;
        q.operation = 2;
        System.debug('Update: ' + Cifid_ServiceLines.serviceLines(q));
        
        q.operation = 3;
        System.debug('Delete: ' + Cifid_ServiceLines.serviceLines(q));
    }
}