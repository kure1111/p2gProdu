@isTest(seeAllData=true) // Permite el acceso a los datos existentes en la organización
private class NEU_CartaPortePDF_Test {

    @isTest
    static void testPdfGeneration() {
        Shipment__c shipment = [SELECT Id FROM Shipment__c WHERE id = 'a0JRQ000004fXlh2AE'];
		
        // Verificar que haya al menos un registro para proceder con la prueba
        if (shipment != null) {
            // Simulamos la página Visualforce y pasamos el 'id' como parámetro
            PageReference pdfPage = Page.NEU_CartaPortePDF;
            pdfPage.getParameters().put('id', shipment.Id);

            // Inicializamos el controlador estándar con el ID del registro
            ApexPages.StandardController stdController = new ApexPages.StandardController(shipment);

            // Creamos la instancia de la clase que estamos probando
            NEU_CartaPortePDF controller = new NEU_CartaPortePDF(stdController);

            // Ejecutamos la lógica para verificar que no se produzcan errores
            Test.startTest();
            controller.record = shipment;  // Simulamos la asignación del registro
            controller.pdf = 'Dummy PDF';  // Asignación simulada para verificar la ejecución
            NEU_CartaPortePDF.test();
            Test.stopTest();
        }
    }
}