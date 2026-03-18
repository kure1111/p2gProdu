@isTest()
public class PAK_ShipmentEstatusSAP_test {
    
    @isTest
    static void testEXPOMAR() {
        Test.enableChangeDataCapture();
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(false);
        
        Account accountT = new Account();
        accountT.name = 'account test';
        accountT.Customer_Id__c = '58SQL1256';
        accountT.OwnerId = UserInfo.getUserId();
        accountT.Venta_Sap__c = 'Credito'; 
        accountT.Credit_Limit__c = 6000000.00;
        accountT.Segment__c = 'Nuevo';
        insert accountT; 
        
        Catalogo_SAT__c direccion = new Catalogo_SAT__c();
        direccion.Name = '281998';
        direccion.Clave_SAT__c = '281998';        
        direccion.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();        
        insert direccion;
        
        Account_Address__c address = new Account_Address__c();
        address.Name = 'Bonafont Cln';
        address.Account__c = accountT.id;
        address.Address__c ='Conocida';
        address.Address_Coordinates__Latitude__s=  22.023033;
        address.Address_Coordinates__Longitude__s=-102.285602;
        address.Codigo_Postal_CP__c = direccion.Id;
        address.referencia__c = 'Referencias test';
        address.Type__c = 'Shipping Address';
        address.status__c = 'Validado';
        address.Active__c = true; 
        insert address;
        
        Account carrier = new Account();
        carrier.Name = 'Carrier Test';
        carrier.Brand_Name__c = 'Carrier Test';
        carrier.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
        carrier.Direccion_Principal__c = address.Id;
        carrier.Segment__c = 'Nuevo';
        insert carrier;
        
        Catalogo_SAT__c cp = new Catalogo_SAT__c();        
        cp.Name  = '980828';
        cp.Clave_SAT__c = '980828';
        cp.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();        
        insert cp;
        
        Operadores__c operador1 = new Operadores__c();
		operador1.Account__c = carrier.Id;		
        operador1.Name = 'Operador test';
        operador1.Cel_ope__c = '123456789';
        operador1.Telfij_ope__c = '123123123';
        operador1.Medprev_ope__c = '123123';
        operador1.Proovedor_validado__c = true;
        operador1.Validado__c = true;
        //operador1.Telefono_Validado__c = true;
        operador1.Operador_Validado__c = true;
        operador1.Codigo_Postal_Operador__c = cp.Id;
        operador1.RFC_Operador__c = 'TestRFC';
        operador1.Numlicvig_ope__c = '123135';
		insert operador1;
        
        
        Catalogo_SAT__c remolqueT = new Catalogo_SAT__c();        
        remolqueT.Name  = 'Caja-Test';
        remolqueT.Clave_SAT__c = 'Caja2123';
        remolqueT.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Remolque').getRecordTypeId();        
        insert remolqueT;
        
        
        Container_Type__c unidad = new Container_Type__c();
        unidad.name = 'Cajatest';
        unidad.Type__c = 'Road';
        unidad.Height_cm__c = 250;
        unidad.Length_cm__c = 1590;
        unidad.Width_cm__c = 250;
        unidad.Cargo_Weight_Kg__c = 25000;
        unidad.Cargo_Volume_m3__c = 108.500;
        insert unidad;
                
        Caja_Remolque__c remolque1 = new Caja_Remolque__c();
        remolque1.name = 'cajatest';        
        remolque1.Tipo_Remolque__c = unidad.Id;
        remolque1.Tipo_Remolque__c = remolqueT.Id;
        remolque1.Color_Caja__c = 'Blanco';
        remolque1.Num_Placa_Caja__c = 'Tes1t115';
        insert remolque1;
        
        Caja_Remolque__c remolque2 = new Caja_Remolque__c();
        remolque2.name = 'caja2test';        
        remolque2.Tipo_Remolque__c = unidad.Id;
        remolque2.Tipo_Remolque__c = remolqueT.Id;
        remolque2.Color_Caja__c = 'Blanco';
        remolque2.Num_Placa_Caja__c = 'Tes2t215';
        insert remolque2;
        
        Catalogo_SAT__c trans = new Catalogo_SAT__c();        
        trans.Name  = 'Camión-Test';
        trans.Clave_SAT__c = 'T3S7';
        trans.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Configuracion Autotransporte').getRecordTypeId();//Configuracion Autotransporte        
        insert trans;
        
        Catalogo_SAT__c permiso = new Catalogo_SAT__c();        
        permiso.Name  = 'Permiso-Test';
        permiso.Clave_SAT__c = 'Pernis23';
        permiso.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Permiso').getRecordTypeId();        
        insert permiso;
        
        
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'test';
        vehicle.Last_Location__Longitude__s = 41.40338;
        vehicle.Last_Location__Latitude__s = 2.17403;
        vehicle.Account_for_SCP__c = carrier.id;
        vehicle.Vehiculo_Validado__c = true;
        //vehicle.Container_Type__c = ctV.Id;
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
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Credito';
        insert a;
        
        
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-M-19-078949',
                                           Only_Warehouse_Service__c = true,
                                           Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador1.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now()
                                          );
        insert ship;
        
        Response__c resp = new Response__c ();
        resp.Shipment__c = ship.id;
        resp.Type__c = 'CONFIRM';
        resp.Message__c = 'Orden de Venta creada:4009208';
        insert resp;
        
        ship.Shipment_Status__c= 'ETD';
        update ship;
        Test.getEventBus().deliver();
        
    }
    
    @isTest
    static void testIMPOMAR() {
        Test.enableChangeDataCapture();
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(false);
        
        
        Account accountT = new Account();
        accountT.name = 'account test';
        accountT.Customer_Id__c = '58SQL1256';
        accountT.OwnerId = UserInfo.getUserId();
        accountT.Venta_Sap__c = 'Credito'; 
        accountT.Credit_Limit__c = 6000000.00;
        accountT.Segment__c = 'Nuevo';
        insert accountT; 
        
        Catalogo_SAT__c direccion = new Catalogo_SAT__c();
        direccion.Name = '281998';
        direccion.Clave_SAT__c = '281998';        
        direccion.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();        
        insert direccion;
        
        Account_Address__c address = new Account_Address__c();
        address.Name = 'Bonafont Cln';
        address.Account__c = accountT.id;
        address.Address__c ='Conocida';
        address.Address_Coordinates__Latitude__s=  22.023033;
        address.Address_Coordinates__Longitude__s=-102.285602;
        address.Codigo_Postal_CP__c = direccion.Id;
        address.referencia__c = 'Referencias test';
        address.Type__c = 'Shipping Address';
        address.status__c = 'Validado';
        address.Active__c = true; 
        insert address;
        
        Account carrier = new Account();
        carrier.Name = 'Carrier Test';
        carrier.Brand_Name__c = 'Carrier Test';
        carrier.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
        carrier.Direccion_Principal__c = address.Id;
        carrier.Segment__c = 'Nuevo';
        insert carrier;
        
        Catalogo_SAT__c cp = new Catalogo_SAT__c();        
        cp.Name  = '980828';
        cp.Clave_SAT__c = '980828';
        cp.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();        
        insert cp;
        
        Operadores__c operador1 = new Operadores__c();
		operador1.Account__c = carrier.Id;		
        operador1.Name = 'Operador test';
        operador1.Cel_ope__c = '123456789';
        operador1.Telfij_ope__c = '123123123';
        operador1.Medprev_ope__c = '123123';
        operador1.Proovedor_validado__c = true;
        operador1.Validado__c = true;
        //operador1.Telefono_Validado__c = true;
        operador1.Operador_Validado__c = true;
        operador1.Codigo_Postal_Operador__c = cp.Id;
        operador1.RFC_Operador__c = 'TestRFC';
        operador1.Numlicvig_ope__c = '123135';
		insert operador1;
        
        
        Catalogo_SAT__c remolqueT = new Catalogo_SAT__c();        
        remolqueT.Name  = 'Caja-Test';
        remolqueT.Clave_SAT__c = 'Caja2123';
        remolqueT.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Remolque').getRecordTypeId();        
        insert remolqueT;
        
        
        Container_Type__c unidad = new Container_Type__c();
        unidad.name = 'Cajatest';
        unidad.Type__c = 'Road';
        unidad.Height_cm__c = 250;
        unidad.Length_cm__c = 1590;
        unidad.Width_cm__c = 250;
        unidad.Cargo_Weight_Kg__c = 25000;
        unidad.Cargo_Volume_m3__c = 108.500;
        insert unidad;
                
        Caja_Remolque__c remolque1 = new Caja_Remolque__c();
        remolque1.name = 'cajatest';        
        remolque1.Tipo_Remolque__c = unidad.Id;
        remolque1.Tipo_Remolque__c = remolqueT.Id;
        remolque1.Color_Caja__c = 'Blanco';
        remolque1.Num_Placa_Caja__c = 'Tes1t115';
        insert remolque1;
        
        Caja_Remolque__c remolque2 = new Caja_Remolque__c();
        remolque2.name = 'caja2test';        
        remolque2.Tipo_Remolque__c = unidad.Id;
        remolque2.Tipo_Remolque__c = remolqueT.Id;
        remolque2.Color_Caja__c = 'Blanco';
        remolque2.Num_Placa_Caja__c = 'Tes2t215';
        insert remolque2;
        
        Catalogo_SAT__c trans = new Catalogo_SAT__c();        
        trans.Name  = 'Camión-Test';
        trans.Clave_SAT__c = 'T3S7';
        trans.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Configuracion Autotransporte').getRecordTypeId();//Configuracion Autotransporte        
        insert trans;
        
        Catalogo_SAT__c permiso = new Catalogo_SAT__c();        
        permiso.Name  = 'Permiso-Test';
        permiso.Clave_SAT__c = 'Pernis23';
        permiso.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Permiso').getRecordTypeId();        
        insert permiso;
        
        
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'test';
        vehicle.Last_Location__Longitude__s = 41.40338;
        vehicle.Last_Location__Latitude__s = 2.17403;
        vehicle.Account_for_SCP__c = carrier.id;
        vehicle.Vehiculo_Validado__c = true;
        //vehicle.Container_Type__c = ctV.Id;
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
        
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Contado';
        insert a;
        //Operadores__c operador = new Operadores__c();
        //operador.Account__c = a.Id;
        //operador.Truckstop_Email__c = 'test@neurored.com.test';
        //insert operador;
        //Vehicle__c vehicle = new Vehicle__c(Name = 'test', Last_Location__Longitude__s = 41.40338 , Last_Location__Latitude__s = 2.17403);//, 2.17403
        //insert vehicle;
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-M-19-078949',
                                           Only_Warehouse_Service__c = true,
                                           Ocean_Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador1.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now()
                                          );
        insert ship;
        
        Response__c resp = new Response__c ();
        resp.Shipment__c = ship.id;
        resp.Type__c = 'CONFIRM';
        resp.Message__c = 'Orden de Venta creada:4009208';
        insert resp;
        
        ship.Ocean_Shipment_Status__c = 'Booking Confirmation';
        update ship;
        Test.getEventBus().deliver();
        
    }
    
    @isTest
    static void testAir() {
        Test.enableChangeDataCapture();
        // TO DO: implement unit test
        
        Account accountT = new Account();
        accountT.name = 'account test';
        accountT.Customer_Id__c = '58SQL1256';
        accountT.OwnerId = UserInfo.getUserId();
        accountT.Venta_Sap__c = 'Credito'; 
        accountT.Credit_Limit__c = 6000000.00;
        accountT.Segment__c = 'Nuevo';
        insert accountT; 
        
        Catalogo_SAT__c direccion = new Catalogo_SAT__c();
        direccion.Name = '281998';
        direccion.Clave_SAT__c = '281998';        
        direccion.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();        
        insert direccion;
        
        Account_Address__c address = new Account_Address__c();
        address.Name = 'Bonafont Cln';
        address.Account__c = accountT.id;
        address.Address__c ='Conocida';
        address.Address_Coordinates__Latitude__s=  22.023033;
        address.Address_Coordinates__Longitude__s=-102.285602;
        address.Codigo_Postal_CP__c = direccion.Id;
        address.referencia__c = 'Referencias test';
        address.Type__c = 'Shipping Address';
        address.status__c = 'Validado';
        address.Active__c = true; 
        insert address;
        
        Account carrier = new Account();
        carrier.Name = 'Carrier Test';
        carrier.Brand_Name__c = 'Carrier Test';
        carrier.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
        carrier.Direccion_Principal__c = address.Id;
        carrier.Segment__c = 'Nuevo';
        insert carrier;
        
        Catalogo_SAT__c cp = new Catalogo_SAT__c();        
        cp.Name  = '980828';
        cp.Clave_SAT__c = '980828';
        cp.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();        
        insert cp;
        
        Operadores__c operador1 = new Operadores__c();
		operador1.Account__c = carrier.Id;		
        operador1.Name = 'Operador test';
        operador1.Cel_ope__c = '123456789';
        operador1.Telfij_ope__c = '123123123';
        operador1.Medprev_ope__c = '123123';
        operador1.Proovedor_validado__c = true;
        operador1.Validado__c = true;
        //operador1.Telefono_Validado__c = true;
        operador1.Operador_Validado__c = true;
        operador1.Codigo_Postal_Operador__c = cp.Id;
        operador1.RFC_Operador__c = 'TestRFC';
        operador1.Numlicvig_ope__c = '123135';
		insert operador1;
        
        
        Catalogo_SAT__c remolqueT = new Catalogo_SAT__c();        
        remolqueT.Name  = 'Caja-Test';
        remolqueT.Clave_SAT__c = 'Caja2123';
        remolqueT.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Remolque').getRecordTypeId();        
        insert remolqueT;
        
        
        Container_Type__c unidad = new Container_Type__c();
        unidad.name = 'Cajatest';
        unidad.Type__c = 'Road';
        unidad.Height_cm__c = 250;
        unidad.Length_cm__c = 1590;
        unidad.Width_cm__c = 250;
        unidad.Cargo_Weight_Kg__c = 25000;
        unidad.Cargo_Volume_m3__c = 108.500;
        insert unidad;
                
        Caja_Remolque__c remolque1 = new Caja_Remolque__c();
        remolque1.name = 'cajatest';        
        remolque1.Tipo_Remolque__c = unidad.Id;
        remolque1.Tipo_Remolque__c = remolqueT.Id;
        remolque1.Color_Caja__c = 'Blanco';
        remolque1.Num_Placa_Caja__c = 'Tes1t115';
        insert remolque1;
        
        Caja_Remolque__c remolque2 = new Caja_Remolque__c();
        remolque2.name = 'caja2test';        
        remolque2.Tipo_Remolque__c = unidad.Id;
        remolque2.Tipo_Remolque__c = remolqueT.Id;
        remolque2.Color_Caja__c = 'Blanco';
        remolque2.Num_Placa_Caja__c = 'Tes2t215';
        insert remolque2;
        
        Catalogo_SAT__c trans = new Catalogo_SAT__c();        
        trans.Name  = 'Camión-Test';
        trans.Clave_SAT__c = 'T3S7';
        trans.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Configuracion Autotransporte').getRecordTypeId();//Configuracion Autotransporte        
        insert trans;
        
        Catalogo_SAT__c permiso = new Catalogo_SAT__c();        
        permiso.Name  = 'Permiso-Test';
        permiso.Clave_SAT__c = 'Pernis23';
        permiso.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Permiso').getRecordTypeId();        
        insert permiso;
        
        
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'test';
        vehicle.Last_Location__Longitude__s = 41.40338;
        vehicle.Last_Location__Latitude__s = 2.17403;
        vehicle.Account_for_SCP__c = carrier.id;
        vehicle.Vehiculo_Validado__c = true;
        //vehicle.Container_Type__c = ctV.Id;
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
        
        NEU_StaticVariableHelper.setBoolean1(false);
        List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Contado';
        insert a;
        //Operadores__c operador = new Operadores__c();
        //operador.Account__c = a.Id;
        //operador.Truckstop_Email__c = 'test@neurored.com.test';
        //insert operador;
                        
        
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-A-19-078949',
                                           Only_Warehouse_Service__c = true,
                                           Air_Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador1.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           Traslado_Ingreso__c='Traslado',
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now()
                                          );
        insert ship;
        
        Response__c resp = new Response__c ();
        resp.Shipment__c = ship.id;
        resp.Type__c = 'CONFIRM';
        resp.Message__c = 'Orden de Venta creada:4009208';
        insert resp;
        
        ship.Air_Shipment_Status__c = 'Contact with Origin';
        update ship;
        Test.getEventBus().deliver();
        
    }
    
    @isTest
    static void testFN() {
        Test.enableChangeDataCapture();
        // TO DO: implement unit test
        NEU_StaticVariableHelper.setBoolean1(false);
        
    
        Account accountT = new Account();
        accountT.name = 'account test';
        accountT.Customer_Id__c = '58SQL1256';
        accountT.OwnerId = UserInfo.getUserId();
        accountT.Venta_Sap__c = 'Credito'; 
        accountT.Credit_Limit__c = 6000000.00;
        accountT.Segment__c = 'Nuevo';
        insert accountT; 
        
        Catalogo_SAT__c direccion = new Catalogo_SAT__c();
        direccion.Name = '281998';
        direccion.Clave_SAT__c = '281998';        
        direccion.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();        
        insert direccion;
        
        Account_Address__c address = new Account_Address__c();
        address.Name = 'Bonafont Cln';
        address.Account__c = accountT.id;
        address.Address__c ='Conocida';
        address.Address_Coordinates__Latitude__s=  22.023033;
        address.Address_Coordinates__Longitude__s=-102.285602;
        address.Codigo_Postal_CP__c = direccion.Id;
        address.referencia__c = 'Referencias test';
        address.Type__c = 'Shipping Address';
        address.status__c = 'Validado';
        address.Active__c = true; 
        insert address;

        Account_Address__c address2 = new Account_Address__c();
        address2.Name = 'Bonafont';
        address2.Account__c = accountT.id;
        address2.Address__c ='Conocida';
        address2.Address_Coordinates__Latitude__s=  21.023033;
        address2.Address_Coordinates__Longitude__s=-101.285602;
        address2.Codigo_Postal_CP__c = direccion.Id;
        address2.referencia__c = 'Referencias test';
        address2.Type__c = 'Shipping Address';
        address2.status__c = 'Validado';
        address2.Active__c = true; 
        insert address2;
        
        Account carrier = new Account();
        carrier.Name = 'Carrier Test';
        carrier.Brand_Name__c = 'Carrier Test';
        carrier.RecordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('Supply Chain Partner').getRecordTypeId();
        carrier.Direccion_Principal__c = address.Id;
        carrier.Segment__c = 'Nuevo';
        insert carrier;
        
        Catalogo_SAT__c cp = new Catalogo_SAT__c();        
        cp.Name  = '980828';
        cp.Clave_SAT__c = '980828';
        cp.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Codigo Postal').getRecordTypeId();        
        insert cp;
        
        Operadores__c operador1 = new Operadores__c();
		operador1.Account__c = carrier.Id;		
        operador1.Name = 'Operador test';
        operador1.Cel_ope__c = '123456789';
        operador1.Telfij_ope__c = '123123123';
        operador1.Medprev_ope__c = '123123';
        operador1.Proovedor_validado__c = true;
        operador1.Validado__c = true;
        //operador1.Telefono_Validado__c = true;
        operador1.Operador_Validado__c = true;
        operador1.Codigo_Postal_Operador__c = cp.Id;
        operador1.RFC_Operador__c = 'TestRFC';
        operador1.Numlicvig_ope__c = '123135';
		insert operador1;
        
        
        Catalogo_SAT__c remolqueT = new Catalogo_SAT__c();        
        remolqueT.Name  = 'Caja-Test';
        remolqueT.Clave_SAT__c = 'Caja2123';
        remolqueT.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Remolque').getRecordTypeId();        
        insert remolqueT;
        
        
        Container_Type__c unidad = new Container_Type__c();
        unidad.name = 'Cajatest';
        unidad.Type__c = 'Road';
        unidad.Height_cm__c = 250;
        unidad.Length_cm__c = 1590;
        unidad.Width_cm__c = 250;
        unidad.Cargo_Weight_Kg__c = 25000;
        unidad.Cargo_Volume_m3__c = 108.500;
        insert unidad;
                
        Caja_Remolque__c remolque1 = new Caja_Remolque__c();
        remolque1.name = 'cajatest';        
        remolque1.Tipo_Remolque__c = unidad.Id;
        remolque1.Tipo_Remolque__c = remolqueT.Id;
        remolque1.Color_Caja__c = 'Blanco';
        remolque1.Num_Placa_Caja__c = 'Tes1t115';
        insert remolque1;
        
        Caja_Remolque__c remolque2 = new Caja_Remolque__c();
        remolque2.name = 'caja2test';        
        remolque2.Tipo_Remolque__c = unidad.Id;
        remolque2.Tipo_Remolque__c = remolqueT.Id;
        remolque2.Color_Caja__c = 'Blanco';
        remolque2.Num_Placa_Caja__c = 'Tes2t215';
        insert remolque2;
        
        Catalogo_SAT__c trans = new Catalogo_SAT__c();        
        trans.Name  = 'Camión-Test';
        trans.Clave_SAT__c = 'T3S7';
        trans.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Configuracion Autotransporte').getRecordTypeId();//Configuracion Autotransporte        
        insert trans;
        
        Catalogo_SAT__c permiso = new Catalogo_SAT__c();        
        permiso.Name  = 'Permiso-Test';
        permiso.Clave_SAT__c = 'Pernis23';
        permiso.RecordTypeId = Schema.SobjectType.Catalogo_SAT__c.getRecordTypeInfosByName().get('Tipo de Permiso').getRecordTypeId();        
        insert permiso;
        
        
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'test';
        vehicle.Last_Location__Longitude__s = 41.40338;
        vehicle.Last_Location__Latitude__s = 2.17403;
        vehicle.Account_for_SCP__c = carrier.id;
        vehicle.Vehiculo_Validado__c = true;
        //vehicle.Container_Type__c = ctV.Id;
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
    
    	List<Account> list_accounts = NEU_Utils.getAccounts('Customer,');
        Account a = list_accounts[0];
        a.Venta_Sap__c ='Contado';
        insert a;
        
        Shipment__c ship = new Shipment__c(Account_for__c = a.Id, 
                                           name = 'SP-FN-20-107098',
                                           Freight_Mode__c='Road', 
                                           Service_Mode__c ='NATIONAL', 
                                           Only_Warehouse_Service__c = true,
                                           Shipment_Status__c= null,
                                           VERIFY_PAK_CONTROL__c = true,
                                           National_Operator__c = operador1.id,
                                           Operation_Executive__c =userinfo.getUserId(),
                                           Vehicle__c = vehicle.id,
                                           Traslado_Ingreso__c='Traslado',
                                           Account_Destination_Address__c=address.Id,
                                           Account_Origin_Address__C=address2.Id,
                                           ATA__c = Datetime.now(),
                                           ATD__c = Datetime.now()
                                          );
        insert ship;
        
        Response__c resp = new Response__c ();
        resp.Shipment__c = ship.id;
        resp.Type__c = 'CONFIRM';
        resp.Message__c = 'Orden de Venta creada:4009208';
        insert resp;
        
        ship.Shipment_Status_Plann__c= 'In Progress';
        ship.Shipment_Status_Mon__c = 'Finished_M';
        update ship;
        Test.getEventBus().deliver();
        
    }
    
}