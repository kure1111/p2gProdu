@isTest
private class NEU_test_Traxon {
    static testMethod void test_NEU_ChampEmail()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        NEU_ChampEmail.eventData e1=new NEU_ChampEmail.eventData();
        NEU_ChampEmail.eventData e2=new NEU_ChampEmail.eventData();
        e1.compareTo(e2);
        e1.myDateTime=system.now();
        e1.compareTo(e2);
        e1.myDateTime=null;
        e2.myDateTime=system.now();
        e1.compareTo(e2);
        e1.myDateTime=e2.myDateTime.addDays(1);
        e1.compareTo(e2);
        e2.myDateTime=e1.myDateTime.addDays(1);
        e1.compareTo(e2);

        NEU_ChampEmail ce = new NEU_ChampEmail();
        Messaging.InboundEmail  mail = new Messaging.InboundEmail();
        mail.subject ='test'; 
        List<String> new_address = new List<String>();
        new_address.add('test');
        new_address.add('test2');
        mail.toAddresses = new_address;
        mail.fromAddress = 'test@neurored.com';
        mail.plainTextBody='DDD';
        ce.handleInboundEmail(mail, null);

        mail.fromAddress = 'test@test.neurored.com';
        mail.plainTextBody='DDD\r\nDDD\r\nDDD';
        ce.handleInboundEmail(mail, null);

        mail.plainTextBody='+CIMFSA:A+\r\nDDD\r\nDDD';
        ce.handleInboundEmail(mail, null);

        mail.plainTextBody='+CIMFSA:7+\r\nDDD\r\nDDD';
        ce.handleInboundEmail(mail, null);

        mail.plainTextBody='+CIMFSA:15+\r\nDDD\r\nDDD';
        ce.handleInboundEmail(mail, null);

        mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/\r\nDDD';
        ce.handleInboundEmail(mail, null);

        mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/\r\nRCS/01XXX000/DDD';
        ce.handleInboundEmail(mail, null);

        mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/\r\nRCS/DDJAN0000/DDD';
        ce.handleInboundEmail(mail, null);

        mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/\r\nDEP/FLNUM/01JA/DDDDDD/S0101-X/0101';
        ce.handleInboundEmail(mail, null);

        mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/T1L23\r\nDEP/FLNUM/01JAN/DDDDDD/S010/0101';
        ce.handleInboundEmail(mail, null);

        mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/T1K23';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-P/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-N/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-S/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-T/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-A/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-B/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-C/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-D/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-E/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-F/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-G/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-H/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-I/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-J/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-K/0101';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-L/0101';
        ce.handleInboundEmail(mail, null);

        mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/\r\nRCS/01XXX0000/DDD';
        ce.handleInboundEmail(mail, null);

        mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/\r\nRCS/01DEC0000/DDD';
        ce.handleInboundEmail(mail, null);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        insert a;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Air', Service_Mode__c ='Import',MAWB_Number__c='012345678901', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10',MAWB_Number__c='012345678901');
        insert ship_prog;

        mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/';
        mail.plainTextBody+='\r\nRCS/01JAN0000/DDD/T1K23';
        mail.plainTextBody+='\r\nRCS/01JAN0000/DDD/T1L23/DDD';
        mail.plainTextBody+='\r\nRCT/DD/01JAN0000/DDD/T1/DDD/DDD';
        mail.plainTextBody+='\r\nRCF/FLNUM/01JAN0000/DDD/T1';
        mail.plainTextBody+='\r\nBKD/FLNUM/01JAN/DDDDDD/T1';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/T1';
        mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/T1/S0101-X';
        mail.plainTextBody+='\r\nDEP/FLNUM/01JAN/DDDDDD/T1';
        mail.plainTextBody+='\r\nDEP/FLNUM/01JAN/DDDDDD/T1/S0101-X';
        mail.plainTextBody+='\r\nPRE/FLNUM/01JAN/DDDDDD/T1';
        mail.plainTextBody+='\r\nPRE/FLNUM/01JAN/DDDDDD/T1/S0101-X';
        mail.plainTextBody+='\r\nTFD/DD/01JAN0000/DDD/T1/DDD/DDD/DDD';
        mail.plainTextBody+='\r\nNFD/01JAN0000/DDD/T1/DDD';
        mail.plainTextBody+='\r\nAWD/01JAN0000/DDD/T1/DDD';
        mail.plainTextBody+='\r\nCCD/01JAN0000/DDD/T1';
        mail.plainTextBody+='\r\nDLV/01JAN0000/DDD/T1/DDD';
        mail.plainTextBody+='\r\nDIS/FLNUM/01JAN0000/DDD/DDD/T1';
        mail.plainTextBody+='\r\nCRC/01JAN0000/DDD/T1/FLNUM';
        mail.plainTextBody+='\r\nDDL/01JAN0000/DDD/T1/DDD';
        mail.plainTextBody+='\r\nTGC/01JAN0000/DDD/T1';
        mail.plainTextBody+='\r\nARR/FLNUM/01JAN0000/DDD/T1';
        mail.plainTextBody+='\r\nAWR/FLNUM/01JAN0000/DDD/T1';
        mail.plainTextBody+='\r\nFOH/01JAN0000/DDD/T1/DDD';
        ce.handleInboundEmail(mail, null);

    }

    static testMethod void NEU_Traxon_FSR_errData()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account b = list_accounts[0];
        insert b;
        Account a = list_accounts[1];
        insert a;
        Country__c Country = new Country__c(Name='test');
        insert Country;
        Location__c location = new Location__c(Name='test', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert location;
        Shipment__c ship = new Shipment__c(Account_for__c = b.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        NEU_Traxon_FSR t=new NEU_Traxon_FSR(new ApexPages.StandardController(ship));
        t.sendToTraxon();
        ship.Carrier__c=a.id;
        t.sendToTraxon();
    }
    static testMethod void NEU_Traxon_FSR()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account b = list_accounts[0];
        insert b;
        Account a = list_accounts[1];
        a.PIMA_Address__c='PIMA';
        insert a;
        Country__c Country = new Country__c(Name='test');
        insert Country;
        Location__c location = new Location__c(Name='test', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC', IATA_Code__c = 'ABC');
        insert location;
        Shipment__c ship = new Shipment__c(Account_for__c = b.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Country_of_Load__c = Country.Id, Country_of_Discharge__c = Country.Id, Site_of_Load__c = location.Id, Site_of_Discharge__c = location.Id, Only_Warehouse_Service__c = true);
        ship.Carrier__c=a.id;
        ship.MAWB_Number__c='TEST';
        insert ship;
        NEU_Traxon_FSR t=new NEU_Traxon_FSR(new ApexPages.StandardController(NEU_Utils.populate(NEU_Traxon_FSR.usedFields,'Shipment__c',ship.Id)));
        t.sendToTraxon();
        t.cancel();
    }
    /*static testMethod void NEU_Traxon_FSR_SP_errData()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account b = list_accounts[0];
        insert b;
        Account a = list_accounts[1];
        insert a;
        Country__c Country = new Country__c(Name='test');
        insert Country;
        Location__c location = new Location__c(Name='test', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC');
        insert location;
        Shipment_Program__c ship = new Shipment_Program__c(Freight_Mode__c='Sea');
        insert ship;
        NEU_Traxon_FSR_SP t=new NEU_Traxon_FSR_SP(new ApexPages.StandardController(ship));
        t.sendToTraxon();
    }
    static testMethod void NEU_Traxon_FSR_SP()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Transporter,');
        Account b = list_accounts[0];
        insert b;
        Account a = list_accounts[1];
        a.Airline_Prefix__c='000';
        a.PIMA_Address__c='PIMA';
        insert a;
        Shipment_Program__c ship = new Shipment_Program__c(Freight_Mode__c='Sea');
        ship.MAWB_Number__c='000-0123456';
        insert ship;
        NEU_Traxon_FSR_SP t=new NEU_Traxon_FSR_SP(new ApexPages.StandardController(NEU_Utils.populate(NEU_Traxon_FSR_SP.usedFields,'Shipment_Program__c',ship.Id)));
        t.sendToTraxon();
        t.cancel();
    }*/
    
    static testMethod void NEU_Traxon_Waybill_Status()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);

        Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;

        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
        air_waybill_test.Prepaid_Collect_House_Other__c = 'Prepaid';
        air_waybill_test.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';
        
        insert air_waybill_test;
    	
    	NEU_Traxon_Waybill_Status tws = new NEU_Traxon_Waybill_Status(new ApexPages.StandardController(air_waybill_test));
    }
    
    static testMethod void NEU_Waybill_Steps()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
    	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
    	
    	Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
        air_waybill_test.Prepaid_Collect_House_Other__c = 'Prepaid';
        air_waybill_test.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';
        insert air_waybill_test;
        
        NEU_Waybill_Steps tws = new NEU_Waybill_Steps(new ApexPages.StandardController(air_waybill_test));
        
        Associated_Document__c associated_document_test_1 = new Associated_Document__c();
        associated_document_test_1.Air_Waybill__c = air_waybill_test.Id;
        associated_document_test_1.Account__c = account_test.Id;
        associated_document_test_1.Name = 'Master Waybill';
        insert associated_document_test_1;
        
        Associated_Document__c associated_document_test_2 = new Associated_Document__c();
        associated_document_test_2.Air_Waybill__c = air_waybill_test.Id;
        associated_document_test_2.Account__c = account_test.Id;
        associated_document_test_2.Name = 'House Waybill';
        insert associated_document_test_2;
        
        Associated_Document__c associated_document_test_3 = new Associated_Document__c();
        associated_document_test_3.Air_Waybill__c = air_waybill_test.Id;
        associated_document_test_3.Account__c = account_test.Id;
        associated_document_test_3.Name = 'Manifest';
        insert associated_document_test_3;
        
        Associated_Document__c associated_document_test_4 = new Associated_Document__c();
        associated_document_test_4.Air_Waybill__c = air_waybill_test.Id;
        associated_document_test_4.Account__c = account_test.Id;
        associated_document_test_4.Name = 'Master Label';
        insert associated_document_test_4;
        
        Associated_Document__c associated_document_test_5 = new Associated_Document__c();
        associated_document_test_5.Air_Waybill__c = air_waybill_test.Id;
        associated_document_test_5.Account__c = account_test.Id;
        associated_document_test_5.Name = 'House Label';
        insert associated_document_test_5;
        
        Log__c mail_log_test_1 = new Log__c();
        mail_log_test_1.Subject__c = 'FWB:';
        mail_log_test_1.Body__c = '-Test';
        insert mail_log_test_1;
        
        Log__c mail_log_test_2 = new Log__c();
        mail_log_test_2.Subject__c = 'FHL:';
        mail_log_test_2.Body__c = '-Test';
        insert mail_log_test_2;
        
        NEU_Waybill_Steps ws = new NEU_Waybill_Steps(new ApexPages.StandardController(air_waybill_test));
    }
    
    static testMethod void NEU_Air_Waybill_Recalculate()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
    	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        insert account_test;
    	
    	Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
        air_waybill_test.Prepaid_Collect_House_Other__c = 'Prepaid';        
        air_waybill_test.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';
        
        insert air_waybill_test;
        
        Air_Waybill_Line__c air_waybill_line_test = new Air_Waybill_Line__c();
        air_waybill_line_test.Name = '001';
        air_waybill_line_test.Air_Waybill__c = air_waybill_test.Id;
        insert air_waybill_line_test;
        
        Waybill_Other_Charge__c waybill_other_charge_test_1 = new Waybill_Other_Charge__c();
        waybill_other_charge_test_1.Waybill__c = air_waybill_test.Id;
        insert waybill_other_charge_test_1;
        
        Waybill_Other_Charge__c waybill_other_charge_test_2 = new Waybill_Other_Charge__c();
        waybill_other_charge_test_2.Waybill__c = air_waybill_test.Id;
        waybill_other_charge_test_2.Other_Charge_Rate__c = 0;
        insert waybill_other_charge_test_2;
        
        NEU_Air_Waybill_Recalculate awr = new NEU_Air_Waybill_Recalculate(new ApexPages.StandardController(air_waybill_test));
        awr.recalculate();
    }
    
    static testMethod void NEU_Traxon_FHL_errData()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
		Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        insert b;
		Account a = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId(),Business_Area__c = 'Sales',Airline_Prefix__c='');
		insert a;
        Country__c Country = new Country__c(Name='test',  ISO_Code_2c__c='EU');
        insert Country;
        Location__c location = new Location__c(Name='test', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',IATA_Code__c='XXX');
        insert location;
        Customer_Quote__c importexportquoteR = new Customer_Quote__c(Account_for__c = b.Id, Quotation_Status__c='Quote being prepared', Only_Warehouse_Service__c = true);
        insert importexportquoteR; 
        Shipment__c ship = new Shipment__c(Account_for__c = b.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Service_Type__c='LCL Cargo');
        insert ship;
        Shipment_Line__c sl = new Shipment_Line__c(Shipment__c = ship.id, Name = 'lineas items');
	    insert sl;
        Waybill_Master__c waybill_master = new Waybill_Master__c(Airline__c = a.Id);
        insert waybill_master;
     	Air_Waybill__c waybill = new Air_Waybill__c(Shipment__c = ship.Id);
     	waybill.Waybill_Master__c=waybill_master.Id;
     	waybill.Prepaid_Collect_WT_VAL__c = 'Prepaid';
     	waybill.Prepaid_Collect_House_Other__c = 'Prepaid';
        waybill.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';
     	insert waybill;
     	
     	NEU_Traxon_FHL t=new NEU_Traxon_FHL(new ApexPages.StandardController(waybill));
        t.sendToTraxon();
        
        waybill.Carrier_Account__c=a.id;
        waybill.Airport_of_Departure__c=location.id;
        waybill.Site_of_Destination__c=location.id;
        waybill.Shipper_Account__c=a.id;
        waybill.Consignee_Account__c=a.id;
        waybill.Carriers_Agent_Account__c=a.id;    
        t.sendToTraxon();
        
        waybill.By_First_Carrier_Account__c=a.id;
        waybill.Enable_Shipper_Alternative_Address__c=true;      
        waybill.Enable_Consignee_Alternative_Address__c=true;
        t.sendToTraxon();
          
        List<Air_Waybill_Line__c> lineas = new List<Air_Waybill_Line__c>();
	    Air_Waybill_Line__c line = new Air_Waybill_Line__c();
	    line.Air_Waybill__c = waybill.Id;
	    line.Shipment__c = ship.Id;
	    line.Shipment_Cargo_Line__c = sl.Id;
	    line.Commodity_Item_No__c = 5823;
	    line.Kg_Lb__c = 'K';
	    lineas.add(line);
	    insert lineas;	
	    t=new NEU_Traxon_FHL(new ApexPages.StandardController(NEU_Utils.populate(NEU_Traxon_FHL.usedFields,'Air_Waybill__c',waybill.Id)));   
        t.sendToTraxon();
    }
    
    static testMethod void NEU_Traxon_FHL()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
		Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        insert b;
		Account a = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId(),Business_Area__c = 'Sales');
		a.PIMA_Address__c='PIMA';
		//a.IATA_Code__c='IAT';
		a.Airline_Prefix__c='AC';
		a.Airline_Code_Number__c='ACN';
		a.BillingStreet='test';
		a.BillingCity='test';
		a.BillingCountry='test';
        insert a;
        Country__c Country = new Country__c(Name='test',  ISO_Code_2c__c='EU', ISO_Code__c='EUE');
        insert Country;
        Location__c location = new Location__c(Name='test', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',IATA_Code__c='XXX');
        insert location;
        Customer_Quote__c importexportquoteR = new Customer_Quote__c(Account_for__c = b.Id, Quotation_Status__c='Quote being prepared', Only_Warehouse_Service__c = true);
        insert importexportquoteR;
        Shipment__c ship = new Shipment__c(Account_for__c = b.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Service_Type__c='LCL Cargo');
        insert ship;
        Shipment_Line__c sl = new Shipment_Line__c(Shipment__c = ship.id, Name = 'lineas items');
	    insert sl;
        Waybill_Master__c waybill_master = new Waybill_Master__c(Airline__c = a.Id);
        insert waybill_master;
     	Air_Waybill__c waybill = new Air_Waybill__c(Shipment__c = ship.Id);
        waybill.Carrier_Account__c=a.id;
        waybill.Serial_Number__c='4';
        waybill.Country_of_Departure__c=country.id;
        waybill.Airport_of_Departure__c=location.id;
        waybill.Country_of_Destination__c=country.id;
        waybill.Site_of_Destination__c=location.id;
        waybill.Shipper_Account__c=a.id;
        waybill.Consignee_Account__c=a.id;
        waybill.Carriers_Agent_Account__c=a.id;
        waybill.Executed_on_date__c=system.today();
        waybill.at_place__c='test';
        waybill.Waybill_Master__c=waybill_master.Id;
        waybill.By_First_Carrier_Account__c=a.id;
        waybill.By_Second_Carrier_Account__c=a.id;
        waybill.By_Third_Carrier_Account__c=a.id;
        waybill.Enable_Shipper_Alternative_Address__c=true;
        waybill.Shipper_Alternative_Address__c='test';
        waybill.Shipper_Alternative_Country__c=country.id;
        waybill.Shipper_Alternative_Location__c=location.id;       
        waybill.Enable_Consignee_Alternative_Address__c=true;
        waybill.Consignee_Alternative_Account__c=a.Id;
        waybill.Consignee_Alternative_Address__c='test';
        waybill.Consignee_Alternative_Country__c=country.id;
        waybill.Consignee_Alternative_Location__c=location.id;
        waybill.Prepaid_Collect_Other__c='Collect';
        waybill.Prepaid_Collect_WT_VAL__c='Collect';
        waybill.Declared_Value_For_Carriage__c=100;
        waybill.Declared_Value_For_Customs__c=100;
        waybill.Amount_of_Insurance__c=100;
        waybill.Valuation_Charge__c=100;
        waybill.Tax__c=100;
        waybill.Total_Other_Charges_Due_Agent__c=100;
        waybill.Total_Other_Charges_Due__c=100;
        waybill.Shipper_s_Signature__c='TEST';
        waybill.Issuing_Carrier_s_Signature__c='TEST';
        waybill.Special_Customs_Information__c='TS';
        waybill.Handling_Information__c='Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex';
        waybill.Accounting_Information__c='Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex';
     	insert waybill;
     	Waybill_Consolidation__c conso = new Waybill_Consolidation__c(Name = 'EUR', Waybill__c = waybill.Id);
	    insert conso;
	    waybill.House_Reference__c=conso.Id;
	    update waybill;
     	Waybill_Other_Charge__c oc = new Waybill_Other_Charge__c(Charge_Amount__c = 100, Other_Charges__c = 'FA',Recipient_of_Charge_Amount__c = 'C', Waybill__c = waybill.Id);
	    insert oc;
     	
        List<Air_Waybill_Line__c> lineas = new List<Air_Waybill_Line__c>();

	    Air_Waybill_Line__c line = new Air_Waybill_Line__c();
	    line.Air_Waybill__c = waybill.Id;
	    line.Shipment__c = ship.Id;
	    line.Shipment_Cargo_Line__c = sl.Id;
	    line.Gross_Weight__c = 15;
	    line.RCP__c = 'AEF';
	    line.Kg_Lb__c = 'K';
	    line.Rate_Class__c = 'M — minimum charge ';
	    line.Commodity_Item_No__c = 5823;
	    line.No_of_Pieces__c = 45;
	    line.Description__c = 'test';
	    line.Rate_Charge__c = 1;
	    line.Nature_and_Quantity_of_Goods__c = '';
	    line.Length__c = 15;
	    line.Height__c = 15;
	    line.Width__c = 15;
	    line.Comments__c = 'Lorem ipsum dolor sit amet, co';
	    line.House_Reference__c=conso.Id;
	
	    lineas.add(line);
	    insert lineas;
        NEU_Traxon_FHL t=new NEU_Traxon_FHL(new ApexPages.StandardController(NEU_Utils.populate(NEU_Traxon_FHL.usedFields,'Air_Waybill__c',waybill.Id)));
        t.sendToTraxon();
        t.cancel();
    }
    
    public testMethod static void test_NEU_Traxon_TTTHistory()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
    	String jsonHistory = generaJSONHistory();
    	
		//Countries Load and Discharge				
		List<Country__c> list_Country = new List<Country__c>();
		Country__c test_country_L = new Country__c();
		test_country_L.Name= 'Test Country Load';
		list_Country.add(test_country_L);
		
		Country__c test_country_C = new Country__c();
		test_country_C.Name= 'Test Country Charge';
		list_Country.add(test_country_C);
		
		insert list_Country;
		
		//Locations load and discharge
		List<Location__c> list_port = new List<Location__c>();
		
		Location__c port_load = new Location__c();
		port_load.Country__c = test_country_L.Id;
		port_load.Name = 'Test Location Load';
		port_load.IATA_Code__c = 'AAA';
		port_load.UNLOCODE__c = 'Test unloc';
		port_load.Country__c = test_country_L.Id;
		
		Location__c port_discharge = new Location__c();
		port_discharge.Name = 'Test Location Discharge';
		port_discharge.IATA_Code__c = 'BBB';
		port_discharge.UNLOCODE__c = 'Test unloc';
		port_discharge.Country__c = test_country_C.Id;
		
		list_port.add(port_load);
		list_port.add(port_discharge);	

		insert list_port;		

		Account acc_test = new Account();
		acc_test.Name = 'Account Test Booker'; 
		acc_test.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		insert acc_test;
		
		Shipment__c test_shipment = new Shipment__c(Account_for__c=acc_test.Id, MAWB_Number__c='020-79209734', Only_Warehouse_Service__c = true);
		insert test_shipment;
		
		Event__c test_event = new Event__c(Shipment__c=test_shipment.Id);
		insert test_event;

		CSL_Credentials__c credentials = new CSL_Credentials__c();
		credentials.Name='Traxon';
		credentials.Login__c = 'testUser';
		credentials.Password__c = 'testPassword';
		credentials.Site__c = 'Http://www.prueba.com';
		
		insert credentials;
		
		
    	NEU_Traxon_TTTHistory neu_OSSP = new NEU_Traxon_TTTHistory(new ApexPages.StandardController(test_shipment));
    	neu_OSSP.respuestaHistory = NEU_Traxon_TTTHistory.parse(jsonHistory);
    	neu_OSSP.respuestaPlus = NEU_Traxon_TTTHistory.parse(jsonHistory);

    	//Peticiones de prueba
    	Test.startTest();
    	HTTPInttraMock mock = new HTTPInttraMock();
    	Test.setMock(HttpCalloutMock.class , mock);
		mock.tipo = 'history';
		neu_OSSP.sendToTraxon();
		neu_OSSP.cancel();
		mock.tipo = '401';
		neu_OSSP.sendToTraxon();
		Test.stopTest();
    }
    
    static testMethod void NEU_Traxon_FWB_errData()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
		Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        insert b;
		Account a = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId(),Business_Area__c = 'Sales',Airline_Prefix__c='');
		insert a;
        Country__c Country = new Country__c(Name='test',  ISO_Code_2c__c='EU');
        insert Country;
        Location__c location = new Location__c(Name='test', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',IATA_Code__c='XXX');
        insert location;
        Customer_Quote__c importexportquoteR = new Customer_Quote__c(Account_for__c = b.Id, Quotation_Status__c='Quote being prepared', Only_Warehouse_Service__c = true);
        insert importexportquoteR; 
        Shipment__c ship = new Shipment__c(Account_for__c = b.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Service_Type__c='LCL Cargo');
        insert ship;
        Shipment_Line__c sl = new Shipment_Line__c(Shipment__c = ship.id, Name = 'lineas items');
	    insert sl;
        Waybill_Master__c waybill_master = new Waybill_Master__c(Airline__c = a.Id);
        insert waybill_master;
     	Air_Waybill__c waybill = new Air_Waybill__c(Shipment__c = ship.Id);
     	waybill.Waybill_Master__c=waybill_master.Id;
     	waybill.Prepaid_Collect_WT_VAL__c = 'Prepaid';
      	waybill.Prepaid_Collect_House_Other__c = 'Prepaid';    	
        waybill.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';        
     	insert waybill;
     	
     	NEU_Traxon_FWB t=new NEU_Traxon_FWB(new ApexPages.StandardController(waybill));
        t.sendToTraxon();
        
        waybill.Carrier_Account__c=a.id;
        waybill.Airport_of_Departure__c=location.id;
        waybill.Site_of_Destination__c=location.id;
        waybill.Shipper_Account__c=a.id;
        waybill.Consignee_Account__c=a.id;
        waybill.Carriers_Agent_Account__c=a.id;    
        t.sendToTraxon();
        
        waybill.By_First_Carrier_Account__c=a.id;
        waybill.Enable_Shipper_Alternative_Address__c=true;      
        waybill.Enable_Consignee_Alternative_Address__c=true;
        t.sendToTraxon();
          
        List<Air_Waybill_Line__c> lineas = new List<Air_Waybill_Line__c>();
	    Air_Waybill_Line__c line = new Air_Waybill_Line__c();
	    line.Air_Waybill__c = waybill.Id;
	    line.Shipment__c = ship.Id;
	    line.Shipment_Cargo_Line__c = sl.Id;
	    line.Commodity_Item_No__c = 5823;
	    line.Kg_Lb__c = 'K';
	    lineas.add(line);
	    insert lineas;	
	    t=new NEU_Traxon_FWB(new ApexPages.StandardController(NEU_Utils.populate(NEU_Traxon_FWB.usedFields,'Air_Waybill__c',waybill.Id)));   
        t.sendToTraxon();
    }
    
    static testMethod void NEU_Traxon_FWB()
    {
    	NEU_StaticVariableHelper.setBoolean1(true);
    	
		Account b = new Account(Name = 'Test client', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        insert b;
		Account a = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId(),Business_Area__c = 'Sales');
		a.PIMA_Address__c='PIMA';
		a.IATA_Code__c='IAT';
		a.Airline_Prefix__c='AC';
		a.Airline_Code_Number__c='ACN';
		a.BillingStreet='test';
		a.BillingCity='test';
		a.BillingCountry='test';
        insert a;
        Country__c Country = new Country__c(Name='test',  ISO_Code_2c__c='EU', ISO_Code__c='EUE');
        insert Country;
        Location__c location = new Location__c(Name='test', City__c='test city', Country__c= country.Id, Subdivision__c='test subdivision', UNLOCODE__c='ABC',IATA_Code__c='XXX');
        insert location;
        Customer_Quote__c importexportquoteR = new Customer_Quote__c(Account_for__c = b.Id, Quotation_Status__c='Quote being prepared', Only_Warehouse_Service__c = true);
        insert importexportquoteR;
        Shipment__c ship = new Shipment__c(Account_for__c = b.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Service_Type__c='LCL Cargo');
        insert ship;
        Shipment_Line__c sl = new Shipment_Line__c(Shipment__c = ship.id, Name = 'lineas items');
	    insert sl;
        Waybill_Master__c waybill_master = new Waybill_Master__c(Airline__c = a.Id);
        insert waybill_master;
     	Air_Waybill__c waybill = new Air_Waybill__c(Shipment__c = ship.Id);
        waybill.Carrier_Account__c=a.id;
        waybill.Serial_Number__c='4';
        waybill.Country_of_Departure__c=country.id;
        waybill.Airport_of_Departure__c=location.id;
        waybill.Country_of_Destination__c=country.id;
        waybill.Site_of_Destination__c=location.id;
        waybill.Shipper_Account__c=a.id;
        waybill.Consignee_Account__c=a.id;
        waybill.Carriers_Agent_Account__c=a.id;
        waybill.Executed_on_date__c=system.today();
        waybill.at_place__c='test';
        waybill.Waybill_Master__c=waybill_master.Id;
        waybill.By_First_Carrier_Account__c=a.id;
        waybill.By_Second_Carrier_Account__c=a.id;
        waybill.By_Third_Carrier_Account__c=a.id;
        waybill.Enable_Shipper_Alternative_Address__c=true;
        waybill.Shipper_Alternative_Address__c='test';
        waybill.Shipper_Alternative_Country__c=country.id;
        waybill.Shipper_Alternative_Location__c=location.id;       
        waybill.Enable_Consignee_Alternative_Address__c=true;
        waybill.Consignee_Alternative_Account__c=a.Id;
        waybill.Consignee_Alternative_Address__c='test';
        waybill.Consignee_Alternative_Country__c=country.id;
        waybill.Consignee_Alternative_Location__c=location.id;
        waybill.Prepaid_Collect_Other__c='Collect';
        waybill.Prepaid_Collect_WT_VAL__c='Collect';
        waybill.Declared_Value_For_Carriage__c=100;
        waybill.Declared_Value_For_Customs__c=100;
        waybill.Amount_of_Insurance__c=100;
        waybill.Valuation_Charge__c=100;
        waybill.Tax__c=100;
        waybill.Total_Other_Charges_Due_Agent__c=100;
        waybill.Total_Other_Charges_Due__c=100;
        waybill.Shipper_s_Signature__c='TEST';
        waybill.Issuing_Carrier_s_Signature__c='TEST';
        waybill.Special_Customs_Information__c='TS';
        waybill.Handling_Information__c='Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex';
        waybill.Accounting_Information__c='Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex';
     	insert waybill;
     	Waybill_Consolidation__c conso = new Waybill_Consolidation__c(Name = 'EUR', Waybill__c = waybill.Id);
	    insert conso;
	    waybill.House_Reference__c=conso.Id;
	    update waybill;
     	Waybill_Other_Charge__c oc = new Waybill_Other_Charge__c(Charge_Amount__c = 100, Other_Charges__c = 'FA',Recipient_of_Charge_Amount__c = 'C', Waybill__c = waybill.Id);
	    insert oc;
     	
        List<Air_Waybill_Line__c> lineas = new List<Air_Waybill_Line__c>();

	    Air_Waybill_Line__c line = new Air_Waybill_Line__c();
	    line.Air_Waybill__c = waybill.Id;
	    line.Shipment__c = ship.Id;
	    line.Shipment_Cargo_Line__c = sl.Id;
	    line.Gross_Weight__c = 15;
	    line.RCP__c = 'AEF';
	    line.Kg_Lb__c = 'K';
	    line.Rate_Class__c = 'M — minimum charge ';
	    line.Commodity_Item_No__c = 5823;
	    line.No_of_Pieces__c = 45;
	    line.Chargeable_Weight__c = 12;
	    line.Description__c = 'test';
	    line.Rate_Charge__c = 1;
	    //line.Total_Service_Charge__c = 250;
	    line.Nature_and_Quantity_of_Goods__c = '';
	    line.Length__c = 15;
	    line.Height__c = 15;
	    line.Width__c = 15;
	    //line.Total_Volume_m3__c = 15;
	    line.Comments__c = 'Lorem ipsum dolor sit amet, co';
	    line.House_Reference__c=conso.Id;
	
	    lineas.add(line);
	    insert lineas;
        NEU_Traxon_FWB t=new NEU_Traxon_FWB(new ApexPages.StandardController(NEU_Utils.populate(NEU_Traxon_FWB.usedFields,'Air_Waybill__c',waybill.Id)));
        t.sendToTraxon();
        t.cancel();
    }
    
    //Método de prueba para falsear las llamadas HTTPRequest
    public class HTTPInttraMock implements HttpCalloutMock
    {
    	public String tipo;
    	
    	public System.HttpResponse respond(System.HttpRequest request)
    	{
    		if (tipo.equalsIgnoreCase('history'))
    		{
    			HttpResponse res = new HttpResponse();
				res.setHeader('Content-Type', 'application/json');
				res.setBody(generaJSONHistory());
				res.setStatusCode(200);
				return res;
    		}
    		
    		if(tipo.equalsIgnoreCase('401'))
    		{
    			HttpResponse res = new HttpResponse();
				res.setHeader('Content-Type', 'application/json');
				res.setBody(generaJSONHistory());
				res.setStatusCode(401);
				return res;
    		}
    		return null;
    	}
    }
    
    public static String generaJSONHistory()
    {
		return '{'+
			    '"flightHistory": {'+
			    	'"prueba": "020-79209734",'+
			        '"airWaybillNumber": "020-79209734",'+
			        '"consignments": ['+
			            '{'+
			                '"originAndDestination": {'+
			                    '"origin": "MEX",'+
			                    '"prueba": "MEX",'+
			                    '"destination": "AMS"'+
			                '},'+
			                '"quantity": {'+
			                    '"shipmentDescriptionCode": "TOTAL_CONSIGNMENT",'+
			                    '"prueba": "TOTAL_CONSIGNMENT",'+
			                    '"numberOfPieces": 1,'+
			                    '"weight": {'+
			                        '"amount": 4.4,'+
			                        '"prueba": 4.4,'+
			                        '"unit": "KILOGRAM"'+
			                    '}'+
			                '},'+
			                '"totalNumberOfPieces": 1,'+
			                '"prueba": 1,'+
			                '"events": ['+
			                    '{'+
			                        '"type": "received from shipper",'+
			                        '"numberOfPieces": 1,'+
			                        '"weight": {'+
			                            '"amount": 4.4,'+
			                            '"unit": "KILOGRAM"'+
			                        '},'+
			                        '"timeOfEvent": "2018-05-24T16:24:00",'+
			                        '"dateOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledArrival": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                        '"airportOfReceipt": "MEX",'+
			                        '"origin": "MEX",'+
			                        '"receivedFromName": "EMB",'+
			                        '"airportOfNotification": "EMB",'+
			                        '"airportOfDelivery": "EMB",'+
			                        '"prueba": "EMB",'+
			                        '"notificationToName": "EMB"'+
			                    '},'+
			                    '{'+
			                        '"type": "booked",'+
			                        '"numberOfPieces": 1,'+
			                        '"weight": {'+
			                            '"amount": 4.4,'+
			                            '"unit": "KILOGRAM"'+
			                        '},'+
			                        '"timeOfEvent": "2018-05-24T16:24:00",'+
			                        '"dateOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledArrival": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                        '"airportOfReceipt": "MEX",'+
			                        '"origin": "MEX",'+
			                        '"receivedFromName": "EMB",'+
			                        '"airportOfNotification": "EMB",'+
			                        '"airportOfDelivery": "EMB",'+
			                        '"notificationToName": "EMB"'+
			                    '},'+
			                    '{'+
			                        '"type": "manifested",'+
			                        '"numberOfPieces": 1,'+
			                        '"weight": {'+
			                            '"amount": 4.4,'+
			                            '"unit": "KILOGRAM"'+
			                        '},'+
			                        '"timeOfEvent": "2018-05-24T16:24:00",'+
			                        '"dateOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledArrival": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                        '"airportOfReceipt": "MEX",'+
			                        '"origin": "MEX",'+
			                        '"receivedFromName": "EMB",'+
			                        '"airportOfNotification": "EMB",'+
			                        '"airportOfDelivery": "EMB",'+
			                        '"notificationToName": "EMB"'+
			                    '},'+
			                    '{'+
			                        '"type": "departed",'+
			                        '"numberOfPieces": 1,'+
			                        '"weight": {'+
			                            '"amount": 4.4,'+
			                            '"unit": "KILOGRAM"'+
			                        '},'+
			                        '"timeOfEvent": "2018-05-24T16:24:00",'+
			                        '"dateOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledArrival": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                        '"airportOfReceipt": "MEX",'+
			                        '"origin": "MEX",'+
			                        '"receivedFromName": "EMB",'+
			                        '"airportOfNotification": "EMB",'+
			                        '"airportOfDelivery": "EMB",'+
			                        '"notificationToName": "EMB"'+
			                    '},'+
			                    '{'+
			                        '"type": "received from flight",'+
			                        '"numberOfPieces": 1,'+
			                        '"weight": {'+
			                            '"amount": 4.4,'+
			                            '"unit": "KILOGRAM"'+
			                        '},'+
			                        '"timeOfEvent": "2018-05-24T16:24:00",'+
			                        '"dateOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledArrival": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                        '"airportOfReceipt": "MEX",'+
			                        '"origin": "MEX",'+
			                        '"receivedFromName": "EMB",'+
			                        '"airportOfNotification": "EMB",'+
			                        '"airportOfDelivery": "EMB",'+
			                        '"notificationToName": "EMB"'+
			                    '},'+
			                    '{'+
			                        '"type": "consignee notified",'+
			                        '"numberOfPieces": 1,'+
			                        '"weight": {'+
			                            '"amount": 4.4,'+
			                            '"unit": "KILOGRAM"'+
			                        '},'+
			                        '"timeOfEvent": "2018-05-24T16:24:00",'+
			                        '"dateOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledArrival": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                        '"airportOfReceipt": "MEX",'+
			                        '"origin": "MEX",'+
			                        '"flight": "LH4532",'+
			                        '"receivedFromName": "EMB",'+
			                        '"airportOfNotification": "EMB",'+
			                        '"airportOfDelivery": "EMB",'+
			                        '"notificationToName": "EMB"'+
			                    '},'+
			                    '{'+
			                        '"type": "arrival documentation delivered",'+
			                        '"numberOfPieces": 1,'+
			                        '"weight": {'+
			                            '"amount": 4.4,'+
			                            '"unit": "KILOGRAM"'+
			                        '},'+
			                        '"timeOfEvent": "2018-05-24T16:24:00",'+
			                        '"dateOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledArrival": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfEventTimePartQuality": "SUPPLIED"'+
			                    '},'+
			                    '{'+
			                        '"type": "delivered",'+
			                        '"numberOfPieces": 1,'+
			                        '"weight": {'+
			                            '"amount": 4.4,'+
			                            '"unit": "KILOGRAM"'+
			                        '},'+
			                        '"timeOfEvent": "2018-05-24T16:24:00",'+
			                        '"dateOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledArrival": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                        '"airportOfReceipt": "MEX",'+
			                        '"origin": "MEX",'+
			                        '"receivedFromName": "EMB",'+
			                        '"airportOfNotification": "EMB",'+
			                        '"airportOfDelivery": "EMB",'+
			                        '"notificationToName": "EMB"'+
			                    '},'+
			                    '{'+
			                        '"type": "arrived",'+
			                        '"numberOfPieces": 1,'+
			                        '"weight": {'+
			                            '"amount": 4.4,'+
			                            '"unit": "KILOGRAM"'+
			                        '},'+
			                        '"timeOfEvent": "2018-05-24T16:24:00",'+
			                        '"dateOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledArrival": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                        '"airportOfReceipt": "MEX",'+
			                        '"destination": "MEX",'+
			                        '"receivedFromName": "EMB",'+
			                        '"airportOfNotification": "EMB",'+
			                        '"airportOfDelivery": "EMB",'+
			                        '"notificationToName": "EMB"'+
			                    '},'+
			                    '{'+
			                        '"type": "arrival documentation received",'+
			                        '"numberOfPieces": 1,'+
			                        '"weight": {'+
			                            '"amount": 4.4,'+
			                            '"unit": "KILOGRAM"'+
			                        '},'+
			                        '"timeOfEvent": "2018-05-24T16:24:00",'+
			                        '"dateOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledArrival": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                        '"airportOfReceipt": "MEX",'+
			                        '"receivedFromName": "EMB",'+
			                        '"airportOfNotification": "EMB",'+
			                        '"airportOfDelivery": "EMB"'+
			                    '},'+
			                    '{'+
			                        '"type": "",'+
			                        '"numberOfPieces": 1,'+
			                        '"weight": {'+
			                            '"amount": 4.4,'+
			                            '"unit": "KILOGRAM"'+
			                        '},'+
			                        '"timeOfEvent": "2018-05-24T16:24:00",'+
			                        '"dateOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledArrival": "2018-05-24T16:24:00",'+
			                        '"timeOfScheduledDeparture": "2018-05-24T16:24:00",'+
			                        '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                        '"origin": "MEX",'+
			                        '"airportOfDelivery": "EMB",'+
			                        '"notificationToName": "EMB"'+
			                    '}'+
			                ']'+
			            '}'+
			        ']'+
			    '},'+
			    '"lastFlightStatus": {'+
			    	'"prueba": "020-79209734",'+
			        '"airWaybillNumber": "020-79209734",'+
			        '"originAndDestination": {'+
			            '"origin": "GDL",'+
			            '"destination": "KBP"'+
			        '},'+
			        '"quantity": {'+
			            '"shipmentDescriptionCode": "TOTAL_CONSIGNMENT",'+
			            '"numberOfPieces": 1,'+
			            '"weight": {'+
			                '"amount": 140,'+
			                '"unit": "KILOGRAM"'+
			            '}'+
			        '},'+
			        '"totalNumberOfPieces": 1,'+
			        '"events": ['+
			            '{'+
			                '"type": "received from flight",'+
			                '"numberOfPieces": 1,'+
			                '"weight": {'+
			                    '"amount": 140,'+
			                    '"unit": "KILOGRAM"'+
			                '},'+
			                '"timeOfEvent": "2018-05-27T00:00:00",'+
			                '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                '"flight": "LH2546",'+
			                '"dateOfScheduledArrival": "2018-05-27",'+
			                '"destination": "KBP",'+
			                '"ecefLongitude": 15.265,'+
			                '"ecefLatitude": 62.265'+
			            '},'+
			            '{'+
			                '"type": "received from flight",'+
			                '"numberOfPieces": 1,'+
			                '"weight": {'+
			                    '"amount": 140,'+
			                    '"unit": "KILOGRAM"'+
			                '},'+
			                '"timeOfEvent": "2018-05-27T00:00:00",'+
			                '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                '"flight": "LH2546",'+
			                '"dateOfScheduledArrival": "2018-05-27",'+
			                '"airportOfNotification": "EMB",'+
			                '"ecefLongitude": 15.265,'+
			                '"ecefLatitude": 62.265'+
			            '},'+
			            '{'+
			                '"type": "received from flight",'+
			                '"numberOfPieces": 1,'+
			                '"weight": {'+
			                    '"amount": 140,'+
			                    '"unit": "KILOGRAM"'+
			                '},'+
			                '"timeOfEvent": "2018-05-27T00:00:00",'+
			                '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                '"flight": "LH2546",'+
			                '"dateOfScheduledArrival": "2018-05-27",'+
			                '"airportOfDelivery": "EMB",'+
			                '"ecefLongitude": 15.265,'+
			                '"ecefLatitude": 62.265'+
			            '},'+
			            '{'+
			                '"type": "received from flight",'+
			                '"numberOfPieces": 1,'+
			                '"weight": {'+
			                    '"amount": 140,'+
			                    '"unit": "KILOGRAM"'+
			                '},'+
			                '"timeOfEvent": "2018-05-27T00:00:00",'+
			                '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                '"flight": "LH2546",'+
			                '"dateOfScheduledArrival": "2018-05-27",'+
			                '"airportOfReceipt": "EMB",'+
			                '"ecefLongitude": 15.265,'+
			                '"ecefLatitude": 62.265'+
			            '},'+
			            '{'+
			                '"type": "received from flight",'+
			                '"numberOfPieces": 1,'+
			                '"weight": {'+
			                    '"amount": 140,'+
			                    '"unit": "KILOGRAM"'+
			                '},'+
			                '"timeOfEvent": "2018-05-27T00:00:00",'+
			                '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                '"flight": "LH2546",'+
			                '"dateOfScheduledArrival": "2018-05-27",'+
			                '"origin": "EMB",'+
			                '"ecefLongitude": 15.265,'+
			                '"ecefLatitude": 62.265'+
			            '},'+
			            '{'+
			                '"type": "received from flight",'+
			                '"numberOfPieces": 1,'+
			                '"weight": {'+
			                    '"amount": 140,'+
			                    '"unit": "KILOGRAM"'+
			                '},'+
			                '"timeOfEvent": "2018-05-27T00:00:00",'+
			                '"timeOfEventTimePartQuality": "SUPPLIED",'+
			                '"flight": "LH2546",'+
			                '"dateOfScheduledArrival": "2018-05-27",'+
			                '"ecefLongitude": 15.265,'+
			                '"ecefLatitude": 62.265'+
			            '}'+
			        ']'+
			    '},'+
			    '"responseCode": "OK",'+
			    '"prueba": "OK"'+
			'}';
	}
	
	static testMethod void test_NEU_TRAXON_ChampEmail()
    {
    	NEU_Traxon_ChampEmail.eventData e1=new NEU_Traxon_ChampEmail.eventData();
    	NEU_Traxon_ChampEmail.eventData e2=new NEU_Traxon_ChampEmail.eventData();
    	e1.compareTo(e2);
    	e1.myDateTime=system.now();
    	e1.compareTo(e2);
    	e1.myDateTime=null;
    	e2.myDateTime=system.now();
    	e1.compareTo(e2);
    	e1.myDateTime=e2.myDateTime.addDays(1);
    	e1.compareTo(e2);
    	e2.myDateTime=e1.myDateTime.addDays(1);
    	e1.compareTo(e2);
    	
    	NEU_Traxon_ChampEmail ce = new NEU_Traxon_ChampEmail();
    	Messaging.InboundEmail  mail = new Messaging.InboundEmail();
    	mail.subject ='test'; 
    	List<String> new_address = new List<String>();
    	new_address.add('test');
    	new_address.add('test2');
    	mail.toAddresses = new_address;
    	mail.fromAddress = 'test@neurored.com';
    	mail.plainTextBody='DDD';
    	ce.handleInboundEmail(mail, null);

    	mail.fromAddress = 'test@test.neurored.com';
    	mail.plainTextBody='DDD\r\nDDD\r\nDDD';
    	ce.handleInboundEmail(mail, null);

    	mail.plainTextBody='+CIMFSA:A+\r\nDDD\r\nDDD';
    	ce.handleInboundEmail(mail, null);

    	mail.plainTextBody='+CIMFSA:7+\r\nDDD\r\nDDD';
    	ce.handleInboundEmail(mail, null);

    	mail.plainTextBody='+CIMFSA:15+\r\nDDD\r\nDDD';
    	ce.handleInboundEmail(mail, null);

    	mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/\r\nDDD';
    	ce.handleInboundEmail(mail, null);

    	mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/\r\nRCS/01XXX000/DDD';
    	ce.handleInboundEmail(mail, null);

    	mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/\r\nRCS/DDJAN0000/DDD';
    	ce.handleInboundEmail(mail, null);

    	mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/\r\nDEP/FLNUM/01JA/DDDDDD/S0101-X/0101';
    	ce.handleInboundEmail(mail, null);

    	mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/T1L23\r\nDEP/FLNUM/01JAN/DDDDDD/S010/0101';
    	ce.handleInboundEmail(mail, null);

    	mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/T1K23';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-P/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-N/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-S/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-T/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-A/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-B/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-C/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-D/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-E/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-F/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-G/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-H/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-I/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-J/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-K/0101';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/DDD/S0101-L/0101';
    	ce.handleInboundEmail(mail, null);

    	mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/\r\nRCS/01XXX0000/DDD';
    	ce.handleInboundEmail(mail, null);

    	mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/\r\nRCS/01DEC0000/DDD';
    	ce.handleInboundEmail(mail, null);

        Account a = new Account(Name = 'Test acount ', RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),Business_Area__c = 'Sales');
        insert a;  
        Customer_Quote__c importexportquoteR = new Customer_Quote__c(Account_for__c = a.Id, Quotation_Status__c='Quote being prepared', Only_Warehouse_Service__c = true);
        insert importexportquoteR; 
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Service_Type__c='LCL Cargo', MAWB_Number__c='');
        insert ship;
	    //Shipment_Program__c ship_prog = new Shipment_Program__c(Number_of_Containers__c =2, Flight_Number__c='10',MAWB_Number__c='012345678901');
	    //insert ship_prog; 

    	mail.plainTextBody='+CIMFSA:15+\r\n012345678901DDDDDD/';
    	mail.plainTextBody+='\r\nRCS/01JAN0000/DDD/T1K23';
    	mail.plainTextBody+='\r\nRCS/01JAN0000/DDD/T1L23/DDD';
    	mail.plainTextBody+='\r\nRCT/DD/01JAN0000/DDD/T1/DDD/DDD';
    	mail.plainTextBody+='\r\nRCF/FLNUM/01JAN0000/DDD/T1';
    	mail.plainTextBody+='\r\nBKD/FLNUM/01JAN/DDDDDD/T1';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/T1';
    	mail.plainTextBody+='\r\nMAN/FLNUM/01JAN/DDDDDD/T1/S0101-X';
    	mail.plainTextBody+='\r\nDEP/FLNUM/01JAN/DDDDDD/T1';
    	mail.plainTextBody+='\r\nDEP/FLNUM/01JAN/DDDDDD/T1/S0101-X';
    	mail.plainTextBody+='\r\nPRE/FLNUM/01JAN/DDDDDD/T1';
    	mail.plainTextBody+='\r\nPRE/FLNUM/01JAN/DDDDDD/T1/S0101-X';
    	mail.plainTextBody+='\r\nTFD/DD/01JAN0000/DDD/T1/DDD/DDD/DDD';
    	mail.plainTextBody+='\r\nNFD/01JAN0000/DDD/T1/DDD';
    	mail.plainTextBody+='\r\nAWD/01JAN0000/DDD/T1/DDD';
    	mail.plainTextBody+='\r\nCCD/01JAN0000/DDD/T1';
    	mail.plainTextBody+='\r\nDLV/01JAN0000/DDD/T1/DDD';
    	mail.plainTextBody+='\r\nDIS/FLNUM/01JAN0000/DDD/DDD/T1';
    	mail.plainTextBody+='\r\nCRC/01JAN0000/DDD/T1/FLNUM';
    	mail.plainTextBody+='\r\nDDL/01JAN0000/DDD/T1/DDD';
    	mail.plainTextBody+='\r\nTGC/01JAN0000/DDD/T1';
    	mail.plainTextBody+='\r\nARR/FLNUM/01JAN0000/DDD/T1';
    	mail.plainTextBody+='\r\nAWR/FLNUM/01JAN0000/DDD/T1';
    	mail.plainTextBody+='\r\nFOH/01JAN0000/DDD/T1/DDD';
    	ce.handleInboundEmail(mail, null);
    }
    
    public testMethod static void NEU_AWB_Report()
	{
		NEU_StaticVariableHelper.setBoolean1(true);
    	
    	List<Account> list_accounts = NEU_Utils.getAccounts('Transporter,');
        Account account_test = list_accounts[0];
        insert account_test;
    	
    	Waybill_Master__c waybill_master_test = new Waybill_Master__c();
        insert waybill_master_test;
        
        Air_Waybill__c air_waybill_test = new Air_Waybill__c();
        air_waybill_test.Waybill_Master__c = waybill_master_test.Id;
        air_waybill_test.Serial_Number__c = 'Test';
        air_waybill_test.Carrier_Account__c = account_test.Id;
        air_waybill_test.Prepaid_Collect_WT_VAL__c = 'Prepaid';
     	air_waybill_test.Prepaid_Collect_House_Other__c = 'Prepaid';        
        air_waybill_test.Prepaid_Collect_House_WT_VAL__c = 'Prepaid';
        
        insert air_waybill_test;
        
        NEU_Waybill_Steps tws = new NEU_Waybill_Steps(new ApexPages.StandardController(air_waybill_test));
        
        Log__c mail_log_test_1 = new Log__c();
        mail_log_test_1.Subject__c = 'FWB:';
        mail_log_test_1.Body__c = '\n+CIMFWB:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_1;
        
        Log__c mail_log_test_2 = new Log__c();
        mail_log_test_2.Subject__c = 'FWB:';
        mail_log_test_2.Body__c = '\n+CIMFMA:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_2;
        
        Log__c mail_log_test_3 = new Log__c();
        mail_log_test_3.Subject__c = 'FWB:';
        mail_log_test_3.Body__c = '\n+CIMFNA:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_3;
        
        Log__c mail_log_test_4 = new Log__c();
        mail_log_test_4.Subject__c = 'FWB:';
        mail_log_test_4.Body__c = '\n+CIMFSR:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_4;
        
        Log__c mail_log_test_5 = new Log__c();
        mail_log_test_5.Subject__c = 'FWB:';
        mail_log_test_5.Body__c = '\n+CIMFSA:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_5;
        
        Log__c mail_log_test_6 = new Log__c();
        mail_log_test_6.Subject__c = 'FWB:';
        mail_log_test_6.Body__c = '\n+CIMFSU:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_6;
        
        Log__c mail_log_test_7 = new Log__c();
        mail_log_test_7.Subject__c = 'FWB:';
        mail_log_test_7.Body__c = '\n+CIMFHL:17+180607112451021\'FWB/17:\nTEST/TEST\nTEST/TEST\nTEST/TEST\nTEST/TEST\n';
        insert mail_log_test_7;

		NEU_AWB_Report awbr = new NEU_AWB_Report();
		awbr.month = system.today().month();
		awbr.year = system.today().year();
		awbr.filter = air_waybill_test;
		awbr.search_AWB();
		
		NEU_AWB_Requests_Report awbrr = new NEU_AWB_Requests_Report();
		awbrr.month = system.today().month();
		awbrr.year = system.today().year();
		awbrr.search_AWB();
	} 
}