@isTest
private class NEU_test_AsyncOI {

    static testMethod void NEU_AsyncOI() {
		NEU_StaticVariableHelper.setBoolean1(true);

		NEU_AsyncOI a=new NEU_AsyncOI();
    	a.execute(null);
    }
    static testMethod void NEU_AsyncOIShipment() {
		NEU_StaticVariableHelper.setBoolean1(true);

        List<Account> list_accounts = NEU_Utils.getAccounts('Customer');
        Account a = list_accounts[0];
        insert a;
        Shipment__c s = new Shipment__c();
        s.Account_for__c = a.Id;
    	s.Name ='Test Shipment' ;
    	s.External_Reference_OI__c='12344';
    	s.Freight_Mode__c = 'Sea';
    	s.Service_Mode__c = 'Export';	
    	s.Service_Type__c = 'FTL';    	
        insert s;
        
        s = new Shipment__c();
        s.Account_for__c = a.Id;
        s.Name ='Test Shipment 2' ; 
    	s.External_Reference_OI__c='sh12345';
    	s.Freight_Mode__c = 'Sea';
    	s.Service_Mode__c = 'Export';	
    	s.Service_Type__c = 'FTL';   	
        insert s;
    	
    	Shipment_Program__c sp=new Shipment_Program__c();
    	sp.External_Reference_OI__c='12344';
    	insert sp;
    	update sp;
    	sp=new Shipment_Program__c();
    	sp.External_Reference_OI__c='sh12345';
    	insert sp;
    	update sp;
    	Set<String>shipments=new Set<String>();
    	shipments.add('12344');
    	shipments.add('sh12345');
    	NEU_AsyncOIShipment oi=new NEU_AsyncOIShipment(shipments);
    	oi.execute(null);
    	NEU_AsyncOIShipment.update_oi('sh12345');
    }
}