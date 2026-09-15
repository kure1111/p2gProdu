/**
 * Cubre los triggers optimizados del insert de Shipment:
 * NEU_Update_Relations_Accounts (update solo si hay algo que copiar),
 * NEU_ShipmentContainerType_to_Size (1 query bulkificada),
 * NEU_Shipment_Update_Route (1 query para todos los combos en el insert)
 * y PAK_FieldsShipment (warehouse filtrada, consolidacion solo si cambio status,
 * P2G_Advertencia solo en transiciones).
 * Aqui NO se activa NEU_StaticVariableHelper: los triggers corren de verdad.
 */
@IsTest
public class P2G_ShipmentInsertTriggersTest {

    @IsTest
    static void testInsertSinNadaQueCopiar() {
        // La cuenta de la factory no trae consignee/shipper: el trigger de
        // relaciones no debe tocar nada (y por lo tanto no re-actualizar el SP).
        Shipment__c sp = P2G_CartaPorte_TestFactory.crearDatosCompletos();

        Shipment__c despues = [SELECT Consignee__c, Consignee_Contact__c, Notify_Party__c,
                                      Shipper__c, Shipper_Contact__c, Route__c
                               FROM Shipment__c WHERE Id = :sp.Id];
        System.assertEquals(null, despues.Consignee__c, 'Sin datos en la cuenta no hay nada que copiar');
        System.assertEquals(null, despues.Shipper__c, 'Sin proveedor no hay shipper que copiar');
        // La ruta exacta ya existia (la crea la factory): el match del insert debe asignarla
        Carrier_Line_Load_Point__c ruta = [SELECT Id FROM Carrier_Line_Load_Point__c LIMIT 1];
        System.assertEquals(ruta.Id, despues.Route__c, 'La ruta existente debe asignarse en el insert');
    }

    @IsTest
    static void testInsertCopiaRelacionesYContainer() {
        // Sin factory: el RecursiveCheck de ContainerType debe llegar limpio al insert.
        // Lookup filters de Produ: Consignee__c exige cuenta RT Consignee;
        // Shipper__c exige RT Supplier/Customer; los contactos deben colgar de
        // la cuenta correspondiente (en Shipment, el contacto shipper cuelga del
        // Supplier_Account, por eso el proveedor es su propio shipper).
        Id rtConsignee = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Consignee').getRecordTypeId();
        Id rtSupplier = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Supplier').getRecordTypeId();

        Account cuenta = new Account(Name = 'Cuenta Opt Test', Customer_Id__c = '58SQL9001',
                                     Venta_Sap__c = 'Credito', Credit_Limit__c = 6000000.00, Segment__c = 'Nuevo');
        insert cuenta;
        Account destinatario = new Account(Name = 'Consignee Opt Test', Segment__c = 'Nuevo', RecordTypeId = rtConsignee);
        insert destinatario;
        Account shipperAcc = new Account(Name = 'Shipper Opt Test', Segment__c = 'Nuevo', RecordTypeId = rtSupplier);
        insert shipperAcc;
        Account proveedor = new Account(Name = 'Proveedor Opt Test', Segment__c = 'Nuevo', RecordTypeId = rtSupplier);
        insert proveedor;

        Contact contactoConsignee = new Contact(LastName = 'Contacto Consignee Opt', AccountId = destinatario.Id);
        insert contactoConsignee;

        cuenta.Consignee__c = destinatario.Id;
        cuenta.Consignee_Contact__c = contactoConsignee.Id;
        cuenta.Notify_Party__c = destinatario.Id;
        update cuenta;

        // Shipper_Contact__c se queda vacio a proposito: sus lookup filters de
        // Shipment (contacto del Supplier_Account) y de Account (contacto del
        // Shipper) son incompatibles entre si salvo casos degenerados.
        proveedor.Shipper__c = shipperAcc.Id;
        update proveedor;

        Container_Type__c ct = new Container_Type__c(Name = 'CT Opt Test');
        insert ct;

        Country__c country = new Country__c(Name = 'Mexico Opt', ISO_Code_2c__c = 'MO', ISO_Code__c = 'MOP');
        insert country;
        State__c state = new State__c(Name = 'Sonora Opt', ISO_Code_2c__c = 'SP', country__c = country.Id);
        insert state;
        Location__c location = new Location__c(Name = 'Hermosillo Opt', state__c = state.Id, country__c = country.Id);
        insert location;

        Test.startTest();
        Shipment__c sp = new Shipment__c();
        sp.Name = 'SP-FI-21-280777';
        sp.Freight_Mode__c = 'Road';
        sp.Account_for__c = cuenta.Id;
        sp.Supplier_Account__c = proveedor.Id;
        sp.Service_Mode__c = 'NATIONAL';
        sp.Service_Type__c = 'LTL';
        sp.Move_Type__c = 'Door to Door';
        sp.Shipment_Status_Plann__c = 'Pending';
        sp.Container_Size__c = 'CT Opt Test';
        // combo de ruta que no existe: cubre la rama de crear ruta nueva
        sp.Country_of_Load__c = country.Id;
        sp.State_of_Load__c = state.Id;
        sp.Site_of_Load__c = location.Id;
        sp.Country_of_Discharge__c = country.Id;
        sp.State_of_Discharge__c = state.Id;
        sp.Site_of_Discharge__c = location.Id;
        insert sp;
        Test.stopTest();

        Shipment__c despues = [SELECT Consignee__c, Consignee_Contact__c, Notify_Party__c,
                                      Shipper__c, Shipper_Contact__c, Container_Type__c
                               FROM Shipment__c WHERE Id = :sp.Id];
        System.assertEquals(destinatario.Id, despues.Consignee__c, 'Debe copiar el consignee de la cuenta');
        System.assertEquals(contactoConsignee.Id, despues.Consignee_Contact__c, 'Debe copiar el contacto consignee');
        System.assertEquals(destinatario.Id, despues.Notify_Party__c, 'Debe copiar el notify party');
        System.assertEquals(shipperAcc.Id, despues.Shipper__c, 'Debe copiar el shipper del proveedor');
        System.assertEquals(null, despues.Shipper_Contact__c, 'Sin contacto shipper en el proveedor no hay nada que copiar');
        System.assertEquals(ct.Id, despues.Container_Type__c, 'Debe resolver el container type por size');
    }

    @IsTest
    static void testUpdateSinCambioDeStatus() {
        Shipment__c sp = P2G_CartaPorte_TestFactory.crearDatosCompletos();

        Test.startTest();
        sp.Special_Notes__c = 'nota de prueba';
        update sp;
        Test.stopTest();

        Shipment__c despues = [SELECT Special_Notes__c, Route__c FROM Shipment__c WHERE Id = :sp.Id];
        System.assertEquals('nota de prueba', despues.Special_Notes__c);
        System.assertNotEquals(null, despues.Route__c, 'La ruta no debe perderse en un update sin cambio de sitios');
    }

    @IsTest
    static void testUpdateConTransicionYStatus() {
        Shipment__c sp = P2G_CartaPorte_TestFactory.crearDatosCompletos();

        Test.startTest();
        // Pending -> In Progress: unica transicion que dispara P2G_Advertencia
        sp.Shipment_Status_Plann__c = 'In Progress';
        sp.Shipment_Status_Mon__c = 'Loading_M';
        update sp;
        Test.stopTest();

        Shipment__c despues = [SELECT Shipment_Status_Plann__c, Shipment_Status_Mon__c
                               FROM Shipment__c WHERE Id = :sp.Id];
        System.assertEquals('Loading_M', despues.Shipment_Status_Mon__c);
        // sin fee lines ni tarifario, P2G_Advertencia NO debe revertir a Pending
        System.assertNotEquals('Pending', despues.Shipment_Status_Plann__c, 'Advertencia no debe revertir sin lineas');
        List<Status_Datetime__c> sellos = [SELECT Id FROM Status_Datetime__c WHERE Shipment__c = :sp.Id];
        System.assert(!sellos.isEmpty(), 'El cambio de status debe generar Status_Datetime');
    }
}
