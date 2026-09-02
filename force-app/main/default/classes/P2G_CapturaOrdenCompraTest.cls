@isTest(SeeAllData=true)
public class P2G_CapturaOrdenCompraTest {

    @isTest
    static void testMainUpdatesOrdenCompra() {
        List<Shipment_Fee_Line__c> targetLines = [
            SELECT Id, Shipment__c, Orden_Compra__c
            FROM Shipment_Fee_Line__c
            WHERE Orden_Compra__c = NULL
              AND Shipment__c != NULL
              AND Shipment__r.Traslado_Ingreso__c != NULL
              AND (Shipment__r.ShipmentService__c = 'SP-M' OR Shipment__r.ShipmentService__c = 'SP-A')
              AND Shipment__r.account_for__c != NULL
              AND Service_Rate_Name__r.Account_for__c != NULL      
            ORDER BY CreatedDate DESC        
            LIMIT 5
        ];

        Set<Id> shipmentIds = new Set<Id>();
        for (Shipment_Fee_Line__c line : targetLines) {
            shipmentIds.add(line.Shipment__c);
        }

        List<Response__c> newResponses = new List<Response__c>();
        Integer i = 0;
        for (Id shipId : shipmentIds) {
            Response__c res = new Response__c();
            res.Type__c = 'CONFIRM';
            res.SolOrdenCompraSAP__c = 'OC-TEST-' + i;
            res.Object__c = 'Shipment';
            res.Shipment__c = shipId;            
            newResponses.add(res);
            i++;
        }

        insert newResponses;

        Test.startTest();
        P2G_CapturaOrdenCompra.main(newResponses);
        Test.stopTest();

        // Verificar que los Shipment_Fee_Line__c se actualizaron con la Orden de Compra
        List<Shipment_Fee_Line__c> updatedLines = [
            SELECT Id, Orden_Compra__c
            FROM Shipment_Fee_Line__c
            WHERE Id IN :targetLines
        ];
        for (Shipment_Fee_Line__c line : updatedLines) {
            System.assertNotEquals(null, line.Orden_Compra__c, 'La orden de compra debe haberse actualizado');
        }
    }

    @isTest
    static void testMainWithNoMatchingResponses() {
        Shipment__c anyShipment = [
            SELECT Id FROM Shipment__c 
            WHERE Traslado_Ingreso__c != NULL
              AND account_for__c != NULL 
            ORDER BY CreatedDate DESC               
            LIMIT 1
        ];

        Response__c invalidResponse = new Response__c();
        invalidResponse.Type__c = 'ERROR';
        invalidResponse.SolOrdenCompraSAP__c = 'OC-INVALID';
        invalidResponse.Object__c = 'Shipment';
        invalidResponse.Shipment__c = anyShipment.Id;
        insert invalidResponse;

        Test.startTest();
        P2G_CapturaOrdenCompra.main(new List<Response__c>{invalidResponse});
        Test.stopTest();
    }

    @isTest
    static void testMainWithNullShipmentInResponse() {
        Response__c nullShipmentRes = new Response__c();
        nullShipmentRes.Type__c = 'CONFIRM';
        nullShipmentRes.SolOrdenCompraSAP__c = 'OC-IGNORE';
        nullShipmentRes.Object__c = 'Shipment';
        nullShipmentRes.Shipment__c = null;
        insert nullShipmentRes;

        Test.startTest();
        P2G_CapturaOrdenCompra.main(new List<Response__c>{nullShipmentRes});
        Test.stopTest();
    }

    @isTest
    static void testEditOrdenCompraDirectly() {
        Shipment__c anyShipment = [
            SELECT Id 
            FROM Shipment__c 
            WHERE Traslado_Ingreso__c != NULL
              AND account_for__c != NULL 
            ORDER BY CreatedDate DESC                
            LIMIT 1
        ];
        
        List<Shipment_Fee_Line__c> feeLines = [
            SELECT Id, Shipment__c, Orden_Compra__c
            FROM Shipment_Fee_Line__c
            WHERE Shipment__c = :anyShipment.Id
              AND Orden_Compra__c = NULL
            LIMIT 1
        ];
        
        if (!feeLines.isEmpty()) {
            Map<Id, String> testMap = new Map<Id, String>();
            testMap.put(anyShipment.Id, 'OC-DIRECT-TEST');
            
            Test.startTest();
            P2G_CapturaOrdenCompra.editOrdenCompra(feeLines, testMap);
            Test.stopTest();

            // Verificar actualización
            Shipment_Fee_Line__c updatedLine = [SELECT Orden_Compra__c FROM Shipment_Fee_Line__c WHERE Id = :feeLines[0].Id];
            System.assertEquals('OC-DIRECT-TEST', updatedLine.Orden_Compra__c);
        }
    }
}