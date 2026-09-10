/**
 * Datos de prueba para las clases de Carta Porte (CPV2, NEU_CartaPortePDF,
 * P2G_Validacion_Datos_CartaPorte). Receta basada en CPV2_Test, hecha
 * portable entre UAT y Produccion:
 *  - Record types de Catalogo_SAT__c por DeveloperName (las etiquetas
 *    difieren entre orgs: "Configuracion Autotrasporte" vs "...Autotransporte").
 *  - El checkbox activo de Account_Address__c se llama IsActive__c en UAT
 *    y Active__c en Produccion: se resuelve dinamicamente.
 * No usa SeeAllData ni IDs fijos.
 */
@isTest
public class P2G_CartaPorte_TestFactory {

    public static final String SHIPMENT_NAME = 'SP-FI-21-280888';
    public static final String DATOS_ORIGEN = 'RFC DESTINATARIO:EXIST123,DESTINATARIO:Existente';
    public static final String DATOS_DESTINO = 'RFC Destino:EXIST456,Razon Social:DestinoExistente';

    private static Id catalogoRT(String developerName) {
        return Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByDeveloperName()
            .get(developerName).getRecordTypeId();
    }

    private static void marcarDireccionActiva(Account_Address__c address) {
        Map<String, Schema.SObjectField> campos = Schema.SObjectType.Account_Address__c.fields.getMap();
        String campoActivo = campos.containsKey('isactive__c') ? 'IsActive__c' : 'Active__c';
        address.put(campoActivo, true);
    }

    public static Shipment__c crearDatosCompletos() {
        return crearDatosCompletos(SHIPMENT_NAME, false);
    }

    /**
     * IMPORTANTE: en Produccion la cascada de triggers del Shipment consume
     * casi todo el limite de SOQL de la transaccion. Por eso el shipment nace
     * con isInverted__c y los Datos_Carta_Porte ya puestos EN EL INSERT:
     * los tests no deben hacer update del Shipment fuera de Test.startTest().
     */
    public static Shipment__c crearDatosCompletos(String nombreShipment, Boolean invertido) {
        User userT = [SELECT Id, ManagerId, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Rol_Margen__c rolMargen = TestDataFactory.createRolMargen(userT.UserRole.Name);

        Account accountT = new Account();
        accountT.Name = 'account test';
        accountT.Customer_Id__c = '58SQL1256';
        accountT.TAX_ID__c = 'AAA010101AAA'; // CPV2.getDataCP exige RFC cuando hay Client_of_Client
        accountT.OwnerId = userT.Id;
        accountT.Venta_Sap__c = 'Credito';
        accountT.Credit_Limit__c = 6000000.00;
        accountT.Segment__c = 'Nuevo';
        insert accountT;

        Rol_Margen__c rl = TestDataFactory.createRolMargen('Director Comercial');

        Catalogo_SAT__c catalogo = new Catalogo_SAT__c();
        catalogo.Name = 'Caja de acero test';
        catalogo.Clave_SAT__c = 'Caja de acero test';
        catalogo.RecordTypeId = catalogoRT('Unidad_Peso');
        insert catalogo;

        Catalogo_SAT__c direccion = new Catalogo_SAT__c();
        direccion.Name = '281998';
        direccion.Clave_SAT__c = '281998';
        direccion.RecordTypeId = catalogoRT('Codigo_Postal');
        insert direccion;

        Customer_Quote__c folio = new Customer_Quote__c();
        folio.Account_for__c = accountT.Id;
        folio.Client_of_Client__c = accountT.Id;
        folio.Freight_Mode__c = 'Air';
        folio.Service_Mode__c = 'Import';
        folio.Service_Type__c = 'LCL Cargo';
        folio.Move_Type__c = 'Door to Door';
        folio.Origin_Address__c = 'Address Test';
        folio.Destination_Address__c = 'Address Test';
        folio.ByPass__c = true;
        folio.Impak_Request__c = true;
        folio.Date_Pricing_responded__c = System.today();
        folio.Clave_de_Unidad_de_Peso__c = catalogo.Id;
        folio.Pricing_Executive__c = UserInfo.getUserId();
        insert folio;

        Account_Address__c address = new Account_Address__c();
        address.Name = 'Bonafont Cln';
        address.Account__c = accountT.Id;
        address.Address__c = 'Conocida';
        address.Address_Coordinates__Latitude__s = 22.023033;
        address.Address_Coordinates__Longitude__s = -102.285602;
        address.Codigo_Postal_CP__c = direccion.Id;
        address.referencia__c = 'Referencias test';
        address.Type__c = 'Shipping Address';
        address.status__c = 'Validado';
        marcarDireccionActiva(address);
        insert address;

        Account_Address__c address2 = new Account_Address__c();
        address2.Name = 'Cln';
        address2.Account__c = accountT.Id;
        address2.Address__c = 'Conocida';
        address2.Address_Coordinates__Latitude__s = 19.6248115;
        address2.Address_Coordinates__Longitude__s = -99.18076289999999;
        address2.Codigo_Postal_CP__c = direccion.Id;
        address2.referencia__c = 'Referencias test';
        address2.Type__c = 'Shipping Address';
        address2.status__c = 'Validado';
        marcarDireccionActiva(address2);
        insert address2;

        Catalogo_SAT__c trans = new Catalogo_SAT__c();
        trans.Name = 'Camión-Test';
        trans.Clave_SAT__c = 'T3S7';
        trans.RecordTypeId = catalogoRT('Configuracion_Autotrasporte');
        insert trans;

        Catalogo_SAT__c permiso = new Catalogo_SAT__c();
        permiso.Name = 'Permiso-Test';
        permiso.Clave_SAT__c = 'Pernis23';
        permiso.RecordTypeId = catalogoRT('Tipo_de_Permiso');
        insert permiso;

        Catalogo_SAT__c remolqueT = new Catalogo_SAT__c();
        remolqueT.Name = 'Caja-Test';
        remolqueT.Clave_SAT__c = 'Caja2123';
        remolqueT.RecordTypeId = catalogoRT('Tipo_de_Remolque');
        insert remolqueT;

        Container_Type__c unidad = new Container_Type__c();
        unidad.Name = 'Cajatest';
        unidad.Type__c = 'Road';
        unidad.Height_cm__c = 250;
        unidad.Length_cm__c = 1590;
        unidad.Width_cm__c = 250;
        unidad.Cargo_Weight_Kg__c = 25000;
        unidad.Cargo_Volume_m3__c = 108.500;
        insert unidad;

        Caja_Remolque__c remolque1 = new Caja_Remolque__c();
        remolque1.Name = 'cajatest';
        remolque1.Tipo_Remolque__c = remolqueT.Id;
        remolque1.Color_Caja__c = 'Blanco';
        remolque1.Num_Placa_Caja__c = 'Tes1t115';
        insert remolque1;

        Caja_Remolque__c remolque2 = new Caja_Remolque__c();
        remolque2.Name = 'caja2test';
        remolque2.Tipo_Remolque__c = remolqueT.Id;
        remolque2.Color_Caja__c = 'Blanco';
        remolque2.Num_Placa_Caja__c = 'Tes2t215';
        insert remolque2;

        Account carrier = new Account();
        carrier.Name = 'Carrier Test';
        carrier.Brand_Name__c = 'Carrier Test';
        carrier.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
        carrier.Direccion_Principal__c = address.Id;
        carrier.Segment__c = 'Nuevo';
        insert carrier;

        Catalogo_SAT__c cp = new Catalogo_SAT__c();
        cp.Name = '980828';
        cp.Clave_SAT__c = '980828';
        cp.RecordTypeId = catalogoRT('Codigo_Postal');
        insert cp;

        Operadores__c operador1 = new Operadores__c();
        operador1.Account__c = carrier.Id;
        operador1.Name = 'Operador test';
        operador1.Cel_ope__c = '123456789';
        operador1.Telfij_ope__c = '123123123';
        operador1.Medprev_ope__c = '123123';
        operador1.Proovedor_validado__c = true;
        operador1.Validado__c = true;
        operador1.Operador_Validado__c = true;
        operador1.Codigo_Postal_Operador__c = cp.Id;
        operador1.RFC_Operador__c = 'TestRFC';
        operador1.Numlicvig_ope__c = '123135';
        insert operador1;

        Operadores__c operador2 = new Operadores__c();
        operador2.Account__c = carrier.Id;
        operador2.Name = 'Operador test';
        operador2.Cel_ope__c = '123456789';
        operador2.Telfij_ope__c = '123123123';
        operador2.Medprev_ope__c = '123123';
        operador2.Proovedor_validado__c = true;
        operador2.Validado__c = true;
        operador2.Operador_Validado__c = true;
        operador2.RFC_Operador__c = 'TestRFC';
        operador2.Numlicvig_ope__c = '123135';
        operador2.Codigo_Postal_Operador__c = cp.Id;
        insert operador2;

        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'test';
        vehicle.Last_Location__Longitude__s = 41.40338;
        vehicle.Last_Location__Latitude__s = 2.17403;
        vehicle.Account_for_SCP__c = carrier.Id;
        vehicle.Vehiculo_Validado__c = true;
        vehicle.Num_Placa_Tracto__c = 'Test123';
        vehicle.Nombre_Aseguradora__c = 'Test aseguradora';
        vehicle.Numero_Poliza_Seguro__c = '123123';
        vehicle.Asegura_Responsabilidad_Civil__c = 'Test aseguradora';
        vehicle.Poliza_Responsabilidad_civil__c = 'Test poliza';
        vehicle.Prima_Seguro__c = '0004258666';
        vehicle.Numero_de_Permiso_SCT__c = 'Test numero';
        vehicle.Tipo_de_Permiso__c = permiso.Id;
        vehicle.Configuracion_Vehicularcat__c = trans.Id;
        vehicle.Caja_Remolque__c = remolque1.Id;
        vehicle.Caja_Remolque_2__c = remolque2.Id;
        insert vehicle;

        Country__c country = new Country__c(Name = 'Mexico', ISO_Code_2c__c = 'MX', ISO_Code__c = 'MEX');
        insert country;

        State__c state = new State__c(Name = 'Sonora', ISO_Code_2c__c = 'SO', country__c = country.Id);
        insert state;

        Location__c location = new Location__c(Name = 'Hermosillo', state__c = state.Id, country__c = country.Id);
        insert location;

        Carrier_Line_Load_Point__c route = new Carrier_Line_Load_Point__c(
            Country_of_Load__c = country.Id,
            Country_of_Discharge__c = country.Id,
            Port_Airport_of_Load__c = location.Id,
            Port_Airport_of_Discharge__c = location.Id,
            State_of_Load__c = state.Id,
            State_of_Discharge__c = state.Id
        );
        insert route;

        Shipment__c newShipment = new Shipment__c();
        newShipment.Name = nombreShipment;
        newShipment.isInverted__c = invertido;
        newShipment.Datos_Carta_Porte__c = DATOS_ORIGEN;
        newShipment.Datos_Carta_Porte_Destino__c = DATOS_DESTINO;
        newShipment.Freight_Mode__c = 'Road';
        newShipment.Account_for__c = accountT.Id;
        newShipment.Service_Mode__c = 'NATIONAL';
        newShipment.Service_Type__c = 'LTL';
        newShipment.Move_Type__c = 'Door to Door';
        newShipment.Only_Warehouse_Service__c = false;
        newShipment.Operation_Executive__c = userT.Id;
        newShipment.Destination_Address__c = address.Id;
        newShipment.Origin_Address__c = address2.Id;
        newShipment.Account_Origin_Address__c = address.Id;
        newShipment.Account_Destination_Address__c = address2.Id;
        newShipment.Shipment_Status_Plann__c = 'Pending';
        newShipment.Carrier__c = carrier.Id;
        newShipment.National_Operator__c = operador1.Id;
        newShipment.Operator_2__c = operador2.Id;
        newShipment.Vehicle__c = vehicle.Id;
        newShipment.Traslado_Ingreso__c = 'Traslado';
        newShipment.Country_of_Load__c = country.Id;
        newShipment.State_of_Load__c = state.Id;
        newShipment.Site_of_Load__c = location.Id;
        newShipment.Country_of_Discharge__c = country.Id;
        newShipment.State_of_Discharge__c = state.Id;
        newShipment.Site_of_Discharge__c = location.Id;
        newShipment.ETA_Point_of_Discharge__c = Date.newInstance(2300, 2, 17);
        newShipment.ETA_Time_Point_of_Discharge__c = Time.newInstance(18, 30, 2, 20);
        newShipment.ETD_from_Point_of_Load__c = Date.newInstance(2300, 2, 19);
        newShipment.ETD_Time_from_Point_of_Load__c = Time.newInstance(18, 30, 2, 20);
        newShipment.kms__c = 2;
        newShipment.ATA__c = Date.newInstance(2300, 2, 17);
        newShipment.ATD__c = Date.newInstance(2300, 2, 17);
        insert newShipment;

        Catalogo_SAT__c embalaje = new Catalogo_SAT__c();
        embalaje.Name = 'Envases y embalajes Test';
        embalaje.Clave_SAT__c = 'Envases y embalajes Test';
        embalaje.RecordTypeId = catalogoRT('Tipo_Embalaje');
        insert embalaje;

        Catalogo_SAT__c municion = new Catalogo_SAT__c();
        municion.Name = 'MUNICIONES INCENDIARIAS Test';
        municion.Clave_SAT__c = 'MUNICIONES INCENDIARIAS Test';
        municion.Material_PeligrosoCP__c = true;
        municion.RecordTypeId = catalogoRT('Material_Peligroso');
        insert municion;

        Catalogo_SAT__c servicio = new Catalogo_SAT__c();
        servicio.Name = 'Papel Test';
        servicio.Clave_SAT__c = '15975361';
        servicio.Material_PeligrosoCP__c = true;
        servicio.RecordTypeId = catalogoRT('Productos_y_Servicios_cP');
        insert servicio;

        Catalogo_SAT__c cajasCon = new Catalogo_SAT__c();
        cajasCon.Name = 'cajas conexion Test';
        cajasCon.Clave_SAT__c = '01264588';
        cajasCon.RecordTypeId = catalogoRT('Fraccion_Arancelaria');
        insert cajasCon;

        Container_Type__c ct = new Container_Type__c();
        ct.Name = 'test';
        insert ct;

        Shipment_Line__c cl = new Shipment_Line__c();
        cl.Name = '001';
        cl.Shipment__c = newShipment.Id;
        cl.Container_Type__c = ct.Id;
        cl.Clave_de_Servicio__c = servicio.Id;
        cl.pedimento__c = 'Test pedimiento';
        cl.Peso_Neto__c = 10;
        cl.Units_Shipped__c = 2;
        cl.Shipping_Weight_Kg__c = 2;
        cl.CP_Fraccion_Arancelaria__c = cajasCon.Id;
        cl.Material_Peligroso__c = municion.Id;
        cl.Embalaje__c = embalaje.Id;
        insert cl;

        folio.Last_Shipment__c = newShipment.Id;
        update folio;

        return newShipment;
    }
}
