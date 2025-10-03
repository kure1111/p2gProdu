@isTest
public class P2G_NEU_Ground_Track_TraceTest {
    
    @isTest
    public static void testNEU_Ground_Track_Trace()
    {
        NEU_StaticVariableHelper.setBoolean1(true);
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //insert a;
        Account a= new Account();
        a.Name='Test';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        a.OwnerId=UserInfo.getUserId();        	
        insert a;
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00047', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_Stop_B__c  = a.Id,
                                           Account_Stop_C__c = a.Id, Origin_Address__c ='test origin address', Destination_Address__c ='test destination address', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment__c ship2 = new Shipment__c(Name = 'SP-TS-00048', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import',
                                            Account_Stop_C__c = a.Id, Origin_Address__c ='test origin address', Destination_Address__c ='test destination address', Only_Warehouse_Service__c = true);
        insert ship2;
        Shipment__c ship3 = new Shipment__c(Name = 'SP-TS-00049', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_Stop_B__c  = a.Id,
                                            Origin_Address__c ='test origin address', Destination_Address__c ='test destination address', Only_Warehouse_Service__c = true);
        insert ship3;
        NEU_Ground_Track_Trace gtt = new NEU_Ground_Track_Trace(new ApexPages.StandardController( ship ));
        NEU_Ground_Track_Trace gtt2 = new NEU_Ground_Track_Trace(new ApexPages.StandardController( ship2 ));
        NEU_Ground_Track_Trace gtt3 = new NEU_Ground_Track_Trace(new ApexPages.StandardController( ship3 ));
    }
}