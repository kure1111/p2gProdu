@isTest
public class NEU_OM_SCMV1_SCMV2_Test {

    @TestSetUp
    public static void makeDate(){
        
        User userT = TestDataFactory.createUserAdmin();
        Account accCustomer = TestDataFactory.createAccounts('Cuenta customer', 'Customer');        
        Account accCarrier = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');
        Account accNavera = TestDataFactory.createAccounts('Cuenta carrier', 'Supply Chain Partner');
        Rol_Margen__c rl = TestDataFactory.createRolMargen('Director Comercial');
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
        Vessel_Flight__c vf = TestDataFactory.createVassel('vf1', accNavera.Id);
        SCM_Rule__c rul1 = TestDataFactory.createRule('ruleTest1', 'SCMV1');       
        SCM_Activity__c act1 = TestDataFactory.createActivity('activityTest1',rul1.Id);         
                
        
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
         	SCM_Rule__c rul2 = TestDataFactory.createRule('test2', 'SCMV2');
            SCM_Activity__c act2 = TestDataFactory.createActivity('activiTest2',rul2.Id); 
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
        
        Shipment__c sp = [Select Id, Name, ETD__c,ETA_ATA__c from Shipment__c where Name = 'SP-FN-22-000001'];
        
        Test.startTest();
     
        	Date d1 = Date.newInstance(2023, 4, 6);        	
        	sp.ETD__c = CSUtils.formatDate(d1, 'yyyy/MM/dd');
        	sp.ETA_ATA__c = CSUtils.formatDate(d1, 'yyyy/MM/dd');
        	update sp;
	        
        Test.stopTest();
        
    }
}