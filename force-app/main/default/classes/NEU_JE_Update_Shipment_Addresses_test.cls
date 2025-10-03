@isTest
public class NEU_JE_Update_Shipment_Addresses_test {    
    
    
    
    
    @testSetup
    static void setup(){
        Account acc= new Account();
        acc.Name='Test';
        acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();		
        acc.OwnerId=UserInfo.getUserId();  
        acc.ShippingStreet='Test';
        acc.ShippingCity='Test01';
        acc.ShippingState='TEST0011';
        acc.ShippingPostalCode='TEST001';
        acc.ShippingCountry='test0000w';                
        insert acc;
        
        Account supplier = new Account(Name = 'Test Supplier', 
                                       RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Supplier').getRecordTypeId(),
                                       OwnerId=UserInfo.getUserId(),ShippingCity='Test01',
                                       ShippingState='TEST0011',
                                       ShippingPostalCode='TEST001',
                                       ShippingCountry='test0000w');
        insert supplier;
    }
    
    @isTest
    static void NEU_JE_Update_Shipment_Addresses() {                
        Test.startTest();
        Account customerAccount = [SELECT Id FROM Account WHERE RecordType.Name = 'Customer' LIMIT 1];
        Account supplierAccount = [SELECT Id FROM Account WHERE RecordType.Name = 'Supplier' LIMIT 1];                
        Shipment__c ship = new Shipment__c(
            Name = 'SP-TS-00057TEST',
            Freight_Mode__c='Sea',
            Service_Mode__c ='Import',
            Only_Warehouse_Service__c = true,
            Supplier_Account__c = supplierAccount.Id,
            Account_for__c = customerAccount.Id,
            Origin_Address__c = null,
            Destination_Address__c = null
        );
        insert ship;
        Test.stopTest();                
    }
    
    @isTest
    static void testPartialAddress() {
        Account acc = new Account(
            Name = 'Partial Address Test',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
            ShippingCity = 'CityOnly',
            ShippingCountry = 'CountryOnly',
            ShippingState='StateOnly'
            
        );
        insert acc;
        
        Shipment__c ship = new Shipment__c(
            Name='SP-FN-TEST-007',            
            Account_for__c = acc.Id,
            Freight_Mode__c='Sea',
            Service_Mode__c ='Import',
            Only_Warehouse_Service__c = true
        );
        
        Test.startTest();
        insert ship;
        Test.stopTest();        
    }
    
    @isTest
    static void testNoAddress() {        
        Account acc = new Account(
            Name = 'No Address Test',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId()
        );
        insert acc;
        
        Shipment__c ship = new Shipment__c(
            Name = 'SP-TS-00057TEST',
            Freight_Mode__c='Sea',
            Service_Mode__c ='Import',
            Only_Warehouse_Service__c = true,            
            Account_for__c = acc.Id,
            Origin_Address__c = null,
            Destination_Address__c = null
        );
        
        Test.startTest();
        insert ship;
        Test.stopTest();                
    }
    /*
@isTest
static void NEU_JE_Update_Shipment_Addresses(){
Test.startTest();
Account customerAccount = [SELECT Id FROM Account WHERE RecordType.Name = 'Customer' LIMIT 1];
Account supplierAccount = [SELECT Id FROM Account WHERE RecordType.Name = 'Supplier' LIMIT 1];                
Shipment__c ship = new Shipment__c(
Name = 'SP-TS-00057TEST',
Freight_Mode__c='Sea',
Service_Mode__c ='Import',
Only_Warehouse_Service__c = true,
Supplier_Account__c = supplierAccount.Id,
Account_for__c = customerAccount.Id,
Origin_Address__c = null,
Destination_Address__c = null
);
insert ship;                        
Test.stopTest();
}
*/
    
    /*
@isTest(SeeAllData=true)
static void NEU_JE_Update_Shipment_Addresses ()
{
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

/*
//user        
User userT = new User();
userT.FirstName = 'leo';
userT.LastName = 'test';
userT.Email = 'leoTest@test.com';
userT.Username = 'leoTest@test.com.leoTest';
userT.Alias = 'TestL';
userT.TimeZoneSidKey = 'America/Mexico_City';
userT.LocaleSidKey = 'es_MX';
userT.EmailEncodingKey = 'UTF-8';
userT.ProfileId = [Select Id from Profile where Name = 'System Administrator'].Id;
userT.LanguageLocaleKey = 'es_MX';
insert userT;

//Account     
Account accCustomer = TestDataFactory.createAccounts('Cuenta customer', 'Customer');        
Account accCarrier = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');                
//produccion Autotransporte  -- uat: Autotrasporte
Catalogo_SAT__c trans1 = TestDataFactory.createCatalogoSat('Camión-Remolque-Test', 'T3S17','Configuracion Autotransporte');                                         
//RecordType: AUT y  produccion : Tipo de Permiso     
Catalogo_SAT__c trans2 = TestDataFactory.createCatalogoSat('Autotransporte Federal Test' , 'T3S172','Tipo de Permiso'); 
Vehicle__c vehicle = TestDataFactory.createVehiculo(accCarrier.Id,trans1.Id,trans2.Id);
Catalogo_SAT__c cp = TestDataFactory.createCatalogoSat('980828','980828','Codigo Postal');
Operadores__c operador = TestDataFactory.createOperador(accCarrier.Id,cp.Id);
Container_Type__c ct = TestDataFactory.createContainerType('20" Container');
Country__c country1 = TestDataFactory.createCountry();
Country__c country2 = TestDataFactory.createCountry();
Country__c country3 = TestDataFactory.createCountry();
Country__c country4 = TestDataFactory.createCountry();
Location__c location1 = TestDataFactory.createLocation('test1',country1.Id);
Location__c location2 = TestDataFactory.createLocation('test2',country2.Id);
Location__c location3 = TestDataFactory.createLocation('test3',country3.Id);
Location__c location4= TestDataFactory.createLocation('test4',country4.Id);
State__c state1 = TestDataFactory.createState('nopalucan',country1.Id);
State__c state2 = TestDataFactory.createState('san martin',country1.Id);
State__c state3 = TestDataFactory.createState('san juan',country3.Id);
State__c state4= TestDataFactory.createState('panotla',country4.Id);
Account_Address__c ad = TestDataFactory.createAddressAccount('accAddress', accCustomer.Id, cp.Id);

Shipment__c ship = new Shipment__c(Name = 'SP-TS-00047', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Account_Stop_B__c  = a.Id,
Account_Stop_C__c = a.Id, Origin_Address__c ='test origin address', Destination_Address__c ='test destination address', Only_Warehouse_Service__c = true);
insert ship;

Shipment__c ship2 = new Shipment__c(Name = 'SP-TS-00048', Account_for__c = a.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import',
Account_Stop_C__c = a.Id, Origin_Address__c ='test origin address', Destination_Address__c ='test destination address', Only_Warehouse_Service__c = true);
/*
TestDataFactory.ShipmentCreate csp = new TestDataFactory.ShipmentCreate();
csp.name = 'SP-CE-22-000011';
csp.operador = operador.Id;
csp.vehiculo = vehicle.Id;
csp.accCarrier = accCarrier.Id;
csp.accCustomer = accCustomer.Id;
csp.user = userT.Id;
csp.freightMode = 'Road';
csp.serviceMode = 'IMPORT';
csp.serviceType = 'FTL';
csp.containerSize = ct.Name;   

TestDataFactory.ShipmentCreate csp1 = new TestDataFactory.ShipmentCreate();
csp1.name = 'SP-FN-22-000111';
csp1.operador = operador.Id;
csp1.vehiculo = vehicle.Id;
csp1.accCarrier = accCarrier.Id;
csp1.accCustomer = accCustomer.Id;
csp1.user = userT.Id;
csp1.freightMode = 'Road';
csp1.serviceMode = 'NATIONAL';
csp1.serviceType = 'FTL';
csp1.containerSize = ct.Name;                 

TestDataFactory.InfoCountry ic = new TestDataFactory.InfoCountry();
ic.countryOfdischarge = country1.Id;
ic.countryOfLoad = country1.Id;
ic.siteOfdischarge = location1.Id;
ic.siteOfLoad = location1.Id;
ic.stateofLoad = state2.Id;
ic.stateofDischarge = state2.Id;

Carrier_Line_Load_Point__c route1 = TestDataFactory.createRoute('Tlaxcala-Tlaxco', ic);                
Test.startTest(); 
Shipment__c shipment1 = TestDataFactory.createShipment(csp,ic);
//shipment1.Supplier_Account__c = accCarrier.Id;
//update shipment1;
Test.stopTest(); 

//Account_Address__c ad=new Account_Address__c(Account__c=a.id,Address__c='test',Type__c='Shipping Address');
//insert ad;
/*Shipment__c ship = new Shipment__c(Name = 'SP-CE-22-000194',Account_for__c = a.Id, Supplier_Account__c= a1.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Origin_Address__c='test', Destination_Address__c ='test', Only_Warehouse_Service__c = true);
insert ship;
Shipment__c ship2 = new Shipment__c(Name = 'SP-CE-22-000195',Account_for__c = a.Id, Supplier_Account__c= a1.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Consignee__c=a.id, Destination_Address__c ='test', Only_Warehouse_Service__c = true);
insert ship2;
Shipment__c ship3 = new Shipment__c(Name = 'SP-CE-22-000196',Account_for__c = a.Id, Supplier_Account__c= a1.Id, Freight_Mode__c='Sea', Service_Mode__c ='Import', Origin_Address__c='test',Consignee__c=a.id,Account_Destination_Address__c=ad.id, Only_Warehouse_Service__c = true);
insert ship3;

}
*/
}