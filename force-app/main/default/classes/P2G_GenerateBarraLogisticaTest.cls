@isTest(SeeAllData=true)
public class P2G_GenerateBarraLogisticaTest {
    

    @isTest
    static void testMainShipment() {
        List<Shipment__c> shipments = [
            SELECT Id, Carrier__c, Requiere_barras_logisticas__c
            FROM Shipment__c
            WHERE Carrier__c != null AND Requiere_barras_logisticas__c = false AND Shipment_Type__c='FN'
            LIMIT 1
        ];
        if (!shipments.isEmpty()) {
            Shipment__c oldShip = shipments[0];
            Shipment__c newShip = new Shipment__c(
                Id = oldShip.Id,
                Carrier__c = oldShip.Carrier__c,
                Requiere_barras_logisticas__c = true
            );
            Map<Id, Shipment__c> oldMap = new Map<Id, Shipment__c>{oldShip.Id => oldShip};
            P2G_GenerateBarraLogistica obj = new P2G_GenerateBarraLogistica();
            obj.mainShipment(new List<Shipment__c>{newShip}, oldMap);
        }
    }

    @isTest
    static void testCreateBarraLogistica_SinBarra() {
        List<Shipment__c> shipments = [
            SELECT Id, Carrier__c
            FROM Shipment__c
            WHERE Carrier__c != null
                AND Id NOT IN (SELECT Shipment__c FROM Barra_Logistica__c)
            LIMIT 1
        ];
        if (!shipments.isEmpty()) {
            P2G_GenerateBarraLogistica.createBarraLogistica(shipments[0]);
        }
    }

    @isTest
    static void testCreateBarraLogistica_ConBarra() {
        List<Shipment__c> shipments = [
            SELECT Id, Carrier__c
            FROM Shipment__c
            WHERE Carrier__c != null
                AND Id IN (SELECT Shipment__c FROM Barra_Logistica__c)
            LIMIT 1
        ];
        if (!shipments.isEmpty()) {
            P2G_GenerateBarraLogistica.createBarraLogistica(shipments[0]);
        }
    }

    @isTest
    static void testGetDataToCarrier() {
        List<Shipment__c> shipments = [
            SELECT Carrier__c
            FROM Shipment__c
            WHERE Carrier__c != null
            LIMIT 1
        ];
        if (!shipments.isEmpty()) {
            P2G_GenerateBarraLogistica.getDataToCarrier(shipments[0].Carrier__c);
        }
    }

    @isTest
    static void testMainBarraLogistica() {
        List<Barra_Logistica__c> barras = [
            SELECT Id, Account__c, Faltantes__c, Danadas__c
            FROM Barra_Logistica__c
            WHERE Account__c != null
            LIMIT 1
        ];
        if (!barras.isEmpty()) {
            Barra_Logistica__c oldBarra = barras[0];
            Barra_Logistica__c newBarra = new Barra_Logistica__c(
                Id = oldBarra.Id,
                Account__c = oldBarra.Account__c,
                Faltantes__c = (oldBarra.Faltantes__c != null ? oldBarra.Faltantes__c + 1 : 1),
                Danadas__c = oldBarra.Danadas__c
            );
            Map<Id, Barra_Logistica__c> oldMap = new Map<Id, Barra_Logistica__c>{oldBarra.Id => oldBarra};
            P2G_GenerateBarraLogistica obj = new P2G_GenerateBarraLogistica();
            obj.mainBarraLogistica(new List<Barra_Logistica__c>{newBarra}, oldMap);
        }
    }

    @isTest
    static void testUpdateBarraLogistica() {
        List<Barra_Logistica__c> barras = [
            SELECT Id, Account__c, Faltantes__c, Danadas__c
            FROM Barra_Logistica__c
            WHERE Account__c != null
            LIMIT 1
        ];
        if (!barras.isEmpty()) {
            P2G_GenerateBarraLogistica.updateBarraLogistica(barras[0]);
        }
    }
    

    @isTest
    static void testShipmentTrigger() {        
        List<Shipment__c> shipments = [
            SELECT Id, Carrier__c, Requiere_barras_logisticas__c
            FROM Shipment__c
            WHERE Carrier__c != null AND Requiere_barras_logisticas__c = false
            LIMIT 1
        ];
        if (!shipments.isEmpty()) {
            Shipment__c s = shipments[0];
            s.Requiere_barras_logisticas__c = true;
            update s; // Dispara ShipmentTrigger (after update)
        }
    }

    @isTest
    static void testBarraLogisticaTrigger() {
        // Buscar una Barra_Logistica para actualizar y disparar el trigger before update
        List<Barra_Logistica__c> barras = [
            SELECT Id, Account__c, Faltantes__c, Danadas__c
            FROM Barra_Logistica__c
            WHERE Account__c != null
            LIMIT 1
        ];
        if (!barras.isEmpty()) {
            Barra_Logistica__c b = barras[0];
            b.Faltantes__c = (b.Faltantes__c != null ? b.Faltantes__c + 1 : 1);
            update b; 
        }
    }
    @isTest
    static void testBarraLogisticaTrigger_Update() {
            
        Account carrier = [
            SELECT Id,
                   Costo_reposicion_barra_logistica__c
            FROM Account
            WHERE Name = 'ALMACEN 2GO LOGISTIC CARRIER'
            LIMIT 1
        ];
    
    
        Barra_Logistica__c barra = new Barra_Logistica__c(
            Account__c = carrier.Id,
            Faltantes__c = 1,
            Danadas__c = 1
        );
    
        insert barra;
    
        Test.startTest();
            
        barra.Faltantes__c = 5;
    
        update barra;
    
        Test.stopTest();
    }
}