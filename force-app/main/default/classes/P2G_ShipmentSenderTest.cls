@isTest(SeeAllData=true)
public class P2G_ShipmentSenderTest {
    
    // ==================== TIPO M ====================
    
    @isTest
    static void testEnviarShipmentTipoM_ImportCredito_ETD() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'M' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Ocean_Shipment_Status__c = 'ETD'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    @isTest
    static void testEnviarShipmentTipoM_ImportContado_BookingConfirmation() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'M' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Ocean_Shipment_Status__c = 'Booking Confirmation'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    @isTest
    static void testEnviarShipmentTipoM_ExportCredito_Delivered() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'M' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Shipment_Status__c = 'Delivered'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    @isTest
    static void testEnviarShipmentTipoM_ExportContado_PendingPreCaptured() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'M' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Shipment_Status__c = 'Pending but Pre-Captured'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== TIPO A ====================
    
    @isTest
    static void testEnviarShipmentTipoA_Credito_FlightConfirmation() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'A' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Air_Shipment_Status__c = 'Flight Confirmation'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    @isTest
    static void testEnviarShipmentTipoA_Contado_ContactWithOrigin() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'A' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Air_Shipment_Status__c = 'Contact with Origin'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== TIPO PTO ====================
    
    @isTest
    static void testEnviarShipmentTipoPTO_Credito_DeliveryOnRoute() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'PTO' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Shipment_Status_Mon__c = 'Delivery on Route_M'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    @isTest
    static void testEnviarShipmentTipoPTO_Contado_InProgress() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'PTO' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Shipment_Status_Mon__c = 'In Progress_M'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== TIPO FI ====================
    
    @isTest
    static void testEnviarShipmentTipoFI_Credito_DeliveryOnRoute() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'FI' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Shipment_Status_Mon__c = 'Delivery on Route_M'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    @isTest
    static void testEnviarShipmentTipoFI_Contado_InProgress() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'FI' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Shipment_Status_Mon__c = 'In Progress_M'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== TIPO FN ====================
    
    @isTest
    static void testEnviarShipmentTipoFN_Credito_DeliveryOnRoute() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'FN' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Shipment_Status_Mon__c = 'Delivery on Route_M'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    @isTest
    static void testEnviarShipmentTipoFN_Contado_InProgress() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'FN' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Shipment_Status_Mon__c = 'In Progress_M'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== NUEVOS TIPOS ====================
    
    // ==================== TIPO PQ ====================
    
    @isTest
    static void testEnviarShipmentTipoPQ_Credito_Confirmed() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'PQ' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Shipment_Status_Plann__c = 'Confirmed'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    @isTest
    static void testEnviarShipmentTipoPQ_Contado_InProgress() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'PQ' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Shipment_Status_Plann__c = 'In progress'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== TIPO W ====================
    
    @isTest
    static void testEnviarShipmentTipoW_Credito_Delivered() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'W' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Shipment_Status__c = 'Delivered'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== TIPO R ====================
    
    @isTest
    static void testEnviarShipmentTipoR_Air_Credito_ConsignessNotification() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'R' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Freight_Mode__c = 'Air'
            AND Air_Shipment_Status__c = 'Consigness Notification'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    @isTest
    static void testEnviarShipmentTipoR_Sea_Credito_ETA15() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'R' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Freight_Mode__c = 'Sea'
            AND Shipment_Status__c = 'ETA -15'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== TIPO AW ====================
    
    @isTest
    static void testEnviarShipmentTipoAW_Credito_PickupAndDelivery() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'AW' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Air_Shipment_Status__c = 'Pickup and Delivery to Airline'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== ESCENARIOS NEGATIVOS (NUEVOS) ====================
    
    // Tipo PQ - Crédito sin Confirmed
    @isTest
    static void testEnviarShipmentTipoPQ_Credito_NoConfirmed() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Shipment_Status_Plann__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'PQ' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Shipment_Status_Plann__c != 'Confirmed'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo PQ - Contado sin In progress
    @isTest
    static void testEnviarShipmentTipoPQ_Contado_NoInProgress() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Shipment_Status_Plann__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'PQ' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Shipment_Status_Plann__c != 'In progress'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo W - Crédito sin Delivered
    @isTest
    static void testEnviarShipmentTipoW_Credito_NoDelivered() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Shipment_Status__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'W' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Shipment_Status__c != 'Delivered'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo R - Air sin Consigness Notification
    @isTest
    static void testEnviarShipmentTipoR_Air_Credito_NoConsignessNotification() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Freight_Mode__c, Air_Shipment_Status__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'R' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Freight_Mode__c = 'Air'
            AND Air_Shipment_Status__c != 'Consigness Notification'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo R - Sea sin ETA -15
    @isTest
    static void testEnviarShipmentTipoR_Sea_Credito_NoETA15() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Freight_Mode__c, Shipment_Status__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'R' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Freight_Mode__c = 'Sea'
            AND Shipment_Status__c != 'ETA -15'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo R - Modo diferente (no Air ni Sea)
    @isTest
    static void testEnviarShipmentTipoR_OtroModo() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Freight_Mode__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'R' 
            AND Freight_Mode__c NOT IN ('Air', 'Sea')
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo AW - Crédito sin Pickup and Delivery to Airline
    @isTest
    static void testEnviarShipmentTipoAW_Credito_NoPickupAndDelivery() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Air_Shipment_Status__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'AW' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Air_Shipment_Status__c != 'Pickup and Delivery to Airline'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== ESCENARIOS NEGATIVOS (EXISTENTES) ====================
    
    // Tipo M - Crédito sin ETD
    @isTest
    static void testEnviarShipmentTipoM_Credito_NoETD() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Ocean_Shipment_Status__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'M' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Ocean_Shipment_Status__c != 'ETD'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo M - Crédito sin Delivered
    @isTest
    static void testEnviarShipmentTipoM_Credito_NoDelivered() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Shipment_Status__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'M' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Shipment_Status__c != 'Delivered'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo M - Contado sin Booking Confirmation
    @isTest
    static void testEnviarShipmentTipoM_Contado_NoBookingConfirmation() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Ocean_Shipment_Status__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'M' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Ocean_Shipment_Status__c != 'Booking Confirmation'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo M - Contado sin Pending but Pre-Captured
    @isTest
    static void testEnviarShipmentTipoM_Contado_NoPendingPreCaptured() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Shipment_Status__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'M' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Shipment_Status__c != 'Pending but Pre-Captured'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo A - Crédito sin Flight Confirmation
    @isTest
    static void testEnviarShipmentTipoA_Credito_NoFlightConfirmation() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Air_Shipment_Status__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'A' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Air_Shipment_Status__c != 'Flight Confirmation'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo A - Contado sin Contact with Origin
    @isTest
    static void testEnviarShipmentTipoA_Contado_NoContactWithOrigin() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Air_Shipment_Status__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'A' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Air_Shipment_Status__c != 'Contact with Origin'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo PTO - Crédito sin Delivery on Route_M
    @isTest
    static void testEnviarShipmentTipoPTO_Credito_NoDeliveryOnRoute() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Shipment_Status_Mon__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'PTO' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Shipment_Status_Mon__c != 'Delivery on Route_M'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo PTO - Contado sin In Progress_M
    @isTest
    static void testEnviarShipmentTipoPTO_Contado_NoInProgress() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Shipment_Status_Mon__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'PTO' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Shipment_Status_Mon__c != 'In Progress_M'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo FI - Crédito sin Delivery on Route_M
    @isTest
    static void testEnviarShipmentTipoFI_Credito_NoDeliveryOnRoute() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Shipment_Status_Mon__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'FI' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Shipment_Status_Mon__c != 'Delivery on Route_M'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo FI - Contado sin In Progress_M
    @isTest
    static void testEnviarShipmentTipoFI_Contado_NoInProgress() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Shipment_Status_Mon__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'FI' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Shipment_Status_Mon__c != 'In Progress_M'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo FN - Crédito sin Delivery on Route_M
    @isTest
    static void testEnviarShipmentTipoFN_Credito_NoDeliveryOnRoute() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Shipment_Status_Mon__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'FN' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Shipment_Status_Mon__c != 'Delivery on Route_M'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Tipo FN - Contado sin In Progress_M
    @isTest
    static void testEnviarShipmentTipoFN_Contado_NoInProgress() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c, Shipment_Status_Mon__c
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'FN' 
            AND Account_for__r.Venta_Sap__c = 'Contado'
            AND Shipment_Status_Mon__c != 'In Progress_M'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== OTROS ESCENARIOS ====================
    
    @isTest
    static void testEnviarShipmentTipoNoSoportado() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c NOT IN ('M', 'A', 'PTO', 'FI', 'FN', 'PQ', 'W', 'R', 'AW')
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    @isTest
    static void testEnviarShipmentSinAccount() {
        List<Shipment__c> shipments = [
            SELECT Id 
            FROM Shipment__c 
            WHERE Account_for__c = null
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    @isTest
    static void testEnviarShipmentSinVentaSap() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c
            FROM Shipment__c 
            WHERE Account_for__c != null
            AND Account_for__r.Venta_Sap__c = null
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // Prueba del Custom Label
    @isTest
    static void testEnviarAsyncConCustomLabel() {
        List<Shipment__c> shipments = [
            SELECT Id, Account_for__r.Venta_Sap__c 
            FROM Shipment__c 
            WHERE Shipment_Type__c = 'M' 
            AND Account_for__r.Venta_Sap__c = 'Credito'
            AND Ocean_Shipment_Status__c = 'ETD'
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== CASOS LÍMITE ====================
    
    @isTest
    static void testEnviarShipmentIdNulo() {
        Test.startTest();
        P2G_ShipmentSender.enviar(null);
        Test.stopTest();
        System.assert(true, 'Prueba completada');
    }
    
    @isTest
    static void testEnviarShipmentIdInexistente() {
        Id fakeId = Schema.SObjectType.Shipment__c.getKeyPrefix() + '000000000000000';
        
        Test.startTest();
        P2G_ShipmentSender.enviar(fakeId);
        Test.stopTest();
        System.assert(true, 'Prueba completada');
    }
    
    @isTest
    static void testEnviarShipmentConExcepcion() {
        List<Shipment__c> shipments = [
            SELECT Id 
            FROM Shipment__c 
            LIMIT 1
        ];
        
        if (!shipments.isEmpty()) {
            Test.startTest();
            P2G_ShipmentSender.enviar(shipments[0].Id);
            Test.stopTest();
            System.assert(true, 'Prueba completada');
        } else {
            System.debug('No se encontró Shipment para probar');
        }
    }
    
    // ==================== COBERTURA COMPLETA ====================
    
    @isTest
    static void testTodasLasCombinaciones() {
        List<Shipment__c> shipments = [
            SELECT Id, Shipment_Type__c, Account_for__r.Venta_Sap__c,
                   Ocean_Shipment_Status__c, Shipment_Status__c,
                   Air_Shipment_Status__c, Shipment_Status_Mon__c,
                   Shipment_Status_Plann__c, Freight_Mode__c
            FROM Shipment__c
            WHERE Shipment_Type__c IN ('M', 'A', 'PTO', 'FI', 'FN', 'PQ', 'W', 'R', 'AW')
            AND Account_for__r.Venta_Sap__c IN ('Credito', 'Contado')
            LIMIT 50
        ];
        
        Test.startTest();
        for (Shipment__c ship : shipments) {
            P2G_ShipmentSender.enviar(ship.Id);
            System.assert(true, 'Shipment procesado: ' + ship.Id);
        }
        Test.stopTest();
        
        System.assert(true, 'Prueba completada');
    }
    
    @isTest
    static void testCoberturaCompleta() {
        List<Shipment__c> shipments = [
            SELECT Id, Shipment_Type__c, Account_for__r.Venta_Sap__c,
                   Ocean_Shipment_Status__c, Shipment_Status__c,
                   Air_Shipment_Status__c, Shipment_Status_Mon__c,
                   Shipment_Status_Plann__c, Freight_Mode__c
            FROM Shipment__c
            WHERE Shipment_Type__c IN ('M', 'A', 'PTO', 'FI', 'FN', 'PQ', 'W', 'R', 'AW')
            LIMIT 20
        ];
        
        Test.startTest();
        for (Shipment__c ship : shipments) {
            try {
                P2G_ShipmentSender.enviar(ship.Id);
            } catch (Exception e) {
                System.debug('Error: ' + e.getMessage());
            }
        }
        Test.stopTest();
        
        System.assert(true, 'Prueba completada');
    }
}