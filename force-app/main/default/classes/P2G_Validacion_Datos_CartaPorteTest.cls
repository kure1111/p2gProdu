@isTest
    public class P2G_Validacion_Datos_CartaPorteTest {
        @isTest(SeeAllData=true)
        static void testGetAccountByShipment_Sandbox() {
            
            //UAT->0014T000005QxaZQAS ,PROD->0014T000005QxaZQAS
            Account testAccount = [SELECT Id FROM Account WHERE Id='0014T000005QxaZQAS' LIMIT 1];
            Shipment__c testShipment = [SELECT Id, Account_for__c, Service_Mode__c, Account_Destination_Address__c,LastModifiedDate
            FROM Shipment__c WHERE Account_for__c =:testAccount.Id AND Traslado_Ingreso__c != null 
            AND (
                (Service_Mode__c = 'NATIONAL' AND Account_Destination_Address__r.status__c = 'Validado' AND Account_Destination_Address__r.Active__c = true)
                OR    
                (Service_Mode__c = 'PORT' AND Account_Destination_Address__r.status__c = 'Validado' AND Account_Destination_Address__r.Active__c = true)
                OR        
                (Service_Mode__c NOT IN ('NATIONAL', 'PORT') AND Account_Destination_Address__c != null)
                )
                ORDER BY LastModifiedDate DESC
                LIMIT 1];
            Test.setMock(HttpCalloutMock.class, new MockOrganizationResponse(true));
            
            Test.startTest();
            Boolean result = P2G_Validacion_Datos_CartaPorte.getAccountByShipment(testShipment.Id);
            Test.stopTest();
        }
        
        @isTest(SeeAllData=true)
        static void testGetAccountByShipment_Production() {
            
            Account testAccount = [SELECT Id FROM Account WHERE Id='0014T000005QxaZQAS' LIMIT 1];
            Shipment__c testShipment = [SELECT Id, Account_for__c, Service_Mode__c, Account_Destination_Address__c, LastModifiedDate
            FROM Shipment__c WHERE Account_for__c =:testAccount.Id AND Traslado_Ingreso__c != null 
            AND (
                (Service_Mode__c = 'NATIONAL' AND Account_Destination_Address__r.status__c = 'Validado' AND Account_Destination_Address__r.Active__c = true)
                OR    
                (Service_Mode__c = 'PORT' AND Account_Destination_Address__r.status__c = 'Validado' AND Account_Destination_Address__r.Active__c = true)
                OR        
                (Service_Mode__c NOT IN ('NATIONAL', 'PORT') AND Account_Destination_Address__c != null)
                )
                ORDER BY LastModifiedDate DESC
                LIMIT 1];
            testShipment.Account_for__c = testAccount.Id;
            update testShipment;
            
            // Configurar mock para Organization
            Test.setMock(HttpCalloutMock.class, new MockOrganizationResponse(false));
            
            Test.startTest();
            Boolean result = P2G_Validacion_Datos_CartaPorte.getAccountByShipment(testShipment.Id);
            Test.stopTest();
            
            
        }
        
        @isTest
        static void testIsSandbox() {
            
            Test.setMock(HttpCalloutMock.class, new MockOrganizationResponse(true));
            
            Test.startTest();
            Boolean result = P2G_Validacion_Datos_CartaPorte.isSandbox();
            Test.stopTest();
            
        }
        
        
        @isTest(SeeAllData=true)
        static void testUpdateShipmentData() {
            Shipment__c testShipment = [SELECT Id, Account_for__c, Service_Mode__c, Account_Destination_Address__c,LastModifiedDate
            FROM Shipment__c WHERE Traslado_Ingreso__c != null 
            AND (
                (Service_Mode__c = 'NATIONAL' AND Account_Destination_Address__r.status__c = 'Validado' AND Account_Destination_Address__r.Active__c = true)
                OR    
                (Service_Mode__c = 'PORT' AND Account_Destination_Address__r.status__c = 'Validado' AND Account_Destination_Address__r.Active__c = true)
                OR        
                (Service_Mode__c NOT IN ('NATIONAL', 'PORT') AND Account_Destination_Address__c != null)
                )
                ORDER BY LastModifiedDate DESC
                LIMIT 1];
            List<String> testData = new List<String>{'TEST123', 'Test Destinatario'};
            
            Test.startTest();
            P2G_Validacion_Datos_CartaPorte.updateShipmentData(testShipment.Id, testData);
            Test.stopTest();
            
        }
        
        @isTest(SeeAllData=true)
        static void testGetDatosCartaPorte() {
            Shipment__c testShipment = [SELECT Id, Account_for__c, Service_Mode__c, Account_Destination_Address__c, LastModifiedDate
            FROM Shipment__c WHERE Traslado_Ingreso__c != null 
            AND (
                (Service_Mode__c = 'NATIONAL' AND Account_Destination_Address__r.status__c = 'Validado' AND Account_Destination_Address__r.Active__c = true)
                OR    
                (Service_Mode__c = 'PORT' AND Account_Destination_Address__r.status__c = 'Validado' AND Account_Destination_Address__r.Active__c = true)
                OR        
                (Service_Mode__c NOT IN ('NATIONAL', 'PORT') AND Account_Destination_Address__c != null)
                )
                ORDER BY LastModifiedDate DESC
                LIMIT 1];
            testShipment.Datos_Carta_Porte__c = 'RFC DESTINATARIO:TEST123,DESTINATARIO:Test Destinatario';
            update testShipment;
            
            Test.startTest();
            String result = P2G_Validacion_Datos_CartaPorte.getDatosCartaPorte(testShipment.Id);
            Test.stopTest();                    
        }
        
        @isTest(SeeAllData=true)
        static void testUpdateShipmentData_EmptyList() {
            Shipment__c testShipment = [SELECT Id, Account_for__c, Service_Mode__c, Account_Destination_Address__c, LastModifiedDate
            FROM Shipment__c WHERE Traslado_Ingreso__c != null 
            AND (
                (Service_Mode__c = 'NATIONAL' AND Account_Destination_Address__r.status__c = 'Validado' AND Account_Destination_Address__r.Active__c = true)
                OR    
                (Service_Mode__c = 'PORT' AND Account_Destination_Address__r.status__c = 'Validado' AND Account_Destination_Address__r.Active__c = true)
                OR        
                (Service_Mode__c NOT IN ('NATIONAL', 'PORT') AND Account_Destination_Address__c != null)
                )
                ORDER BY LastModifiedDate DESC
                LIMIT 1];
            
            Test.startTest();
            P2G_Validacion_Datos_CartaPorte.updateShipmentData(testShipment.Id, new List<String>());
            Test.stopTest();
            
        }
        
        private class MockOrganizationResponse implements HttpCalloutMock {
            private Boolean isSandbox;
            
            public MockOrganizationResponse(Boolean isSandbox) {
                this.isSandbox = isSandbox;
            }
            
            public HTTPResponse respond(HTTPRequest req) {
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
            res.setBody('{"IsSandbox":' + isSandbox + '}');
            res.setStatusCode(200);
            return res;
        }
    }
}