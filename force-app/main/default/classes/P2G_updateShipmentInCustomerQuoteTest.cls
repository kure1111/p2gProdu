/**
 * Test con datos propios (el anterior usaba SeeAllData con un folio real
 * hardcodeado que hoy esta en Quote Declined y la VR FD-002 rechaza el update).
 * Prueba la clase directo (ramas con-cambios y sin-cambios) y cubre el trigger
 * con un update real del folio. OJO: no se asserta la propagacion via trigger
 * porque la cadena de folio trae ramas !Test.isRunningTest() que la cortan
 * (comportamiento previo, verificado con sonda contra el codigo viejo).
 */
@isTest
private class P2G_updateShipmentInCustomerQuoteTest {

    @isTest
    public static void updateShipmentInCustomerQuoteTest(){
        Shipment__c sp = P2G_CartaPorte_TestFactory.crearDatosCompletos();
        Shipment__c spActual = [SELECT Id, Route__c, Account_for__c, Border__c, Customs__c,
                                       ETD_from_Point_of_Load__c, ETA_Point_of_Discharge__c,
                                       ETD_Time_from_Point_of_Load__c, ETA_Time_Point_of_Discharge__c,
                                       Country_of_Load__c, State_of_Load__c, Site_of_Load__c,
                                       Country_of_Discharge__c, State_of_Discharge__c, Site_of_Discharge__c,
                                       Account_Origin_Address__c, Account_Destination_Address__c
                                FROM Shipment__c WHERE Id = :sp.Id];
        Customer_Quote__c quote = [SELECT Id, ETA__c, Last_Shipment__c FROM Customer_Quote__c
                                   WHERE Last_Shipment__c = :sp.Id LIMIT 1];

        // folio en memoria alineado al shipment (sin DML: los lookup filters del folio no aplican)
        Customer_Quote__c qMem = new Customer_Quote__c(
            Id = quote.Id,
            Last_Shipment__c = sp.Id,
            Route__c = spActual.Route__c,
            Account_for__c = spActual.Account_for__c,
            Border__c = spActual.Border__c,
            Customs__c = spActual.Customs__c,
            ETD__c = spActual.ETD_from_Point_of_Load__c,
            ETA__c = spActual.ETA_Point_of_Discharge__c,
            Awaiting_load_time__c = spActual.ETD_Time_from_Point_of_Load__c,
            Awaiting_unload_time__c = spActual.ETA_Time_Point_of_Discharge__c,
            Country_ofLoad__c = spActual.Country_of_Load__c,
            State_of_Load__c = spActual.State_of_Load__c,
            Site_of_Load__c = spActual.Site_of_Load__c,
            Country_ofDischarge__c = spActual.Country_of_Discharge__c,
            State_of_Discharge__c = spActual.State_of_Discharge__c,
            Site_of_Discharge__c = spActual.Site_of_Discharge__c,
            Account_Origin_Address__c = spActual.Account_Origin_Address__c,
            Account_Destination_Address__c = spActual.Account_Destination_Address__c
        );

        Test.startTest();

        // rama sinCambios: valores identicos -> NO debe actualizar el Shipment
        Integer dmlAntes = Limits.getDmlStatements();
        P2G_updateShipmentInCustomerQuote.updateShipments(new List<Customer_Quote__c>{ qMem });
        System.assertEquals(dmlAntes, Limits.getDmlStatements(),
            'Sin cambios no debe haber update del Shipment');

        // rama con cambios: ETA distinto -> SI actualiza el Shipment
        qMem.ETA__c = Date.newInstance(2300, 2, 18);
        P2G_updateShipmentInCustomerQuote.updateShipment(qMem);
        System.assertEquals(Date.newInstance(2300, 2, 18),
            [SELECT ETA_Point_of_Discharge__c FROM Shipment__c WHERE Id = :sp.Id].ETA_Point_of_Discharge__c,
            'El ETA del folio debe copiarse al Shipment');

        // folio sin shipment relacionado: retorno temprano
        P2G_updateShipmentInCustomerQuote.updateShipments(new List<Customer_Quote__c>{ new Customer_Quote__c() });

        // cobertura del trigger P2G_updateShipment con un update real del folio
        quote.ETA__c = Date.newInstance(2300, 2, 19);
        update quote;

        Test.stopTest();
    }

    @isTest
    public static void triggerCustomerQuoteTest(){
        Shipment__c sp = P2G_CartaPorte_TestFactory.crearDatosCompletos();
        Shipment__c spActual = [SELECT Id, Account_Origin_Address__c, Account_Destination_Address__c,
                                       Order_Margen_Operativo__c
                                FROM Shipment__c WHERE Id = :sp.Id];
        Customer_Quote__c quote = [SELECT Id, Last_Shipment__c, Quotation_status__c, Margen_Operativo__c
                                   FROM Customer_Quote__c WHERE Last_Shipment__c = :sp.Id LIMIT 1];
        quote.Quotation_status__c = 'Shipped'; // solo en memoria, para entrar al filtro del metodo

        Test.startTest();
        // dos pasadas: la primera copia el margen si difiere; la segunda ya es igual y omite el update
        TriggerCustomerQuote.ActualizarShipment(new List<Customer_Quote__c>{ quote });
        TriggerCustomerQuote.ActualizarShipment(new List<Customer_Quote__c>{ quote });
        TriggerCustomerQuote.ActualizarShipment(new List<Customer_Quote__c>{ new Customer_Quote__c() });

        List<Customer_Quote__c> conDirecciones = new List<Customer_Quote__c>{
            new Customer_Quote__c(Account_Origin_Address__c = spActual.Account_Origin_Address__c,
                                  Account_Destination_Address__c = spActual.Account_Destination_Address__c),
            new Customer_Quote__c()
        };
        TriggerCustomerQuote.ActualizarLocations(conDirecciones);
        TriggerCustomerQuote.ActualizaDistancia(conDirecciones);
        Test.stopTest();

        System.assertEquals(quote.Margen_Operativo__c,
            [SELECT Order_Margen_Operativo__c FROM Shipment__c WHERE Id = :sp.Id].Order_Margen_Operativo__c,
            'ActualizarShipment deja el margen del folio en el Shipment');
        System.assertNotEquals(null, conDirecciones[0].Origin_Address__c,
            'ActualizarLocations llena la direccion de origen');
    }
}
