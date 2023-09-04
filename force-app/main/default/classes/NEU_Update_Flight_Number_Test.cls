@isTest
public class NEU_Update_Flight_Number_Test {

    
    @TestSetUp
    public static void makeData(){
        
        Account accCustomer = TestDataFactory.createAccounts('accCustomer','Customer');
        Shipment_Program__c spp = TestDataFactory.createShipmentProgram();
        User userT = TestDataFactory.createUserAdmin();
        
        Account accCarrier = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');
        Account accNavera = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');
        Rol_Margen__c rl = TestDataFactory.createRolMargen('Director Comercial');
        
        //Prod:Configuracion Autotransporte  aut:Configuracion Autotrasporte   
        Catalogo_SAT__c trans1 = TestDataFactory.createCatalogoSat('Camion-Remolque-Test', 'T3S17','Configuracion Autotransporte');                                         
        //RecordType: AUT y  produccion : Tipo de Permiso     
        Catalogo_SAT__c trans2 = TestDataFactory.createCatalogoSat('Autotransporte Federal Test' , 'T3S172','Tipo de Permiso'); 
        Vehicle__c vehicle = TestDataFactory.createVehiculo(accCarrier.Id,trans1.Id,trans2.Id);
        Catalogo_SAT__c cp = TestDataFactory.createCatalogoSat('980828','980828','Codigo Postal');
        Operadores__c operador = TestDataFactory.createOperador(accCarrier.Id,cp.Id);
        Container_Type__c ct = TestDataFactory.createContainerType('20" Container');
        Country__c country1 = TestDataFactory.createCountry();
        Country__c country2 = TestDataFactory.createCountry();        
        Location__c location1 = TestDataFactory.createLocation('test1',country1.Id);
        Location__c location2 = TestDataFactory.createLocation('test2',country2.Id);        
        State__c state1 = TestDataFactory.createState('nopalucan',country1.Id);
        State__c state2 = TestDataFactory.createState('san martin',country1.Id);
        Vessel_Flight__c vf = TestDataFactory.createVassel('vf1', accNavera.Id);            
		                
        
        
        TestDataFactory.ShipmentCreate csp1 = new TestDataFactory.ShipmentCreate();
        csp1.name = 'SP-FN-22-000001';
        csp1.operador = operador.Id;
        csp1.vehiculo = vehicle.Id;
        csp1.accCarrier = accCarrier.Id;
        csp1.accCustomer = accCustomer.Id;
        csp1.user = userT.Id;
        csp1.freightMode = 'Road';
        csp1.serviceMode = 'NATIONAL';
        csp1.serviceType = 'FTL';
        csp1.containerSize = ct.Name;           
        csp1.vesselId = vf.Id;
        csp1.shipmentProgram = spp.Id;
        
        TestDataFactory.ShipmentCreate csp2 = new TestDataFactory.ShipmentCreate();
        csp2.name = 'SP-FN-22-000011';
        csp2.operador = operador.Id;
        csp2.vehiculo = vehicle.Id;
        csp2.accCarrier = accCarrier.Id;
        csp2.accCustomer = accCustomer.Id;
        csp2.user = userT.Id;
        csp2.freightMode = 'Road';
        csp2.serviceMode = 'NATIONAL';
        csp2.serviceType = 'FTL';
        csp2.containerSize = ct.Name;           
        csp2.vesselId = vf.Id;
        csp2.shipmentProgram = spp.Id;


        TestDataFactory.InfoCountry ic = new TestDataFactory.InfoCountry();
        ic.countryOfdischarge = country1.Id;
        ic.countryOfLoad = country1.Id;
        ic.siteOfdischarge = location1.Id;
        ic.siteOfLoad = location1.Id;
        ic.stateofLoad = state2.Id;
        ic.stateofDischarge = state2.Id;               

        
        
        try{         
            Shipment__c shipment1 = TestDataFactory.createShipment(csp1,ic);
            Shipment__c shipment2 = TestDataFactory.createShipment(csp2,ic);           
                        
        }catch(Exception e){
            system.debug('capturando el error: ' + e.getMessage());
        }        
    }
    
    @isTest
    public static void runTest1(){
        
        Shipment__c sp1 = [Select Id, Name,Flight_Number__c,Truck_Number__c from Shipment__c where Name = 'SP-FN-22-000001'];
        Shipment__c sp2 = [Select Id, Name,Flight_Number__c,Truck_Number__c  from Shipment__c where Name = 'SP-FN-22-000011'];
        
        Test.startTest();
        	sp1.Flight_Number__c = '20';
        	sp1.Truck_Number__c = '10';
    		sp2.Flight_Number__c = '20';
        	sp2.Truck_Number__c = '10';
        	List<Shipment__c> spL = new List<Shipment__c>{sp1,sp2};
            update spL;    
        Test.stopTest();
    }
}