@isTest
public class PAK_WSSAPSERVICETYPE_test {
            
    @isTest(seeAllData=true)
    static void testListaVacia() {
        // Probar con lista vacía
        List<PAK_WSSAPSERVICETYPE.SapServiceType> emptyList = new List<PAK_WSSAPSERVICETYPE.SapServiceType>();
        
        Test.startTest();
        List<PAK_WSSAPSERVICETYPE.status> results = PAK_WSSAPSERVICETYPE.SFMESSAGES(emptyList);
        Test.stopTest();
        
        System.debug('Resultados testListaVacia: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testCodigoVacio() {
        // Probar con código vacío
        List<PAK_WSSAPSERVICETYPE.SapServiceType> services = new List<PAK_WSSAPSERVICETYPE.SapServiceType>();
        
        PAK_WSSAPSERVICETYPE.SapServiceType service = new PAK_WSSAPSERVICETYPE.SapServiceType();
        service.Code = '';
        service.activo = true;
        service.name = 'Servicio Sin Código';
        service.grupo = 'Paqueterias'; // Valor válido del picklist
        service.retentionISR = null; // Este campo no tiene valores
        service.retention = 'NO'; // Valor válido del picklist
        service.VAT = null;
        
        services.add(service);
        
        Test.startTest();
        List<PAK_WSSAPSERVICETYPE.status> results = PAK_WSSAPSERVICETYPE.SFMESSAGES(services);
        Test.stopTest();
        
        System.debug('Resultados testCodigoVacio: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testCodigoNull() {
        // Probar con código null
        List<PAK_WSSAPSERVICETYPE.SapServiceType> services = new List<PAK_WSSAPSERVICETYPE.SapServiceType>();
        
        PAK_WSSAPSERVICETYPE.SapServiceType service = new PAK_WSSAPSERVICETYPE.SapServiceType();
        service.Code = null;
        service.activo = true;
        service.name = 'Servicio Sin Código Null';
        service.grupo = 'Puertos'; // Valor válido del picklist
        service.retentionISR = null; // Este campo no tiene valores
        service.retention = 'SI'; // Valor válido del picklist
        service.VAT = null;
        
        services.add(service);
        
        Test.startTest();
        List<PAK_WSSAPSERVICETYPE.status> results = PAK_WSSAPSERVICETYPE.SFMESSAGES(services);
        Test.stopTest();
        
        System.debug('Resultados testCodigoNull: ' + results);
    }
                   
    
    @isTest(seeAllData=true)
    static void testValoresExtremos() {
        // Probar con valores extremos
        String uniqueCode = 'EXTREME-VALUES-' + System.currentTimeMillis();
        
        List<PAK_WSSAPSERVICETYPE.SapServiceType> services = new List<PAK_WSSAPSERVICETYPE.SapServiceType>();
        
        PAK_WSSAPSERVICETYPE.SapServiceType service = new PAK_WSSAPSERVICETYPE.SapServiceType();
        service.Code = uniqueCode;
        service.activo = true;
        
        // Nombres largos (pero no demasiado para evitar límites de campo)
        String nombreLargo = 'Servicio con nombre extremadamente largo para probar los límites del campo';
        String grupoLargo = 'SP-PQ-PAQUETERIA'; // Usar un valor válido del picklist
        
        service.name = nombreLargo;
        service.grupo = grupoLargo; // Valor válido
        
        // Valores para picklists
        service.retentionISR = null; // Este campo no tiene valores
        service.retention = 'NO'; // Valor válido
        service.VAT = null;
        
        services.add(service);
        
        Test.startTest();
        List<PAK_WSSAPSERVICETYPE.status> results = PAK_WSSAPSERVICETYPE.SFMESSAGES(services);
        Test.stopTest();
        
        System.debug('Resultados testValoresExtremos: ' + results);
    }
    
    @isTest(seeAllData=true)
    static void testCaracteresEspeciales() {
        // Probar con caracteres especiales en los campos
        String uniqueCode = 'SPECIAL-CHARS-' + System.currentTimeMillis();
        
        List<PAK_WSSAPSERVICETYPE.SapServiceType> services = new List<PAK_WSSAPSERVICETYPE.SapServiceType>();
        
        PAK_WSSAPSERVICETYPE.SapServiceType service = new PAK_WSSAPSERVICETYPE.SapServiceType();
        service.Code = uniqueCode;
        service.activo = true;
        service.name = 'Servicio con ñ & áéíóú ü ¡¿?';
        service.grupo = 'SP-SL-SERV LOGISTICO'; // Valor válido del picklist
        service.retentionISR = null; // Este campo no tiene valores
        service.retention = 'SI'; // Valor válido
        service.VAT = null;
        
        services.add(service);
        
        Test.startTest();
        List<PAK_WSSAPSERVICETYPE.status> results = PAK_WSSAPSERVICETYPE.SFMESSAGES(services);
        Test.stopTest();
        
        System.debug('Resultados testCaracteresEspeciales: ' + results);
    }        

    
}