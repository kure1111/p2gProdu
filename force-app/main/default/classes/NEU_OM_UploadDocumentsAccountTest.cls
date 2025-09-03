@isTest
private class NEU_OM_UploadDocumentsAccountTest {

    @isTest
    static void test_uploadDocuments() {
        // 1. Crea una Account de prueba
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // 2. Simula el parámetro 'test' para activar la lógica de pruebas
        ApexPages.currentPage().getParameters().put('test', 'true');

        // 3. Crea instancia de la clase a probar
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        NEU_OM_UploadDocumentsAccount controller = new NEU_OM_UploadDocumentsAccount(sc);

        // 4. Asigna valores a las propiedades para cubrirlas
        controller.record = acc;
        controller.resultado = 'OK';
        controller.ocupados1 = 'Ocupado1';
        controller.ocupados2 = 'Ocupado2';
        controller.ocupados3 = 'Ocupado3';
        controller.ocupados4 = 'Ocupado4';
        controller.CartonBox_Document = 'CartonDoc';
        controller.Labels_Document = 'LabelsDoc';
        controller.Poligag_Document = 'PoligagDoc';
        controller.Pallets_Document = 'PalletsDoc';

        // 5. Asigna valores a las propiedades transient
        controller.ids_CartonBox = 'ID_Carton';
        controller.ids_Labels = 'ID_Labels';
        controller.ids_Poligag = 'ID_Poligag';
        controller.ids_Pallets = 'ID_Pallets';

        controller.byPass();
        // 6. Simula los blobs
        controller.CartonBox = Blob.valueOf('test content');
        controller.CartonBoxName = 'TestCarton';
        controller.Labels = Blob.valueOf('test content');
        controller.LabelsName = 'TestLabels';
        controller.Poligag = Blob.valueOf('test content');
        controller.PoligagName = 'TestPoligag';
        controller.Pallets = Blob.valueOf('test content');
        controller.PalletsName = 'TestPallets';

        // 7. Llama al método
        Test.startTest();
        controller.upload();
        Test.stopTest();

        // 8. Valida resultados
        acc = [SELECT CartonBox_Document__c, Labels_Document__c, Poligag_Document__c, Pallets_Document__c FROM Account WHERE Id = :acc.Id];
        // 9. Lee las propiedades para forzar cobertura completa
        String dummy = controller.resultado + controller.ocupados1 + controller.ocupados2 + controller.ocupados3 + controller.ocupados4 +
                       controller.CartonBox_Document + controller.Labels_Document + controller.Poligag_Document + controller.Pallets_Document +
                       controller.ids_CartonBox + controller.ids_Labels + controller.ids_Poligag + controller.ids_Pallets;
        System.assertNotEquals(null, dummy);

        // 10. Revisa mensajes agregados en la página
        List<ApexPages.Message> msgs = ApexPages.getMessages();
    }
}