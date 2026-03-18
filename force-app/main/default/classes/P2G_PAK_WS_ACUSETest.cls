@isTest
public class P2G_PAK_WS_ACUSETest {

    @isTest (SeeAllData=true)
    static void testUSHIP_success_withVoBo1() {        
        // Consultar un Shipment existente
        Shipment__c shipment = [SELECT Id, Name FROM Shipment__c LIMIT 1];
        System.debug('Shipment encontrado: ' + shipment.Name);
        
        PAK_WS_ACUSE.ACUSE acuse = new PAK_WS_ACUSE.ACUSE();
        acuse.Shipment = shipment.Name; // Usar el nombre real del shipment
        acuse.Fecha = String.valueOf(Date.today()); 
        acuse.Status = 'Recibido';
        acuse.VoBo = '1'; 

        Test.startTest();
        List<PAK_WS_ACUSE.status> response = PAK_WS_ACUSE.USHIP(new List<PAK_WS_ACUSE.ACUSE>{ acuse });
        Test.stopTest();
        
        System.debug('Respuesta testUSHIP_success_withVoBo1: ' + response);
    }

    @isTest(SeeAllData=true)
    static void test_USHIP_success() {
        // Consultar un Shipment existente
        Shipment__c shipment = [SELECT Id, Name FROM Shipment__c LIMIT 1];
        System.debug('Shipment encontrado: ' + shipment.Name);
        
        PAK_WS_ACUSE.ACUSE acuse = new PAK_WS_ACUSE.ACUSE();
        acuse.Shipment = shipment.Name; // Usar el nombre real del shipment
        acuse.Fecha = null;
        acuse.Status = 'Recibido';
        acuse.VoBo = '1';
        
        System.debug('Acuse: ' + acuse);

        List<PAK_WS_ACUSE.ACUSE> acuses = new List<PAK_WS_ACUSE.ACUSE>{ acuse };

        Test.startTest();
        List<PAK_WS_ACUSE.status> result = PAK_WS_ACUSE.USHIP(acuses);
        Test.stopTest();
        
        System.debug('Respuesta test_USHIP_success: ' + result);
    }

    @isTest(SeeAllData=true)
    static void test_USHIP_withVoBo0() {
        // Consultar un Shipment existente
        Shipment__c shipment = [SELECT Id, Name FROM Shipment__c LIMIT 1];
        System.debug('Shipment encontrado: ' + shipment.Name);
        
        PAK_WS_ACUSE.ACUSE acuse = new PAK_WS_ACUSE.ACUSE();
        acuse.Shipment = shipment.Name; // Usar el nombre real del shipment
        acuse.Fecha = String.valueOf(Date.today().addDays(-5));
        acuse.Status = 'Entregado';
        acuse.VoBo = '0'; // VoBo = false

        List<PAK_WS_ACUSE.ACUSE> acuses = new List<PAK_WS_ACUSE.ACUSE>{ acuse };

        Test.startTest();
        List<PAK_WS_ACUSE.status> result = PAK_WS_ACUSE.USHIP(acuses);
        Test.stopTest();
        
        System.debug('Respuesta test_USHIP_withVoBo0: ' + result);
    }

    @isTest(SeeAllData=true)
    static void test_USHIP_sinFecha() {
        // Consultar un Shipment existente
        Shipment__c shipment = [SELECT Id, Name FROM Shipment__c LIMIT 1];
        System.debug('Shipment encontrado: ' + shipment.Name);
        
        PAK_WS_ACUSE.ACUSE acuse = new PAK_WS_ACUSE.ACUSE();
        acuse.Shipment = shipment.Name; // Usar el nombre real del shipment
        acuse.Fecha = '';
        acuse.Status = 'Pendiente';
        acuse.VoBo = '1';

        List<PAK_WS_ACUSE.ACUSE> acuses = new List<PAK_WS_ACUSE.ACUSE>{ acuse };

        Test.startTest();
        List<PAK_WS_ACUSE.status> result = PAK_WS_ACUSE.USHIP(acuses);
        Test.stopTest();
        
        System.debug('Respuesta test_USHIP_sinFecha: ' + result);
    }

    @isTest(SeeAllData=true)
    static void test_USHIP_conVariosRegistros() {
        // Consultar Shipments existentes
        List<Shipment__c> shipments = [SELECT Id, Name FROM Shipment__c LIMIT 2];
        
        if(shipments.size() >= 2) {
            System.debug('Shipments encontrados: ' + shipments[0].Name + ', ' + shipments[1].Name);
            
            List<PAK_WS_ACUSE.ACUSE> acuses = new List<PAK_WS_ACUSE.ACUSE>();
            
            // Primer acuse
            PAK_WS_ACUSE.ACUSE acuse1 = new PAK_WS_ACUSE.ACUSE();
            acuse1.Shipment = shipments[0].Name;
            acuse1.Fecha = String.valueOf(Date.today());
            acuse1.Status = 'Recibido';
            acuse1.VoBo = '1';
            acuses.add(acuse1);
            
            // Segundo acuse
            PAK_WS_ACUSE.ACUSE acuse2 = new PAK_WS_ACUSE.ACUSE();
            acuse2.Shipment = shipments[1].Name;
            acuse2.Fecha = String.valueOf(Date.today().addDays(-2));
            acuse2.Status = 'Entregado';
            acuse2.VoBo = '0';
            acuses.add(acuse2);

            Test.startTest();
            List<PAK_WS_ACUSE.status> result = PAK_WS_ACUSE.USHIP(acuses);
            Test.stopTest();
            
            System.debug('Respuesta test_USHIP_conVariosRegistros: ' + result);
        } else {
            System.debug('No hay suficientes Shipments para la prueba');
        }
    }

    @isTest(SeeAllData=true)
    static void test_USHIP_shipmentNoExistente() {
        // Usar un nombre de shipment que no existe
        String nombreNoExistente = 'SHIP-NO-EXISTE-' + System.currentTimeMillis();
        
        PAK_WS_ACUSE.ACUSE acuse = new PAK_WS_ACUSE.ACUSE();
        acuse.Shipment = nombreNoExistente;
        acuse.Fecha = String.valueOf(Date.today());
        acuse.Status = 'Recibido';
        acuse.VoBo = '1';

        List<PAK_WS_ACUSE.ACUSE> acuses = new List<PAK_WS_ACUSE.ACUSE>{ acuse };

        Test.startTest();
        List<PAK_WS_ACUSE.status> result = PAK_WS_ACUSE.USHIP(acuses);
        Test.stopTest();
        
        System.debug('Respuesta test_USHIP_shipmentNoExistente: ' + result);
    }

    @isTest(SeeAllData=true)
    static void test_USHIP_conListaVacia() {
        Test.startTest();
        List<PAK_WS_ACUSE.status> result = PAK_WS_ACUSE.USHIP(new List<PAK_WS_ACUSE.ACUSE>());
        Test.stopTest();
        
        System.debug('Respuesta test_USHIP_conListaVacia: ' + result);
    }

    @isTest(SeeAllData=true)
    static void test_USHIP_conCamposNulos() {
        // Consultar un Shipment existente
        Shipment__c shipment = [SELECT Id, Name FROM Shipment__c LIMIT 1];
        System.debug('Shipment encontrado: ' + shipment.Name);
        
        PAK_WS_ACUSE.ACUSE acuse = new PAK_WS_ACUSE.ACUSE();
        acuse.Shipment = shipment.Name;
        acuse.Fecha = null;
        acuse.Status = null;
        acuse.VoBo = null;

        List<PAK_WS_ACUSE.ACUSE> acuses = new List<PAK_WS_ACUSE.ACUSE>{ acuse };

        Test.startTest();
        List<PAK_WS_ACUSE.status> result = PAK_WS_ACUSE.USHIP(acuses);
        Test.stopTest();
        
        System.debug('Respuesta test_USHIP_conCamposNulos: ' + result);
    }

    @isTest(SeeAllData=true)
    static void test_USHIP_conVoBoInvalido() {
        // Consultar un Shipment existente
        Shipment__c shipment = [SELECT Id, Name FROM Shipment__c LIMIT 1];
        System.debug('Shipment encontrado: ' + shipment.Name);
        
        PAK_WS_ACUSE.ACUSE acuse = new PAK_WS_ACUSE.ACUSE();
        acuse.Shipment = shipment.Name;
        acuse.Fecha = String.valueOf(Date.today());
        acuse.Status = 'Recibido';
        acuse.VoBo = '2'; // Valor no válido (solo '0' o '1')

        List<PAK_WS_ACUSE.ACUSE> acuses = new List<PAK_WS_ACUSE.ACUSE>{ acuse };

        Test.startTest();
        List<PAK_WS_ACUSE.status> result = PAK_WS_ACUSE.USHIP(acuses);
        Test.stopTest();
        
        System.debug('Respuesta test_USHIP_conVoBoInvalido: ' + result);
    }
    
    @isTest(SeeAllData=true)
    static void test_USHIP_error_malformed_date() {
        // Consultar un Shipment existente
        Shipment__c shipment = [SELECT Id, Name FROM Shipment__c LIMIT 1];
        System.debug('Shipment encontrado: ' + shipment.Name);
        
        PAK_WS_ACUSE.ACUSE acuse = new PAK_WS_ACUSE.ACUSE();
        acuse.Shipment = shipment.Name; // Usar nombre real
        acuse.Fecha = 'fecha-mala'; // Fecha mal formada
        acuse.Status = 'Error';
        acuse.VoBo = '0';

        List<PAK_WS_ACUSE.ACUSE> acuses = new List<PAK_WS_ACUSE.ACUSE>{ acuse };

        Test.startTest();
        // Esto debería lanzar una excepción dentro del método
        List<PAK_WS_ACUSE.status> result = PAK_WS_ACUSE.USHIP(acuses);
        Test.stopTest();
        
        System.debug('Respuesta test_USHIP_error_malformed_date: ' + result);
    }
}

/*
@isTest
public class P2G_PAK_WS_ACUSETest {

    @isTest (SeeAllData=true)
    static void testUSHIP_success_withVoBo1() {        
        Shipment__c shipment =[SELECT Id FROM Shipment__c LIMIT 1];

        
        PAK_WS_ACUSE.ACUSE acuse = new PAK_WS_ACUSE.ACUSE();
        acuse.Shipment = 'TEST-SHIPMENT';
        acuse.Fecha = String.valueOf(Date.today()); 
        acuse.Status = 'Recibido';
        acuse.VoBo = '1'; 

        Test.startTest();
        List<PAK_WS_ACUSE.status> response = PAK_WS_ACUSE.USHIP(new List<PAK_WS_ACUSE.ACUSE>{ acuse });
        Test.stopTest();

    }

    @isTest(SeeAllData=true)
    static void test_USHIP_success() {
        
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];
               
        PAK_WS_ACUSE.ACUSE acuse = new PAK_WS_ACUSE.ACUSE();
        acuse.Shipment = 'SHIP001';
        acuse.Fecha = null;
        acuse.Status = 'Recibido';
        acuse.VoBo = '1';
        
        System.debug('Acuse '+acuse);
    
    

        List<PAK_WS_ACUSE.ACUSE> acuses = new List<PAK_WS_ACUSE.ACUSE>{ acuse };

        Test.startTest();
        List<PAK_WS_ACUSE.status> result = PAK_WS_ACUSE.USHIP(acuses);
        Test.stopTest();
        
    }

    @isTest(SeeAllData=true)
    static void test_USHIP_error_malformed_date() {
        
        Shipment__c shipment =[SELECT Id FROM Shipment__c LIMIT 1];
        
        PAK_WS_ACUSE.ACUSE acuse = new PAK_WS_ACUSE.ACUSE();
        acuse.Shipment = 'SHIP002';
        acuse.Fecha = 'fecha-mala'; 
        acuse.Status = 'Error';
        acuse.VoBo = '0';

        List<PAK_WS_ACUSE.ACUSE> acuses = new List<PAK_WS_ACUSE.ACUSE>{ acuse };

        Test.startTest();
        List<PAK_WS_ACUSE.status> result = PAK_WS_ACUSE.USHIP(acuses);
        Test.stopTest();
    }
}
*/