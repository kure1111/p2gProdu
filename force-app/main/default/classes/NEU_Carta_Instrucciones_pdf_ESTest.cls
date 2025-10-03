@isTest(seeAllData=true)
private class NEU_Carta_Instrucciones_pdf_ESTest {

    @isTest
    static void testCartaInstruccionesPDF() {
        // Obtenemos un Shipment__c que ya exista en la org
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];

        if (shipment != null) {
            // Cargamos la página Visualforce asociada
            PageReference pageRef = Page.NEU_Carta_Instrucciones_pdf_ES;
            pageRef.getParameters().put('id', shipment.Id);

            // Creamos un StandardController pasando el registro
            ApexPages.StandardController sc = new ApexPages.StandardController(shipment);

            // Instanciamos el controlador de la clase que estamos probando
            NEU_Carta_Instrucciones_pdf_ES cartaPdf = new NEU_Carta_Instrucciones_pdf_ES(sc);

            // Solo ejecutamos la lógica, sin asserts
            Test.startTest();
            cartaPdf.carta = 'Contenido de prueba';
            Test.stopTest();
        }
    }
}