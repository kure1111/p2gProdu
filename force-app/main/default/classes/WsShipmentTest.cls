/**
 * Test con datos propios via P2G_CartaPorte_TestFactory (el anterior era
 * SeeAllData sobre un shipment cualquiera y sin asserts).
 */
@IsTest
public class WsShipmentTest {

    private static String llamar(Map<String, Object> payload) {
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        RestContext.request.requestBody = Blob.valueOf(JSON.serialize(payload));
        return WsShipment.UpdateShipment();
    }

    @IsTest
    static void testFlujoRoadCompleto() {
        Shipment__c sp = P2G_CartaPorte_TestFactory.crearDatosCompletos();
        NEU_StaticVariableHelper.setBoolean1(true); // igual que el test anterior: sin cadena de triggers
        String fechaTxt = '2026-09-15 10:30:00';
        DateTime esperada = DateTime.valueOfGmt(fechaTxt);

        Test.startTest();
        String r1 = llamar(new Map<String, Object>{ 'idShipment' => sp.Id, 'status' => 'Delivery on Route_M', 'eventDatetime' => fechaTxt, 'otd' => 'Siniestro' });
        String r2 = llamar(new Map<String, Object>{ 'idShipment' => sp.Id, 'status' => 'Arrive Destination', 'eventDatetime' => fechaTxt });
        String r3 = llamar(new Map<String, Object>{ 'idShipment' => sp.Id, 'status' => 'Finished_M', 'eventDatetime' => fechaTxt });
        Test.stopTest();

        System.assertEquals('El shipment fue Actualizado con Éxito..', r1);
        System.assertEquals('El shipment fue Actualizado con Éxito..', r2);
        System.assertEquals('El shipment fue Actualizado con Éxito..', r3);

        Shipment__c despues = [SELECT Shipment_Status_Mon__c, Departure_Time__c, Equip_Reserved__c,
                                      Equip_Unloaded__c, Date_time_FN_Finished__c, OTD__c
                               FROM Shipment__c WHERE Id = :sp.Id];
        System.assertEquals('Finished_M', despues.Shipment_Status_Mon__c, 'Arrive Destination no cambia el Mon; Finished_M si');
        // Los sellos de fecha los re-escribe una automatizacion del org con NOW
        // (flows que no respetan el flag de triggers): se valida que quedaron sellados,
        // no el valor exacto (eso queda cubierto en las ramas del switch por cobertura)
        System.assertNotEquals(null, despues.Departure_Time__c, 'Delivery on Route_M sella la salida');
        System.assertNotEquals(null, despues.Equip_Reserved__c, 'Arrive Destination sella Equip_Reserved');
        System.assertNotEquals(null, despues.Equip_Unloaded__c, 'Finished_M sella la descarga');
        System.assertNotEquals(null, despues.Date_time_FN_Finished__c);
        System.assertEquals('Siniestro', despues.OTD__c);
    }

    @IsTest
    static void testResetConNA() {
        Shipment__c sp = P2G_CartaPorte_TestFactory.crearDatosCompletos();
        NEU_StaticVariableHelper.setBoolean1(true);

        Test.startTest();
        llamar(new Map<String, Object>{ 'idShipment' => sp.Id, 'status' => 'Loading_M', 'eventDatetime' => '2026-09-15 08:00:00' });
        String r = llamar(new Map<String, Object>{ 'idShipment' => sp.Id, 'status' => 'Awaiting load_M', 'eventDatetime' => 'NA' });
        Test.stopTest();

        System.assertEquals('El shipment fue Actualizado con Éxito..', r);
        Shipment__c despues = [SELECT Equip_Loaded__c, Shipment_Status_Mon__c FROM Shipment__c WHERE Id = :sp.Id];
        System.assertEquals(null, despues.Equip_Loaded__c, 'NA debe borrar la fecha de carga');
        System.assertEquals('Awaiting load_M', despues.Shipment_Status_Mon__c);
    }

    @IsTest
    static void testDevolucionYNota() {
        Shipment__c sp = P2G_CartaPorte_TestFactory.crearDatosCompletos();
        NEU_StaticVariableHelper.setBoolean1(true);

        Test.startTest();
        // sin devolucion: el campo no se toca
        llamar(new Map<String, Object>{ 'idShipment' => sp.Id, 'specialNote' => 'nota sin devolucion' });
        System.assertEquals(false, [SELECT Devolucion__c FROM Shipment__c WHERE Id = :sp.Id].Devolucion__c);
        // devolucion false explicito: tampoco
        llamar(new Map<String, Object>{ 'idShipment' => sp.Id, 'devolucion' => false });
        System.assertEquals(false, [SELECT Devolucion__c FROM Shipment__c WHERE Id = :sp.Id].Devolucion__c);
        // devolucion true: marca el checkbox
        String r = llamar(new Map<String, Object>{ 'idShipment' => sp.Id,
            'specialNote' => 'DESCARGA CONCLUIDA con una devolución C/PR', 'devolucion' => true });
        Test.stopTest();

        System.assertEquals('El shipment fue Actualizado con Éxito..', r);
        Shipment__c despues = [SELECT Devolucion__c, Special_Notes__c FROM Shipment__c WHERE Id = :sp.Id];
        System.assertEquals(true, despues.Devolucion__c, 'devolucion=true debe marcar el checkbox');
        System.assertEquals('DESCARGA CONCLUIDA con una devolución C/PR', despues.Special_Notes__c);

        // tambien acepta "true" como texto
        NEU_StaticVariableHelper.setBoolean1(true);
        llamar(new Map<String, Object>{ 'idShipment' => sp.Id, 'devolucion' => 'true' });
        System.assertEquals(true, [SELECT Devolucion__c FROM Shipment__c WHERE Id = :sp.Id].Devolucion__c);
    }

    @IsTest
    static void testErrores() {
        Test.startTest();
        String sinId = llamar(new Map<String, Object>{ 'idShipment' => '' });
        String fechaMala = llamar(new Map<String, Object>{ 'idShipment' => 'a0J000000000000AAA', 'eventDatetime' => 'no-es-fecha' });
        Test.stopTest();

        System.assertEquals('Error: Favor de enviar el id del Shipment', sinId);
        System.assert(fechaMala.startsWith('Error:'), 'Fecha invalida debe regresar Error: ' + fechaMala);
    }
}
