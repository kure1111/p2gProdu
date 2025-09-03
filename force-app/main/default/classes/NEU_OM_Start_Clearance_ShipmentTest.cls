@isTest(seeAllData=true)
public class NEU_OM_Start_Clearance_ShipmentTest {

    @isTest static void testConstructorAndGetters() {
        // Obtener un Shipment__c existente para pasar al controlador estándar
        Shipment__c sh;

            sh = [SELECT Id FROM Shipment__c LIMIT 1];

        
        ApexPages.StandardController stdController = new ApexPages.StandardController(sh);
        NEU_OM_Start_Clearance_Shipment controller = new NEU_OM_Start_Clearance_Shipment(stdController);
        
        // Probar que el record se cargó
        System.assertNotEquals(null, controller.record, 'Shipment record should be loaded');

        // Probar que getters devuelven valores (simulando getDutyCalculatorInfo con Test.isRunningTest)
        String cats = controller.getlist_category();
        String subcats = controller.getlista_subcategorias();
        String items = controller.getlista_items();
    }
    
    @isTest static void testGetShipmentItemLines() {
        Shipment__c sh;

            sh = [SELECT Id FROM Shipment__c LIMIT 1];
        
        
        // Insertar Shipment_Line__c para el Shipment
        Shipment_Line__c line = [SELECT Id, Shipment__c FROM Shipment_Line__c WHERE Shipment__c = :sh.Id LIMIT 1];


        ApexPages.StandardController stdController = new ApexPages.StandardController(sh);
        NEU_OM_Start_Clearance_Shipment controller = new NEU_OM_Start_Clearance_Shipment(stdController);
        
        List<Shipment_Line__c> lines = controller.getshipmentItemLines();
        System.assert(lines.size() > 0, 'Debe retornar lineas relacionadas al Shipment');

        // Probar getshipmentItemLines2 con idlineaitem
        controller.idlineaitem = line.Id;
        List<Shipment_Line__c> selectedLines = controller.getshipmentItemLines2();
        System.assertNotEquals(null, selectedLines, 'Debe retornar lista no nula');
        System.assertEquals(line.Id, selectedLines[0].Id, 'Debe retornar linea correcta');
    }
    
    @isTest static void testApplyLinesAndCalculateTaxes() {
        Shipment__c sh;

            sh = [SELECT Id FROM Shipment__c LIMIT 1];
       
        
            Shipment_Line__c line = [SELECT Id, Shipment__c FROM Shipment_Line__c limit 1];


        ApexPages.StandardController stdController = new ApexPages.StandardController(sh);
        NEU_OM_Start_Clearance_Shipment controller = new NEU_OM_Start_Clearance_Shipment(stdController);
        
        // Set some fields for calculate_taxes
        controller.idlineactualizar = line.Id;
        controller.category_name = 'TestCategory';
        controller.subcategory_name = 'TestSubcategory';
        controller.item_name = 'TestItem';
        controller.item_field = '87'; // ejemplo de id de item
        
        // Llamar a applyLines, se espera que no falle al actualizar líneas
        Test.startTest();
        PageReference pr = controller.applyLines();

        System.assert(pr != null, 'Debe retornar un PageReference');
        
        // Llamar a calculate_taxes (usa callout mock si se implementa)
        // Aquí, como la clase hace callout, debemos simularlo con HttpCalloutMock para no fallar
        Test.setMock(HttpCalloutMock.class, new DutyCalculatorMock());

        PageReference pr2 = controller.calculate_taxes();
        Test.stopTest();
    }
    
    // Mock para el callout HTTP para DutyCalculator API
    class DutyCalculatorMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            // Respuesta simulada XML con estructura esperada para getDutyCalculatorInfo()
            String responseBody = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"><soap:Header></soap:Header><soap:Body><categories><category name="AntiquesCollectibles" id="L18"><subcategory name="AntiquesYearsOld" id="L29"><item id="87">Antique</item><item id="2163">AntiqueSilverware</item><item id="2164">AntiqueFurniture</item></subcategory><subcategory name="Artwork" id="L2281"><item id="88">OriginalArtWorkpaintingsdrawings</item><item id="2564">OriginalArtWorksculpturesstatuary</item></subcategory></category></categories></soap:Body></soap:Envelope>';
            res.setBody(responseBody);
            return res;
        }
    }
}