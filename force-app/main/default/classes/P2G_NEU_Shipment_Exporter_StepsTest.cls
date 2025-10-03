@isTest
public class P2G_NEU_Shipment_Exporter_StepsTest {
    @isTest
    static void test_NEU_OM_Shipment_Steps()
    {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //insert a;
        
        Account a=new Account();
        a.Name='TEST';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        a.OwnerId=UserInfo.getUserId();
        insert a;                         
        
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00023', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',CurrencyIsoCode='MXN');
        insert shipline;
        
        NEU_Shipment_Exporter_Steps ss = new NEU_Shipment_Exporter_Steps(new ApexPages.StandardController( ship ));
        
        system.debug( 'Prueba realizada' );
    }
    @isTest
    static void test_NEU_OM_Shipment_Steps2()
    {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //insert a;
        Account a=new Account();
        a.Name='TEST';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        a.OwnerId=UserInfo.getUserId();
        insert a;                                         
        
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00024', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        
        NEU_Shipment_Exporter_Steps ss = new NEU_Shipment_Exporter_Steps(new ApexPages.StandardController( ship ));
        
        system.debug( 'Prueba realizada' );
    }
    @isTest
    static void test_NEU_OM_Shipment_Steps3()
    {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //insert a;
        Account a=new Account();
        a.Name='TEST';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        a.OwnerId=UserInfo.getUserId();
        insert a;       
        
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00025', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Fee__c fee = new Fee__c(Name = 'test fees', Fee_Category__c = 'Disbursement', Rate_Type__c = 'Fixed', Account_for__c = a.Id);
        insert fee;
        Shipment_Fee_Line__c shipfeeline = new Shipment_Fee_Line__c(Name='test shipment fee line', Discount_Charge__c=8, Extension_Service_Name__c='test extension', Service_Rate_Name__c=fee.Id , Shipment__c= ship.Id, Shipment_Sell_Price__c=10, Units__c=10, Shipment_Buy_Price__c=10 );
        insert shipfeeline;
        NEU_Shipment_Exporter_Steps ss = new NEU_Shipment_Exporter_Steps(new ApexPages.StandardController( ship ));
        
        system.debug( 'Prueba realizada' );
    }
    @isTest
    static void test_NEU_OM_Shipment_Steps4()
    {
        
        NEU_StaticVariableHelper.setBoolean1(true);
        
        ApexPages.currentPage().getParameters().put('test', 'test');
        
        //List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        //Account a = list_accounts[0];
        //insert a;
        
        Account a=new Account();
        a.Name='TEST';
        a.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
                	a.OwnerId=UserInfo.getUserId();
        insert a;       
        
        Shipment__c ship = new Shipment__c(Name = 'SP-TS-00026', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Only_Warehouse_Service__c = true);
        insert ship;
        Shipment_Line__c shipline = new Shipment_Line__c(Shipment__c = ship.Id, Name= 'test ship line',  Customs_Value__c=10,CurrencyIsoCode='MXN');
        insert shipline;
        
        NEU_Shipment_Exporter_Steps ss = new NEU_Shipment_Exporter_Steps(new ApexPages.StandardController( ship ));
        
        system.debug( 'Prueba realizada' );
    }
    
}