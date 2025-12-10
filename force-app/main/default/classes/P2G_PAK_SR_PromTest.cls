@isTest
public class P2G_PAK_SR_PromTest {
    @isTest
    static void P2G_PAK_SR_Prom(){                       
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account account_test = list_accounts[0];
        account_test.Segment__c = 'Nuevo';
        insert account_test;               	
        
        Shipment__c shipment_test = new Shipment__c();
        shipment_test.name = 'SP-FN-909897';
        shipment_test.Account_for__c = account_test.Id;
        shipment_test.Freight_Mode__c = 'Sea';
        shipment_test.Service_Mode__c = 'Import';
        shipment_test.Only_Warehouse_Service__c = true;
        insert shipment_test;
        
        Fee__c service = new Fee__c();
        service.Account_for__c = shipment_test.Account_for__c;
        service.Carrier_Account__c = shipment_test.Account_for__c;
        service.Name = 'test fees' + NEU_Utils.safeString(DateTime.now().getTime());
        service.Fee_Category__c = 'Disbursement';
        service.Rate_Type__c = 'Fixed';
        service.Valid_Until__c = Date.newInstance(2017,11,11);
        service.Valid_From__c = Date.newInstance(2017,10,10);
        service.Buy_Rate__c = 12;
        service.Fee_Rate__c = 23;
        service.Active__c = true;
        service.Standard_Rate__c = true;
        service.Fuel__c = 100;
        service.Risk__c = 100;
        service.Normal__c = 10;
        service.Volumetric_Factor__c = 1;
        service.Max_Kgs__c = 10;
        service.q200__c = 100;
        service.q25__c = 100;
        service.q45__c = 100;
        service.q50__c = 100;
        service.q80__c = 100;
        service.q100__c = 100;
        service.q125__c = 100;
        service.q150__c = 100;
        service.q250__c =100;
        service.q300__c = 100;
        service.q500__c = 100;
        service.q1000__c = 100;
        service.q1500__c = 100;
        service.q2000__c = 100;
        service.q2500__c = 100;
        service.q3000__c = 100;
        service.q5000__c = 100;
        service.q7500__c = 100;
        service.q10000__c = 100;
        insert service;
        
        Shipment_Fee_Line__c servicesF = new Shipment_Fee_Line__c();
        servicesF.Shipment__c = shipment_test.Id;
        servicesF.Name = '001';
        servicesF.Service_Rate_Name__c = service.Id;
        insert servicesF;
    }
}