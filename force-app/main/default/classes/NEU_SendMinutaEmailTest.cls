@isTest(seeAllData=true)
private class NEU_SendMinutaEmailTest {

    @isTest static void testSendMinutaEmail() {
        // Buscar un Event existente que tenga relaciones asociadas
        Event e = [
            SELECT Id, Subject 
            FROM Event 
            WHERE Id IN (SELECT EventId FROM EventRelation)
            LIMIT 1
        ];

        // Crear el StandardController con ese evento
        ApexPages.StandardController sc = new ApexPages.StandardController(e);

        Test.startTest();
        NEU_SendMinutaEmail controller = new NEU_SendMinutaEmail(sc);
        controller.send_email();
        controller.byPass();
        Test.stopTest();
    }
}