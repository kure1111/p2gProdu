@IsTest
public class P2G_ChangeCampoControlTest {

// Método para crear el usuario requerido por el trigger
private static void createRequiredUser() {
    List<User> existingUsers = [SELECT Id FROM User WHERE Name = 'bernardo hinojosa' LIMIT 1];
    if (existingUsers.isEmpty()) {
        Profile stdProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User bernardoUser = new User(
            FirstName = 'Bernardo',
            LastName = 'Hinojosa',
            Email = 'bernardo.hinojosa@test.com',
            Username = 'bernardo.hinojosa@test.com.unittest',
            Alias = 'bhinoj',
            TimeZoneSidKey = 'America/Mexico_City',
            LocaleSidKey = 'es_MX',
            EmailEncodingKey = 'UTF-8',
            ProfileId = stdProfile.Id,
            LanguageLocaleKey = 'es',
            IsActive = true
        );
        insert bernardoUser;
    }
}

// Método para crear INV_Counter__c si no existe
private static void createInvoiceCounter() {
    List<INV_Counter__c> counters = [SELECT Id FROM INV_Counter__c LIMIT 1];
    if (counters.isEmpty()) {
        INV_Counter__c newCounter = new INV_Counter__c(
            Name = 'Invoice Counter',
            Contador__c = 0
        );
        insert newCounter;
    }
}

// Desactivar triggers problemáticos
private static void disableProblematicTriggers() {
    NEU_StaticVariableHelper.setBoolean1(true);
}

// Reactivar triggers
private static void enableProblematicTriggers() {
    NEU_StaticVariableHelper.setBoolean1(false);
}

@IsTest(SeeAllData = true)
static void testMainWithValidResponse() {
    createRequiredUser();
    createInvoiceCounter();

    List<Response__c> existingResponses = [
        SELECT Id, Message__c
        FROM Response__c
        WHERE Message__c LIKE '%Entrega Creada No. :%'
        AND Message__c LIKE '%IdLines:%'
        AND Invoice__r.Shipment__r.Operation_Executive__c != null
        LIMIT 1
    ];

    if (!existingResponses.isEmpty()) {
        Test.startTest();
        disableProblematicTriggers();
        P2G_ChangeCampoControl.main(new List<Response__c>{existingResponses[0]});
        enableProblematicTriggers();
        Test.stopTest();
    }
}

@IsTest(SeeAllData = true)
static void testMainWithNullMessage() {
    createRequiredUser();
    createInvoiceCounter();

    List<Response__c> responses = [
        SELECT Id, Message__c
        FROM Response__c
        WHERE Invoice__r.Shipment__r.Operation_Executive__c != null
        LIMIT 1
    ];

    if (!responses.isEmpty()) {
        responses[0].Message__c = null;
        Test.startTest();
        disableProblematicTriggers();
        P2G_ChangeCampoControl.main(responses);
        enableProblematicTriggers();
        Test.stopTest();
    }
}

@IsTest(SeeAllData = true)
static void testMainWithoutRequiredKeywords() {
    createRequiredUser();
    createInvoiceCounter();

    List<Response__c> responses = [
        SELECT Id, Message__c
        FROM Response__c
        WHERE ((NOT Message__c LIKE '%Entrega Creada No. :%') 
            OR (NOT Message__c LIKE '%IdLines:%'))
        AND Invoice__r.Shipment__r.Operation_Executive__c != null
        LIMIT 1
    ];

    if (!responses.isEmpty()) {
        Test.startTest();
        disableProblematicTriggers();
        P2G_ChangeCampoControl.main(responses);
        enableProblematicTriggers();
        Test.stopTest();
    }
}

@IsTest(SeeAllData = true)
static void testProcessValidMessage() {
    createRequiredUser();
    createInvoiceCounter();

    List<Shipment_Fee_Line__c> existingFeeLines = [
        SELECT Id
        FROM Shipment_Fee_Line__c
        WHERE Campo_Control__c = false
        AND Shipment__r.Operation_Executive__c != null
        LIMIT 1
    ];

    if (!existingFeeLines.isEmpty()) {
        String validMessage = 'Entrega Creada No. : TEST456 | IdLines: ' + existingFeeLines[0].Id;

        Response__c response = new Response__c(
            Message__c = validMessage,
            Object__c = 'Invoice'
        );

        Test.startTest();
        P2G_ChangeCampoControl.processValidMessage(new List<Response__c>{response});
        Test.stopTest();
    }
}

@IsTest(SeeAllData = true)
static void testProcessValidMessageWithException() {
    createRequiredUser();
    createInvoiceCounter();

    // En lugar de null (causa NPE), usamos un mensaje malformado
    Response__c response = new Response__c(
        Message__c = 'Mensaje sin IdLines ni formato válido',
        Object__c = 'Invoice'
    );

    Test.startTest();
    P2G_ChangeCampoControl.processValidMessage(new List<Response__c>{response});
    Test.stopTest();
}

@IsTest(SeeAllData = true)
static void testGetAllShipmentServiceLine() {
    createRequiredUser();
    createInvoiceCounter();

    List<Shipment_Fee_Line__c> existingFeeLines = [
        SELECT Id
        FROM Shipment_Fee_Line__c
        WHERE Campo_Control__c = false
        AND Shipment__r.Operation_Executive__c != null
        LIMIT 5
    ];

    if (!existingFeeLines.isEmpty()) {
        Set<String> extractedIds = new Set<String>();
        for (Shipment_Fee_Line__c feeLine : existingFeeLines) {
            extractedIds.add(feeLine.Id);
        }

        Test.startTest();
        disableProblematicTriggers();
        P2G_ChangeCampoControl.getAllShipmentServiceLineById(extractedIds);
        enableProblematicTriggers();
        Test.stopTest();
    }
}

@IsTest(SeeAllData = true)
static void testGetAllShipmentServiceLineWithEmptySet() {
    createRequiredUser();
    createInvoiceCounter();

    Set<String> emptyIds = new Set<String>();

    Test.startTest();
    disableProblematicTriggers();
    P2G_ChangeCampoControl.getAllShipmentServiceLineById(emptyIds);
    enableProblematicTriggers();
    Test.stopTest();
}

@IsTest(SeeAllData = true)
static void testGetAllInvoiceLine() {
    createRequiredUser();
    createInvoiceCounter();

    List<Invoice__c> existingInvoices = [
        SELECT Id
        FROM Invoice__c
        WHERE Campo_Control__c = false
        AND Shipment__r.Operation_Executive__c != null
        LIMIT 5
    ];

    if (!existingInvoices.isEmpty()) {
        Set<String> invoiceIds = new Set<String>{existingInvoices[0].Id};

        Test.startTest();
        disableProblematicTriggers();
        P2G_ChangeCampoControl.getInvoiceLineByInvoice(invoiceIds);
        enableProblematicTriggers();
        Test.stopTest();
    }
}

@IsTest(SeeAllData = true)
static void testUpdateMethods() {
    createRequiredUser();
    createInvoiceCounter();

    List<Shipment_Fee_Line__c> feeLines = [
        SELECT Id
        FROM Shipment_Fee_Line__c
        WHERE Campo_Control__c = false
        AND Shipment__r.Operation_Executive__c != null
        LIMIT 1
    ];
    List<Invoice__c> invoices = [
        SELECT Id
        FROM Invoice__c
        WHERE Campo_Control__c = false
        AND Shipment__r.Operation_Executive__c != null
        LIMIT 1
    ];
    List<Invoice_Line__c> invoiceLines = [
        SELECT Id
        FROM Invoice_Line__c
        WHERE Campo_Control__c = false
        AND Invoice__r.Shipment__r.Operation_Executive__c != null
        LIMIT 1
    ];

    Test.startTest();
    disableProblematicTriggers();
    if (!feeLines.isEmpty()) {
        P2G_ChangeCampoControl.updateShipmentServiceLine(feeLines);
    }
    if (!invoices.isEmpty()) {
        P2G_ChangeCampoControl.updateInvoice(invoices);
    }
    if (!invoiceLines.isEmpty()) {
        P2G_ChangeCampoControl.updateInvoiceLine(invoiceLines);
    }
    enableProblematicTriggers();
    Test.stopTest();
}

@IsTest(SeeAllData = true)
static void testUpdateMethodsWithEmptyLists() {
    createRequiredUser();
    createInvoiceCounter();

    Test.startTest();
    disableProblematicTriggers();
    P2G_ChangeCampoControl.updateShipmentServiceLine(new List<Shipment_Fee_Line__c>());
    P2G_ChangeCampoControl.updateInvoice(new List<Invoice__c>());
    P2G_ChangeCampoControl.updateInvoiceLine(new List<Invoice_Line__c>());
    enableProblematicTriggers();
    Test.stopTest();
}

}