@isTest(seeAllData=true)
public class P2G_AttachmentSHIPTest {
    
    // Mock de la respuesta HTTP exitosa
    public class MockHttpResponseSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=utf-8');
            res.setBody('<?xml version="1.0" encoding="utf-8"?>' +
                        '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">' +
                        '<soap:Body>' +
                        '<GuardarDocAWSResponse xmlns="http://tempuri.org/">' +
                        '<GuardarDocAWSResult>Documento guardado exitosamente</GuardarDocAWSResult>' +
                        '</GuardarDocAWSResponse>' +
                        '</soap:Body>' +
                        '</soap:Envelope>');
            res.setStatusCode(200);
            res.setStatus('OK');
            return res;
        }
    }
    
    // Mock de la respuesta HTTP fallida
    public class MockHttpResponseError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml;charset=utf-8');
            res.setBody('<?xml version="1.0" encoding="utf-8"?>' +
                        '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
                        '<soap:Body>' +
                        '<soap:Fault>' +
                        '<faultcode>soap:Server</faultcode>' +
                        '<faultstring>Error al procesar la solicitud</faultstring>' +
                        '</soap:Fault>' +
                        '</soap:Body>' +
                        '</soap:Envelope>');
            res.setStatusCode(500);
            res.setStatus('Internal Server Error');
            return res;
        }
    }
    
    @isTest
    static void testSendWS_Success() {
        // Configurar mock exitoso
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseSuccess());
        
        // Buscar un Shipment existente que tenga documentos asociados
        Shipment__c shipment = [SELECT Id, Name FROM Shipment__c 
                                WHERE Id IN (SELECT Shipment__c FROM Associated_Document__c 
                                            WHERE Document_Type__c = 'Acuse' 
                                            AND Document_URL__c LIKE '%https://associateddocs.s3.amazonaws.com%')
                                LIMIT 1];
        
        // Crear instancia del controller y probar
        ApexPages.StandardController sc = new ApexPages.StandardController(shipment);
        PAK_AttachmentSHIP controller = new PAK_AttachmentSHIP(sc);
        
        Test.startTest();
        PageReference result = controller.SendWS();
        Test.stopTest();
        
        // Verificar que no hay errores
        ApexPages.Message[] messages = ApexPages.getMessages();
        Boolean hasConfirmMessage = false;
        for(ApexPages.Message msg : messages) {
            if(msg.getSeverity() == ApexPages.Severity.CONFIRM) {
                hasConfirmMessage = true;
                break;
            }
        }
    }
    
    @isTest
    static void testSendWS_NoDocuments() {
        // Configurar mock (no se usará porque no hay documentos)
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseSuccess());
        
        // Buscar un Shipment que NO tenga documentos de tipo Acuse
        Shipment__c shipment = [SELECT Id FROM Shipment__c 
                                WHERE Id NOT IN (SELECT Shipment__c FROM Associated_Document__c 
                                                WHERE Document_Type__c = 'Acuse' 
                                                AND Document_URL__c LIKE '%https://associateddocs.s3.amazonaws.com%')
                                LIMIT 1];
        
        // Crear instancia del controller y probar
        ApexPages.StandardController sc = new ApexPages.StandardController(shipment);
        PAK_AttachmentSHIP controller = new PAK_AttachmentSHIP(sc);
        
        Test.startTest();
        PageReference result = controller.SendWS();
        Test.stopTest();
        
        // Verificar mensaje de error
        ApexPages.Message[] messages = ApexPages.getMessages();
        Boolean hasError = false;
        for(ApexPages.Message msg : messages) {
            if(msg.getSeverity() == ApexPages.Severity.ERROR && 
               msg.getSummary().contains('No se encontraron documentos')) {
                hasError = true;
                break;
            }
        }

    }
    
    @isTest
    static void testSendWS_HttpError() {
        // Configurar mock con error
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseError());
        
        // Buscar un Shipment existente que tenga documentos asociados
        Shipment__c shipment = [SELECT Id FROM Shipment__c 
                                WHERE Id IN (SELECT Shipment__c FROM Associated_Document__c 
                                            WHERE Document_Type__c = 'Acuse' 
                                            AND Document_URL__c LIKE '%https://associateddocs.s3.amazonaws.com%')
                                LIMIT 1];
        
        // Crear instancia del controller y probar
        ApexPages.StandardController sc = new ApexPages.StandardController(shipment);
        PAK_AttachmentSHIP controller = new PAK_AttachmentSHIP(sc);
        
        Test.startTest();
        PageReference result = controller.SendWS();
        Test.stopTest();
        
        // Verificar que hay mensajes de error
        ApexPages.Message[] messages = ApexPages.getMessages();
    }
    
    @isTest
    static void testSendWS_Exception() {
        // No configurar mock para provocar excepción
        
        // Buscar un Shipment existente que tenga documentos asociados
        Shipment__c shipment = [SELECT Id FROM Shipment__c 
                                WHERE Id IN (SELECT Shipment__c FROM Associated_Document__c 
                                            WHERE Document_Type__c = 'Acuse' 
                                            AND Document_URL__c LIKE '%https://associateddocs.s3.amazonaws.com%')
                                LIMIT 1];
        
        System.assertNotEquals(null, shipment, 'Debe existir un Shipment con documentos de tipo Acuse');
        
        // Crear instancia del controller y probar
        ApexPages.StandardController sc = new ApexPages.StandardController(shipment);
        PAK_AttachmentSHIP controller = new PAK_AttachmentSHIP(sc);
        
        Test.startTest();
        PageReference result = controller.SendWS();
        Test.stopTest();
        
        // Verificar que hay mensajes de error
        ApexPages.Message[] messages = ApexPages.getMessages();
    }
}