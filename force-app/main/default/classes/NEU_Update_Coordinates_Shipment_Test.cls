@isTest
public class NEU_Update_Coordinates_Shipment_Test {

    
    @TestSetUp
    public static void makeData(){
            
        User userT = TestDataFactory.createUserAdmin();
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
        Location__c location1 = TestDataFactory.createLocation('test1',country1.Id);
        Location__c location2 = TestDataFactory.createLocation('test2',country2.Id);        
        State__c state1 = TestDataFactory.createState('nopalucan',country1.Id);
        State__c state2 = TestDataFactory.createState('san martin',country1.Id);      
                
        
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
        Account_Address__c address1 = TestDataFactory.createAddressAccount('address test', accCustomer.Id,cp.Id);
        Account_Address__c address2 = TestDataFactory.createAddressAccount('address test1', accCustomer.Id,cp.Id);
        
        
        try{
         
            Shipment__c shipment1 = TestDataFactory.createShipment(csp1,ic);
            shipment1.Account_Origin_Address__c = address1.Id;
            shipment1.Account_Destination_Address__c = address2.Id;
            update shipment1;
                        
        }catch(Exception e){
            system.debug('capturando el error: ' + e.getMessage());
        }        
        
    }
    
    @isTest
    public static void runTest(){
        
        Shipment__c sp = [Select Id, Name,Traslado_Ingreso__c,VERIFY_PAK_CONTROL__c,Shipment_Status_Plann__c from Shipment__c where Name = 'SP-FN-22-000111'];
        
        Test.startTest();
        
        	sp.Traslado_Ingreso__c = 'Traslado';
        	sp.VERIFY_PAK_CONTROL__c = true;  
        	sp.Shipment_Status_Plann__c = 'Confirmed';
        	update sp;
        
        
        Test.stopTest();
        
        
        
    }
    
}