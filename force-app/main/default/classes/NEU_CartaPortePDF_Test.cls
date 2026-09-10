/**
 * Tests de NEU_CartaPortePDF con datos propios (sin SeeAllData ni IDs fijos).
 * El shipment de la factory se llama SP-FI-..., por lo que Shipment_Type__c
 * resulta 'FI' y el constructor arma el PDF completo.
 * Cada metodo crea su propio juego de datos y el estado isInverted__c se
 * define en el INSERT (la cascada de triggers del Shipment en Produccion
 * no permite updates sueltos sin reventar el limite de SOQL).
 */
@isTest
private class NEU_CartaPortePDF_Test {

    private static void generarYValidar(Shipment__c shipment) {
        shipment = [SELECT Id, Shipment_Type__c FROM Shipment__c WHERE Id = :shipment.Id];

        PageReference pdfPage = Page.NEU_CartaPortePDF;
        pdfPage.getParameters().put('id', shipment.Id);
        Test.setCurrentPage(pdfPage);
        ApexPages.StandardController stdController = new ApexPages.StandardController(shipment);

        Test.startTest();
        NEU_CartaPortePDF controller = new NEU_CartaPortePDF(stdController);
        NEU_CartaPortePDF.test();
        Test.stopTest();

        if (new Set<String>{ 'FN', 'PTO', 'FI' }.contains(shipment.Shipment_Type__c)) {
            System.assertNotEquals(null, controller.pdf, 'El PDF debe generarse para tipo ' + shipment.Shipment_Type__c);
        }
    }

    @isTest
    static void testPdfGeneration() {
        generarYValidar(P2G_CartaPorte_TestFactory.crearDatosCompletos('SP-FI-21-280888', false));
    }

    @isTest
    static void testPdfGenerationInvertido() {
        generarYValidar(P2G_CartaPorte_TestFactory.crearDatosCompletos('SP-FI-21-280889', true));
    }
}
