@isTest
public with sharing class NEU_Shipment_Update_Route_Test {
            
    @TestSetUp
    static void createObjects(){
        
        
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
        //Prod:Configuracion Autotransporte  aut:Configuracion Autotrasporte      
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
        
        TestDataFactory.ShipmentCreate csp2 = new TestDataFactory.ShipmentCreate();
        csp2.name = 'SP-FN-22-000112';
        csp2.operador = operador.Id;
        csp2.vehiculo = vehicle.Id;
        csp2.accCarrier = accCarrier.Id;
        csp2.accCustomer = accCustomer.Id;
        csp2.user = userT.Id;
        csp2.freightMode = 'Road';
        csp2.serviceMode = 'NATIONAL';
        csp2.serviceType = 'FTL';
        csp2.containerSize = ct.Name; 
        
        TestDataFactory.ShipmentCreate csp3 = new TestDataFactory.ShipmentCreate();
        csp3.name = 'SP-FN-22-002122';
        csp3.operador = operador.Id;
        csp3.vehiculo = vehicle.Id;
        csp3.accCarrier = accCarrier.Id;
        csp3.accCustomer = accCustomer.Id;
        csp3.user = userT.Id;
        csp3.freightMode = 'Road';
        csp3.serviceMode = 'NATIONAL';
        csp3.serviceType = 'FTL';
        csp3.containerSize = ct.Name; 


        TestDataFactory.InfoCountry ic = new TestDataFactory.InfoCountry();
        ic.countryOfdischarge = country1.Id;
        ic.countryOfLoad = country1.Id;
        ic.siteOfdischarge = location1.Id;
        ic.siteOfLoad = location1.Id;
        ic.stateofLoad = state2.Id;
        ic.stateofDischarge = state2.Id;
        
        TestDataFactory.InfoCountry ic1= new TestDataFactory.InfoCountry();
        ic1.countryOfdischarge = country3.Id;
        ic1.countryOfLoad = country4.Id;
        ic1.siteOfdischarge = location3.Id;
        ic1.siteOfLoad = location4.Id;
        ic1.stateofLoad = state3.Id;
        ic1.stateofDischarge = state3.Id;
        
        TestDataFactory.InfoCountry ic2= new TestDataFactory.InfoCountry();
        ic2.countryOfdischarge = country1.Id;
        ic2.countryOfLoad = country4.Id;
        ic2.siteOfdischarge = location1.Id;
        ic2.siteOfLoad = location4.Id;
        ic2.stateofLoad = state1.Id;
        ic2.stateofDischarge = state3.Id;

		Carrier_Line_Load_Point__c route1 = TestDataFactory.createRoute('Tlaxcala-Tlaxco', ic);
        Carrier_Line_Load_Point__c route2 = TestDataFactory.createRoute('Tlaxco-Tlaxcala', ic1);        
        
        Shipment__c shipment1 = TestDataFactory.createShipment(csp,ic);
        Shipment__c shipment2 = TestDataFactory.createShipment(csp1,ic1);        
        Shipment__c shipment3 = TestDataFactory.createShipment(csp2,ic2);
        Shipment__c shipment4 = TestDataFactory.createShipment(csp3,null);
    }
    
    
    @isTest
    public static void runTest(){
                
        Shipment__c sp1 = [Select Id, Name, State_of_Discharge__c from Shipment__c where Name = 'SP-CE-22-000011'];
        Shipment__c sp2 = [Select Id, Name from Shipment__c where Name = 'SP-FN-22-000111'];        
        Shipment__c sp3 = [Select Id, Name, State_of_Discharge__c,Country_of_Discharge__c,Country_of_Load__c,Site_of_Load__c from Shipment__c where Name = 'SP-FN-22-000112'];
        Shipment__c sp4 = [Select Id, Name, State_of_Discharge__c,Country_of_Discharge__c,Country_of_Load__c,Site_of_Load__c from Shipment__c where Name = 'SP-FN-22-002122'];        
        
        Test.startTest();
        	List<Carrier_Line_Load_Point__c> ruta = [Select Id, Name from Carrier_Line_Load_Point__c  where Name = 'Tlaxcala-Tlaxco'];
        	Country__c country1 = TestDataFactory.createCountry();     
        	List<Carrier_Line_Load_Point__c> routes = [Select Id, Name from Carrier_Line_Load_Point__c where Name = 'route'];        
        	system.debug('routes.size()'+routes.size());
        	State__c state = TestDataFactory.createState('panotla1',country1.Id);
            sp1.State_of_Discharge__c = state.Id;
        	sp2.State_of_Discharge__c = null;
        	sp3.State_of_Discharge__c = null;
        	sp3.Country_of_Discharge__c = null;
        	sp3.Country_of_Load__c = null;
        	sp3.Site_of_Load__c = null;
        	List<Shipment__c> sps = new List<Shipment__c>{sp1,sp2,sp3};
            update sps;        
        	delete ruta;
            delete routes;       	
        Test.stopTest();        
        
    }        
}