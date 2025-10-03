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
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-0001', Account_for__c = a.Id, Freight_Mode__c='Air', Service_Mode__c ='Import',MAWB_Number__c='012345678901', Only_Warehouse_Service__c = true);
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
		NEU_StaticVariableHelper.setBoolean1(true);
		User userT = [SELECT Id, ManagerId, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
		Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.UserRole.Name); // Director Comercial, Director Regional

		Customer_Quote__c importexportquoteR = new Customer_Quote__c();
		String recordTypeId = Schema.SObjectType.Customer_Quote__c.getRecordTypeInfosByName().get('Import-Export Quote').getRecordTypeId();
		importexportquoteR.RecordTypeId = recordTypeId;
		importexportquoteR.Name = '.';
		importexportquoteR.Account_for__c = a.Id;
		importexportquoteR.Team__c = 'P2G';
		importexportquoteR.Quotation_Status__c = 'Quote being prepared';
		importexportquoteR.Customer_Reference__c = 'hola soy una prueba';
		importexportquoteR.Valid_From__c = System.today();
		importexportquoteR.Valid_Until__c = System.today();
		importexportquoteR.Comercio_Exterior__c = 'No';
		importexportquoteR.Freight_Mode__c = 'Road';
		importexportquoteR.Service_Mode__c = 'NATIONAL';
		importexportquoteR.Service_Type__c = 'FTL';
		importexportquoteR.CurrencyIsoCode = 'MXN';
		importexportquoteR.ETD__c = Date.today();
		importexportquoteR.ETA__c = Date.today();
		importexportquoteR.Community_Status__c = 'CUSTOMER CREATED';
		importexportquoteR.Pricing_Executive__c = userT.Id;
		importexportquoteR.Operations_Exec__c = userT.Id;
		insert importexportquoteR;


        Shipment__c ship = new Shipment__c(Name = 'SP-TS-0009', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Service_Type__c='LCL Cargo', MAWB_Number__c='');
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
    
}