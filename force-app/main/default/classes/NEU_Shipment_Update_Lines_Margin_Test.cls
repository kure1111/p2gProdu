@isTest
public class NEU_Shipment_Update_Lines_Margin_Test {

    @TestSetUp
    public static void makeData(){
        
        Account accCustomer = TestDataFactory.createAccounts('accCustomer','Customer');
        Shipment_Program__c spp = TestDataFactory.createShipmentProgram();
        User userT = TestDataFactory.createUserAdmin();
        
        Account accCarrier = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');
        Account accNavera = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');
        
        //Produccion: Autotransporte - UAT : Autotrasporte
        Catalogo_SAT__c trans1 = TestDataFactory.createCatalogoSat('Camión-Remolque-Test', 'T3S17','Configuracion Autotransporte');                                         
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
        Contact con = TestDataFactory.createContact(accCustomer.Id, 'contactTest');
		                
        
        
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
                
        TestDataFactory.InfoCountry ic = new TestDataFactory.InfoCountry();
        ic.countryOfdischarge = country1.Id;
        ic.countryOfLoad = country1.Id;
        ic.siteOfdischarge = location1.Id;
        ic.siteOfLoad = location1.Id;
        ic.stateofLoad = state2.Id;
        ic.stateofDischarge = state2.Id;               
                
        try{         
            Shipment__c shipment1 = TestDataFactory.createShipment(csp1,ic);
            Shipment_Line__c sl = TestDataFactory.createShipmentLine(shipment1.Id, 'slTest');
                        
        }catch(Exception e){
            system.debug('capturando el error: ' + e.getMessage());
        }        
    }
    
    
    @isTest
    public static void runTest(){
        
        Shipment__c sp1 = [Select Id, Name,Margin_at_Destination_by_Default__c from Shipment__c where Name = 'SP-FN-22-000001'];        
        
        Test.startTest();
        	sp1.Margin_at_Destination_by_Default__c = 20;        	    		
            update sp1;    
        Test.stopTest();        
    }
}