@isTest
public class P2G_NEU_ConfirmShipmentRequestTest {
    @isTest
    static void test_NEU_ConfirmShipmentRequest()
    {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //insert a;
        
        Account a=new Account();
        a.Name='TEST';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        a.OwnerId=UserInfo.getUserId();
        insert a;                
        
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00011', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        NEU_ConfirmShipmentRequest uda = new NEU_ConfirmShipmentRequest(new ApexPages.StandardController( ship ));
        uda.confirm_request();
    }  
}