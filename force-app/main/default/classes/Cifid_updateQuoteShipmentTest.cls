@IsTest
public class Cifid_updateQuoteShipmentTest {
    
    // Mock corregido para pruebas de WebService
    private class MockCifidUpdateQuoteShipmentCallout implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseName,
            String responseNamespace,
            String client
        ) {
            // Crear la respuesta correcta con updateQuoteResponse_element
            Cifid_updateQuoteShipment.updateQuoteResponse_element responseElement = new Cifid_updateQuoteShipment.updateQuoteResponse_element();
            
            // Crear el estatus dentro de la respuesta
            Cifid_updateQuoteShipment.estatus res = new Cifid_updateQuoteShipment.estatus();
            res.code = '200';
            res.message = 'Éxito';
            
            // Asignar el estatus a la respuesta
            responseElement.result = res;
            
            // Poner el updateQuoteResponse_element en el Map, no el estatus directamente
            response.put('response_x', responseElement);
        }
    }
    
    @IsTest
    static void testShipmentStructureAndMockCallout() {
        // SessionHeader_element instance
        Cifid_updateQuoteShipment.SessionHeader_element sessionHeader = new Cifid_updateQuoteShipment.SessionHeader_element();
        sessionHeader.sessionId = '00Dxx0000001gP4!AQ4AQEQ...'; // Session ID dummy
        
        // CallOptions_element instance
        Cifid_updateQuoteShipment.CallOptions_element callOptions = new Cifid_updateQuoteShipment.CallOptions_element();
        callOptions.client = 'TestClient';
        
        // address instance
        Cifid_updateQuoteShipment.address addr = new Cifid_updateQuoteShipment.address();
        addr.city = 'Monterrey';
        addr.country = 'Mexico';
        addr.countryCode = 'MX';
        addr.geocodeAccuracy = 'High';
        addr.postalCode = '64000';
        addr.state = 'Nuevo León';
        addr.stateCode = 'NL';
        addr.street = 'Calle Falsa 123';
        
        // estatus instance
        Cifid_updateQuoteShipment.estatus est = new Cifid_updateQuoteShipment.estatus();
        est.code = '200';
        est.message = 'Operación exitosa';
        
        // DebuggingInfo_element instance
        Cifid_updateQuoteShipment.DebuggingInfo_element debugInfo = new Cifid_updateQuoteShipment.DebuggingInfo_element();
        debugInfo.debugLog = 'Log generado para pruebas.';
        
        // LogInfo instance
        Cifid_updateQuoteShipment.LogInfo log = new Cifid_updateQuoteShipment.LogInfo();
        log.category = 'TestCategory';
        log.level = 'INFO';
        
        // Registra el mock corregido
        Test.setMock(WebServiceMock.class, new MockCifidUpdateQuoteShipmentCallout());
        
        // Prepara un envío ficticio
        Cifid_updateQuoteShipment.Shipment shipment = new Cifid_updateQuoteShipment.Shipment();
        shipment.airBookingNumber = 'AB123';
        shipment.airStatus = 'In Transit';
        shipment.ata = '2025-04-29T12:00:00.000Z';
        shipment.atd = '2025-04-28T08:00:00.000Z';
        shipment.bookingconfirmation = 'CONF123';
        shipment.carrier = 'CarrierX';
        shipment.deliveryAddress = '123 Street, City';
        shipment.externalNumber = 'EXT123';
        shipment.externalQuoteNumber = 'Q456';
        shipment.flightNumber = 'FL1234';
        shipment.freeDays = '5';
        shipment.hblNumber = 'HBL987';
        shipment.lastUpdate = System.now();
        shipment.mawbNumber = 'MAWB123';
        shipment.oceanExpoStatus = 'On Water';
        shipment.oceanImpoStatus = 'Pending';
        shipment.opExecutive = 'John Doe';
        shipment.pickupAddress = 'Pickup St';
        shipment.seaBookingNumber = 'SEA123';
        shipment.seaContainerNumber = 'CONT456';
        shipment.spCurrency = 'USD';
        shipment.statusMonitoreo = 'Active';
        shipment.statusPlanner = 'Planned';
        shipment.totalServBuyAmmount = '5000';
        shipment.vessel = 'Vessel X';
        shipment.vesselLat = 25.123;
        shipment.vesselLon = -100.456;
        
        // Prepara la solicitud de actualización
        Cifid_updateQuoteShipment.updateQuote_element req = new Cifid_updateQuoteShipment.updateQuote_element();
        req.ship = shipment;
        
        // Instanciar clases adicionales para cobertura
        Cifid_updateQuoteShipment.updateQuoteResponse_element responseElement = new Cifid_updateQuoteShipment.updateQuoteResponse_element();
        responseElement.result = est;
        
        Cifid_updateQuoteShipment.DebuggingHeader_element debugHeader = new Cifid_updateQuoteShipment.DebuggingHeader_element();
        debugHeader.debugLevel = 'DEBUG';
        debugHeader.categories = new List<Cifid_updateQuoteShipment.LogInfo>{log};
        
        Cifid_updateQuoteShipment.location loc = new Cifid_updateQuoteShipment.location();
        loc.latitude = 25.123;
        loc.longitude = -100.456;
        
        Cifid_updateQuoteShipment.AllowFieldTruncationHeader_element allowTruncation = new Cifid_updateQuoteShipment.AllowFieldTruncationHeader_element();
        allowTruncation.allowFieldTruncation = true;
        
        // Instanciar y configurar la clase principal del servicio
        Cifid_updateQuoteShipment.Cifid_ShipmentFromPak service = new Cifid_updateQuoteShipment.Cifid_ShipmentFromPak();
        service.endpoint_x = 'https://test.salesforce.com/services/Soap/class/Cifid_ShipmentFromPak';
        service.inputHttpHeaders_x = new Map<String, String>{'Content-Type' => 'text/xml'};
        service.outputHttpHeaders_x = new Map<String, String>();
        service.clientCertName_x = 'TestCert';
        service.timeout_x = 60000;
        
        service.DebuggingInfo = debugInfo;
        service.SessionHeader = sessionHeader;
        service.CallOptions = callOptions;
        service.DebuggingHeader = debugHeader;
        service.AllowFieldTruncationHeader = allowTruncation;
        
        // Ejecutar el método updateQuote para cobertura - ahora debería funcionar
        Cifid_updateQuoteShipment.estatus result = service.updateQuote(shipment);
    }
    
    private class Cifid_ShipmentFromPakMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml');
            res.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://soap.sforce.com/schemas/class/Cifid_ShipmentFromPak"><soapenv:Body><ns:updateQuoteResponse><ns:result><ns:status>Success</ns:status></ns:result></ns:updateQuoteResponse></soapenv:Body></soapenv:Envelope>');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testUpdateQuoteCallout() {
        Test.setMock(HttpCalloutMock.class, new Cifid_ShipmentFromPakMock());

        Cifid_updateQuoteShipment.Shipment ship = new Cifid_updateQuoteShipment.Shipment();
        ship.airBookingNumber = 'AB123';
        ship.airStatus = 'In Transit';
        Cifid_updateQuoteShipment.byPass();

        // Probar más campos del Shipment
        ship.ata = '2025-04-29T12:00:00.000Z';
        ship.atd = '2025-04-28T08:00:00.000Z';
        ship.bookingconfirmation = 'CONF123';
        ship.carrier = 'CarrierX';
        ship.deliveryAddress = '123 Street, City';
        ship.externalNumber = 'EXT123';
        ship.externalQuoteNumber = 'Q456';
        ship.flightNumber = 'FL1234';
        ship.freeDays = '5';
        ship.hblNumber = 'HBL987';
        ship.lastUpdate = System.now();
        ship.mawbNumber = 'MAWB123';
        ship.oceanExpoStatus = 'On Water';
        ship.oceanImpoStatus = 'Pending';
        ship.opExecutive = 'John Doe';
        ship.pickupAddress = 'Pickup St';
        ship.seaBookingNumber = 'SEA123';
        ship.seaContainerNumber = 'CONT456';
        ship.spCurrency = 'USD';
        ship.statusMonitoreo = 'Active';
        ship.statusPlanner = 'Planned';
        ship.totalServBuyAmmount = '5000';
        ship.vessel = 'Vessel X';
        ship.vesselLat = 25.123;
        ship.vesselLon = -100.456;
    }

    @isTest
    static void testAdditionalCoverage() {
        // Probar el método byPass para cobertura completa
        Cifid_updateQuoteShipment.byPass();
        
        // Instanciar todas las clases restantes para cobertura
        Cifid_updateQuoteShipment.updateQuoteResponse_element responseElem = new Cifid_updateQuoteShipment.updateQuoteResponse_element();
        Cifid_updateQuoteShipment.DebuggingHeader_element debugHead = new Cifid_updateQuoteShipment.DebuggingHeader_element();
        Cifid_updateQuoteShipment.location locationObj = new Cifid_updateQuoteShipment.location();
        Cifid_updateQuoteShipment.AllowFieldTruncationHeader_element allowTrunc = new Cifid_updateQuoteShipment.AllowFieldTruncationHeader_element();
        
        // Configurar propiedades adicionales
        debugHead.categories = new List<Cifid_updateQuoteShipment.LogInfo>();
        debugHead.debugLevel = 'INFO';
        
        locationObj.latitude = 10.5;
        locationObj.longitude = -66.9;
        
        allowTrunc.allowFieldTruncation = true;
    }
}