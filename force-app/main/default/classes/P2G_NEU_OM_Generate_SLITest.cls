@isTest
public class P2G_NEU_OM_Generate_SLITest {
    
    @isTest
    static void Generate_SLI_test() 
    {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,Supplier,');
        
        Account account_test=new Account();
        account_test.Name='TEST';
        account_test.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        insert account_test;  
        
        Account supplier_test=new Account();
        supplier_test.Name='TEST';
        supplier_test.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        insert supplier_test;                  
        
        Shipment__c shipment_test = new Shipment__c();
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        shipment_test.Name = 'SP-TS-00001';
        insert shipment_test;
        
        Transport_Packaging_Data__c transport_packaging_data_test = new Transport_Packaging_Data__c();
        transport_packaging_data_test.Shipment__c = shipment_test.Id;
        transport_packaging_data_test.Name = 'SPD Test';
        insert transport_packaging_data_test;
        
        Shipment_Disbursement__c shipment_disbursement_test = new Shipment_Disbursement__c();
        shipment_disbursement_test.Shipment__c = shipment_test.Id;
        shipment_disbursement_test.Account__c = supplier_test.Id;
        insert shipment_disbursement_test;
        
        NEU_OM_Generate_SLI gsli = new NEU_OM_Generate_SLI(new ApexPages.StandardController(shipment_test));
        gsli.update_shipment();
    }
}