/**
 * Tests de CPV2. Los datos viven en P2G_CartaPorte_TestFactory
 * (receta portable UAT/Produccion, sin IDs fijos).
 * Cada metodo crea su propio juego de datos: en Produccion la cascada de
 * triggers del Shipment consume casi todo el limite SOQL, asi que el estado
 * (isInverted__c) se define en el INSERT, nunca con update.
 */
@isTest()
public class CPV2_Test {

    @isTest
    public static void runTestT() {
        Shipment__c sp = P2G_CartaPorte_TestFactory.crearDatosCompletos('SP-FI-21-280888', false);

        Test.startTest();
        cpv2.getComprobante(sp.Id, 'T');
        cpv2.getComprobante(sp.Id, 'I');
        Test.stopTest();
    }

    @isTest
    public static void runTestInvertido() {
        // Cubre la rama nueva: isInverted__c = true intercambia
        // origen/destino (direcciones y RFC/nombre) en la carta porte.
        Shipment__c sp = P2G_CartaPorte_TestFactory.crearDatosCompletos('SP-FI-21-280889', true);

        Test.startTest();
        cpv2.getComprobante(sp.Id, 'T');
        cpv2.getComprobante(sp.Id, 'I');
        Test.stopTest();
    }
}
