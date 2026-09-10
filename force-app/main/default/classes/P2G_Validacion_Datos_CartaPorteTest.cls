/**
 * Tests de P2G_Validacion_Datos_CartaPorte con datos propios.
 * Sin SeeAllData ni IDs fijos de org: corre igual en UAT y Produccion.
 * Los Datos_Carta_Porte del shipment nacen en el INSERT de la factory;
 * los tests no hacen update del Shipment fuera de Test.startTest() porque
 * la cascada de triggers del Shipment en Produccion consume el limite SOQL.
 */
@isTest
private class P2G_Validacion_Datos_CartaPorteTest {

    @testSetup
    static void setup() {
        P2G_CartaPorte_TestFactory.crearDatosCompletos();
    }

    private static Shipment__c getShipment() {
        return [SELECT Id, Account_for__c, isInverted__c
                FROM Shipment__c
                WHERE Name = :P2G_CartaPorte_TestFactory.SHIPMENT_NAME
                LIMIT 1];
    }

    @isTest
    static void testGetAccountByShipment() {
        Shipment__c sp = getShipment();

        Test.startTest();
        Boolean sandbox = P2G_Validacion_Datos_CartaPorte.isSandbox();
        Boolean result = P2G_Validacion_Datos_CartaPorte.getAccountByShipment(sp.Id);
        Test.stopTest();

        if (sandbox) {
            System.assertEquals(true, result, 'En sandbox siempre regresa true');
        } else {
            System.assertEquals(false, result, 'La cuenta de prueba no es la cuenta fija de produccion');
        }
    }

    @isTest
    static void testUpdateShipmentData() {
        Shipment__c sp = getShipment();
        List<String> datosOrigen = new List<String>{ 'TEST123', 'Test Destinatario' };
        List<String> datosDestino = new List<String>{ 'DEST456', 'Razon Test' };

        Test.startTest();
        P2G_Validacion_Datos_CartaPorte.updateShipmentData(sp.Id, datosOrigen, datosDestino);
        Test.stopTest();

        Shipment__c actualizado = [SELECT Datos_Carta_Porte__c, Datos_Carta_Porte_Destino__c
                                   FROM Shipment__c WHERE Id = :sp.Id];
        System.assertEquals('RFC DESTINATARIO:TEST123,DESTINATARIO:Test Destinatario', actualizado.Datos_Carta_Porte__c);
        System.assertEquals('RFC Destino:DEST456,Razon Social:Razon Test', actualizado.Datos_Carta_Porte_Destino__c);
    }

    @isTest
    static void testUpdateShipmentData_EmptyList() {
        Shipment__c sp = getShipment();

        Test.startTest();
        P2G_Validacion_Datos_CartaPorte.updateShipmentData(sp.Id, new List<String>(), new List<String>());
        P2G_Validacion_Datos_CartaPorte.updateShipmentData(null, new List<String>(), new List<String>());
        Test.stopTest();

        Shipment__c actualizado = [SELECT Datos_Carta_Porte__c FROM Shipment__c WHERE Id = :sp.Id];
        System.assert(String.isBlank(actualizado.Datos_Carta_Porte__c), 'Listas vacias dejan el campo vacio');
    }

    @isTest
    static void testGetDatosCartaPorte() {
        // El valor nace en el insert de la factory: sin update.
        Shipment__c sp = getShipment();

        Test.startTest();
        String result = P2G_Validacion_Datos_CartaPorte.getDatosCartaPorte(sp.Id);
        Test.stopTest();

        System.assertEquals(P2G_CartaPorte_TestFactory.DATOS_ORIGEN, result);
    }

    @isTest
    static void testGetDatosCartaPorteBoth_ConDatosEnShipment() {
        Shipment__c sp = getShipment();

        Test.startTest();
        Map<String, String> result = P2G_Validacion_Datos_CartaPorte.getDatosCartaPorteBoth(sp.Id);
        Test.stopTest();

        System.assertEquals(P2G_CartaPorte_TestFactory.DATOS_ORIGEN, result.get('origen'));
        System.assertEquals(P2G_CartaPorte_TestFactory.DATOS_DESTINO, result.get('destino'));
    }

    @isTest
    static void testBuilders() {
        // Ramas de armado desde el folio (sin tocar el shipment).
        Customer_Quote__c quote = P2G_Validacion_Datos_CartaPorte.getRelatedCustomerQuote(getShipment().Id);
        System.assertNotEquals(null, quote, 'La factory relaciona un folio al shipment');

        Test.startTest();
        String origenQuote = P2G_Validacion_Datos_CartaPorte.buildOrigenString(null, quote);
        String destinoQuote = P2G_Validacion_Datos_CartaPorte.buildDestinoString(null, quote);
        String origenVacio = P2G_Validacion_Datos_CartaPorte.buildOrigenString(null, null);
        String destinoVacio = P2G_Validacion_Datos_CartaPorte.buildDestinoString(null, null);
        Test.stopTest();

        System.assert(origenQuote.startsWith('RFC DESTINATARIO:'), 'Origen armado desde el folio');
        System.assert(destinoQuote.startsWith('RFC Destino:'), 'Destino armado desde el folio');
        System.assertEquals('', origenVacio);
        System.assertEquals('', destinoVacio);
    }

    @isTest
    static void testToggleIsInverted() {
        Shipment__c sp = getShipment();
        System.assertEquals(false, sp.isInverted__c, 'Nace en false');

        Test.startTest();
        P2G_Validacion_Datos_CartaPorte.updateFieldIsInverted(sp.Id);
        Test.stopTest();

        Shipment__c invertido = P2G_Validacion_Datos_CartaPorte.getShipmentIsInverted(sp.Id);
        System.assertEquals(true, invertido.isInverted__c, 'El primer clic invierte a true');
    }
}
