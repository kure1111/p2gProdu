@isTest
public with sharing class NEU_ShipmentContainerType_to_Size_Test {
    
    @isTest
    public static void runTest1(){
        Account accCustomer = TestDataFactory.createAccounts('Account Customer', 'Customer');
		Account accCarrier = TestDataFactory.createAccounts('Account Customer1', 'Supply Chain Partner');        
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen('Director Comercial');
        User admin = TestDataFactory.createUserAdmin();
        //RecordType: produccion:Configuracion Autotransporte  UAT: Configuracion Autotrasporte
        Catalogo_SAT__c trans1 = TestDataFactory.createCatalogoSat('Camión-Remolque-Test', 'T3S17','Configuracion Autotransporte');                                         
        //RecordType: AUT y  produccion : Tipo de Permiso     
        Catalogo_SAT__c trans2 = TestDataFactory.createCatalogoSat('Autotransporte Federal Test' , 'T3S172','Tipo de Permiso'); 
        Vehicle__c vehicle = TestDataFactory.createVehiculo(accCarrier.Id,trans1.Id,trans2.Id);
        Catalogo_SAT__c cp = TestDataFactory.createCatalogoSat('980828','980828','Codigo Postal');
        Operadores__c operador = TestDataFactory.createOperador(accCarrier.Id,cp.Id);
        Container_Type__c ct = TestDataFactory.createContainerType('20" Container');
        
        TestDataFactory.ShipmentCreate csp = new TestDataFactory.ShipmentCreate();
        csp.name = 'SP-CE-22-000001';
        csp.operador = operador.Id;
        csp.vehiculo = vehicle.Id;
        csp.accCarrier = accCarrier.Id;
        csp.accCustomer = accCustomer.Id;
        csp.user = admin.Id;
        csp.freightMode = 'Road';
        csp.serviceMode = 'IMPORT';
        csp.serviceType = 'FTL';
        csp.containerSize = ct.Name;
        
        
        Test.startTest();
            Shipment__c shipment = TestDataFactory.createShipment(csp,null);    
        Test.stopTest();

        System.assertEquals(ct.name, shipment.Container_Size__c, shipment.Container_Size__c != null);

    }

}